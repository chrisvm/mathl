"use strict"
var parser = require('./parser').FunctionParser,
	_ = require('lodash');

/**
 * Represents a function
 */
class Function {
    constructor(funcString) {
        this.stringRepr = funcString;
        this.ast = parser.parse(this.stringRepr);

		// the vars in the CommaList
        this.variable = this.ast.var;

		// check all vars in CommaList are used in the definition of the func
		this.validateVars();
    }

	validateVars() {
			var queue = [this.ast.val];

			// get all var used in
			var used = new Set(this.ast.vars.val), node = queue.shift();

			while (node != undefined) {
				if (node.type == 'Variable') {
					if (!used.delete(node.val)) {
						throw new Error("var in definition that is not in the list");
					}
				}

				// add child nodes depending on the node
				if (_.findIndex(node.type, ['Addition', 'Substraction', 'Multiplication', 'Division'])) {
					queue.push(node.left);
					queue.push(node.right);
				}

				if (node.type == 'Closure') {
					queue.push(node.val);
				}

				if (node.type == 'Power') {
					queue.push(node.base);
					queue.push(node.exponent);
				}

				if (node.type == 'Modulus') {
					queue.push(node.dividend);
					queue.push(node.divisor);
				}
				node = queue.shift();
			}
	}

    apply(vars) {

		for (var varName of this.ast.vars.val) {
			if (!_.has(vars, varName)) {
				throw new Error("Not all variables applied");
			}
		}

        return this._rapply(vars, this.ast.val);
    }

    appliedString(integer) {
        return `${this.ast.name}(${integer}) =`;
    }

    /**
     * Recusively evaluate the function abstract syntax tree
     * @param integer the number to use to evaluate the variables
     * @param ast the abstract syntax tree object obtained from parsing the string
     * @returns the function applied with the variable set to integer
     * @private
     */
    _rapply(vars, ast) {
        if (ast.type == 'Closure') {
            return this._rapply(vars, ast.val);
        }

        if (ast.type == 'Addition') {
            return this._rapply(vars, ast.left) + this._rapply(vars, ast.right);
        }

        if (ast.type == 'Substraction') {
            return this._rapply(vars, ast.left) - this._rapply(vars, ast.right);
        }

        if (ast.type == 'Multiplication') {
            return this._rapply(vars, ast.left) * this._rapply(vars, ast.right);
        }

		if (ast.type == 'Modulo') {
			return eval(ast.dividend) % eval(ast.divisor);
		}

        if (ast.type == 'Division') {
            return this._rapply(vars, ast.left) / this._rapply(vars, ast.right);
        }

        if (ast.type == 'Power') {
            return Math.pow(this._rapply(vars, ast.base), this._rapply(vars, ast.exponent));
        }

        if (ast.type == 'Number') {
            return parseInt(ast.val);
        }

        if (ast.type == 'PI' || ast.type == 'E') {
            return ast.val;
        }

        if (ast.type == 'Variable') {
            if (_.has(vars, ast.val)) {
				return vars[ast.val];
			}
			throw new Error(`Variable "${ast.val}" not applied in eval`);
        }
    }
}

module.exports = Function;
