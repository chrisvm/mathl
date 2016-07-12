// get the parser from the parser generator
var parser = require('./parser').FunctionParser;
var Function = require('./function');

// the string to be parsed by the Function class
var functionString = "func(x, y) = 3 * (x**2) + (y**2)";

var f = new Function(functionString);
console.log(f.stringRepr);
console.log(f.appliedString(2), f.apply({x: 2, y: 3}));
//console.log(JSON.stringify(f.ast, null, 4));
