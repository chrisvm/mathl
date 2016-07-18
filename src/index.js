// get the parser from the parser generator
var parser = require('./parser/parser').FunctionParser;
var Function = require('./function');

functionString = "func(4, f(5));";
console.log(JSON.stringify(parser.parse(functionString), null, 4));
