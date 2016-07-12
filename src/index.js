// get the parser from the parser generator
var parser = require('./parser/parser').FunctionParser;
var Function = require('./function');

// the string to be parsed by the Function class
var functionString = "func(x, y) = 3 * (x**2) + (y**2);";

var f1 = new Function(functionString);
console.log(f1.stringRepr);
console.log(f1.appliedString(2), f1.apply({x: 2, y: 3}));

console.log(JSON.stringify(parser.parse(functionString), null, 4));
functionString = "func(4, f(5));";
console.log(JSON.stringify(parser.parse(functionString), null, 4));

