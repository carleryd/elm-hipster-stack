var fs             = require('fs');
var LRU            = require('lru-cache');
var resolveCommand = require('./resolveCommand');
var mixIn          = require('./util/mixIn');

var isWin        = process.platform === 'win32';
var shebangCache = LRU({ max: 50, maxAge: 30 * 1000 });  // Cache just for 30sec

function readShebang(command) {
    var buffer;
    var fd;
    var match;
    var shebang;

    // Check if it is in the cache first
    if (shebangCache.has(command)) {
        return shebangCache.get(command);
    }

    // Read the first 150 bytes from the file
    buffer = new Buffer(150);

    try {
        fd = fs.openSync(command, 'r');
        fs.readSync(fd, buffer, 0, 150, 0);
        fs.closeSync(fd);
    } catch (e) {}

    // Check if it is a shebang
    match = buffer.toString().trim().match(/\#\!(.+)/i);

    if (match) {
        shebang = match[1].replace(/\/usr\/bin\/env\s+/i, '');   // Remove /usr/bin/env
    }

    // Store the shebang in the cache
    shebangCache.set(command, shebang);

    return shebang;
}

function escapeArg(arg, skipQuote) {
    // Convert to string
    arg = '' + arg;

    // Escaped based on: http://qntm.org/cmd
    // Unless we're told otherwise, don't quote unless we actually need to do so,
    // hopefully avoid problems if programs won't parse quotes properly
    if (!skipQuote && (!arg || /[\s"]/.test(arg))) {
        // Sequence of backslashes followed by a double quote:
        // double up all the backslashes and escape the double quote
        arg = arg.replace(/(\\*)"/g, '$1$1\\"');

        // Sequence of backslashes followed by the end of the string
        // (which will become a double quote later):
        // double up all the backslashes
        arg = arg.replace(/(\\*)$/, '$1$1');

        // All other backslashes occur literally

        // Quote the whole thing:
        arg = '"' + arg + '"';
    }

    // Finally escape shell meta chars
    arg = arg.replace(/([\(\)%!\^<>&|;,"'\s])/g, '^$1');

    return arg;
}

function parseCall(command, args, options) {
    var shebang;
    var skipQuotes;
    var file;
    var original;

    // Normalize arguments, similar to nodejs
    if (args && !Array.isArray(args)) {
        options = args;
        args = null;
    }

    args = args ? args.slice(0) : [];  // Clone array to avoid changing the original
    options = mixIn({}, options);
    original = command;

    if (isWin) {
        // Detect & add support for shebangs
        file = resolveCommand(command);
        file = file || resolveCommand(command, true);
        shebang = file && readShebang(file);

        if (shebang) {
            args.unshift(file);
            command = shebang;
        }

        // Escape command & arguments
        skipQuotes = command === 'echo';  // Do not quote arguments for the special "echo" command
        command = escapeArg(command);
        args = args.map(function (arg) {
            return escapeArg(arg, skipQuotes);
        });

        // Use cmd.exe
        args = ['/s', '/c', '"' + command + (args.length ? ' ' + args.join(' ') : '') + '"'];
        command = process.env.comspec || 'cmd.exe';

        // Tell node's spawn that the arguments are already escaped
        options.windowsVerbatimArguments = true;
    }

    return {
        command: command,
        args: args,
        options: options,
        file: file,
        original: original
    };
}

module.exports = parseCall;
