// get the parser from the parser generator
var parser = require('./parser/parser').MathlParser;

functionString = "print(f(5));";
console.log(JSON.stringify(parser.parse(functionString), null, 4));
