"use strict"
var jison = require('jison'),
    fs = require('fs'),
    path = require('path');

// object with the list of the
var parserJisonFiles = {
    "FunctionParser": 'math_expr.jison'
};

// itereate through the parser to create
for (var parserName in parserJisonFiles) {
    // resolve the path to the file
    var resolvedPath = path.join(__dirname, parserJisonFiles[parserName]),
        // read the file
        rawBnf = fs.readFileSync(resolvedPath, 'utf8');

    // create a jison.Parser obj with the read file and export it
    module.exports[parserName] = new jison.Parser(rawBnf);
}
