'use strict';

var spawn = require("cross-spawn");
var _ = require("lodash");
var compilerBinaryName = "elm-make";
var fs = require("fs");
var path = require("path");
var temp = require("temp");

var defaultOptions     = {
  emitWarning: console.warn,
  spawn:      spawn,
  cwd:        undefined,
  pathToMake: undefined,
  yes:        undefined,
  help:       undefined,
  output:     undefined,
  warn:       undefined,
  verbose:    false
};

var supportedOptions = _.keys(defaultOptions);


function compile(sources, options) {
  if (typeof sources === "string") {
    sources = [sources];
  }

  if (!(sources instanceof Array)) {
    throw "compile() received neither an Array nor a String for its sources argument."
  }

  options = _.defaults({}, options, defaultOptions);

  if (typeof options.spawn !== "function") {
    throw "options.spawn was a(n) " + (typeof options.spawn) + " instead of a function."
  }

  var compilerArgs = compilerArgsFromOptions(options, options.emitWarning);
  var processArgs  = sources ? sources.concat(compilerArgs) : compilerArgs;
  var env = _.merge({LANG: 'en_US.UTF-8'}, process.env);
  var processOpts = _.merge({env: env, stdio: "inherit", cwd: options.cwd});
  var pathToMake = options.pathToMake || compilerBinaryName;
  var verbose = options.verbose;

  try {
    if (verbose) {
      console.log(["Running", pathToMake].concat(processArgs || []).join(" "));
    }

    return options.spawn(pathToMake, processArgs, processOpts)
      .on('error', function(err) {
        handleError(pathToMake, err);

        process.exit(1)
      });
  } catch (err) {
    if ((typeof err === "object") && (typeof err.code === "string")) {
      handleError(pathToMake, err);
    } else {
      console.error("Exception thrown when attempting to run Elm compiler " + JSON.stringify(pathToMake) + ":\n" + err);
    }

    process.exit(1)
  }
}

// Returns a Promise that returns a flat list of all the Elm files the given
// Elm file depends on, based on the modules it loads via `import`.
function findAllDependencies(file, knownDependencies, baseDir) {
  if (!knownDependencies) {
    knownDependencies = [];
  }

  if (!baseDir) {
    baseDir = path.dirname(file);
  }

  return new Promise(function(resolve, reject) {

    fs.readFile(file, {encoding: "utf8"}, function(err, lines) {
      if (err) {
        reject(err);
      } else {
        // Turn e.g. ~/code/elm-css/src/Css.elm
        // into just ~/code/elm-css/src/
        var newImports = _.compact(lines.split("\n").map(function(line) {
          var matches = line.match(/^import\s+([^\s]+)/);

          if (matches) {
            // e.g. Css.Declarations
            var moduleName = matches[1];

            // e.g. Css/Declarations
            var dependencyLogicalName = moduleName.replace(/\./g, "/");

            // e.g. ~/code/elm-css/src/Css/Declarations.elm
            var result = path.join(baseDir, dependencyLogicalName)

            return _.contains(knownDependencies, result) ? null : result;
          } else {
            return null;
          }
        }));

        var promises = newImports.map(function(newImport) {
          var elmFile = newImport + ".elm";

          return new Promise(function(resolve, reject) {
            return checkIsFile(newImport + ".elm").then(resolve).catch(function(firstErr) {
              if (firstErr.code === "ENOENT") {
                // If we couldn't find the import as a .elm file, try as .js
                checkIsFile(newImport + ".js").then(resolve).catch(function(secondErr) {
                  if (secondErr.code === "ENOENT") {
                    // If we don't find the dependency in our filesystem, assume it's because
                    // it comes in through a third-party package rather than our sources.
                    resolve([]);
                  } else {
                    reject(secondErr);
                  }
                })
              } else {
                reject(firstErr);
              }
            });
          });
        });

        Promise.all(promises).then(function(nestedValidDependencies) {
          var validDependencies = _.flatten(nestedValidDependencies);
          var newDependencies = knownDependencies.concat(validDependencies);
          var recursePromises = _.compact(validDependencies.map(function(dependency) {
            return path.extname(dependency) === ".elm" ?
              findAllDependencies(dependency, newDependencies, baseDir) : null;
          }));

          Promise.all(recursePromises).then(function(extraDependencies) {
            resolve(_.uniq(_.flatten(newDependencies.concat(extraDependencies))));
          }).catch(reject);
        }).catch(reject);
      }
    });
  });
}

// write compiled Elm to a string output
// returns a Promise which will contain a Buffer of the text
// If you want html instead of js, use options object to set
// output to a html file instead
// creates a temp file and deletes it after reading
function compileToString(sources, options){
  if (typeof options.output === "undefined"){
    options.output = '.js';
  }

  return new Promise(function(resolve, reject){
    temp.open({ suffix: options.output }, function(err, info){
      if (err){
        return reject(err);
      }

      options.output = info.path;

      compile(sources, options)
        .on("close", function(exitCode){
          fs.readFile(info.path, function(err, data){
            if (exitCode !== 0) {
              err = "Compiler process exited with code " + exitCode;
            }

            temp.cleanupSync();

            return err ? reject(err) : resolve(data);
          });
        });
    });
  });
}

function checkIsFile(file) {
  return new Promise(function(resolve, reject) {
    fs.stat(file, function(err, stats) {
      if (err) {
        reject(err);
      } else if (stats.isFile()) {
        resolve([file]);
      } else {
        resolve([]);
      }
    });
  });
}

function handleError(pathToMake, err) {
  if (err.code === "ENOENT") {
    console.error("Could not find Elm compiler \"" + pathToMake + "\". Is it installed?")
  } else if (err.code === "EACCES") {
    console.error("Elm compiler \"" + pathToMake + "\" did not have permission to run. Do you need to give it executable permissions?");
  } else {
    console.error("Error attempting to run Elm compiler \"" + pathToMake + "\":\n" + err);
  }
}

function escapePath(pathStr) {
  return pathStr.replace(/ /g, "\\ ");
}

// Converts an object of key/value pairs to an array of arguments suitable
// to be passed to child_process.spawn for elm-make.
function compilerArgsFromOptions(options, emitWarning) {
  return _.flatten(_.map(options, function(value, opt) {
    if (value) {
      switch(opt) {
        case "yes":    return ["--yes"];
        case "help":   return ["--help"];
        case "output": return ["--output", escapePath(value)];
        case "warn":   return ["--warn"];
        default:
          if (supportedOptions.indexOf(opt) === -1) {
            emitWarning('Unknown Elm compiler option: ' + opt);
          }

          return [];
      }
    } else {
      return [];
    }
  }));
}

module.exports = {
  compile: compile,
  compileToString: compileToString,
  findAllDependencies: findAllDependencies
};
