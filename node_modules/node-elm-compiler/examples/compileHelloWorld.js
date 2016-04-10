var compile = require("../index.js").compile;
var compileToString = require("../index.js").compileToString;

compile(["./HelloWorld.elm"], {
  output: "compiled-hello-world.js"
}).on('close', function(exitCode) {
  console.log("Finished with exit code", exitCode);
});


compileToString(["./HelloWorld.elm"], { yes: true }).then(function(data){
    console.log("Text", data.toString());
});

compileToString(["./HelloWorld.elm"], { yes: true, output: "index.html" }).then(function(data){
    console.log("Text", data.toString());
});
