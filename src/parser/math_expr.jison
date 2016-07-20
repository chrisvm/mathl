/* description: creates an ast from a math equation in a string */
%lex
%%

\s+                   /* Skip Whitespace */
"PI"                  return 'PI';
"E"                   return 'E';
[0-9]+("."[0-9]+)?\b  return 'NUMBER';
[a-zA-Z_]([a-zA-Z0-9_])*     return 'STRING';
"**"                  return 'POWER';
"*"                   return 'MULT';
"/"                   return 'DIV';
"-"                   return 'SUB';
"+"                   return 'ADD';
"%"                   return 'MOD';
"("                   return 'LPAREN';
")"                   return 'RPAREN';
"="                   return 'EQUAL';
","                   return 'COMMA';
";"                   return 'SEMICOL';

/lex

%left 'ADD' 'SUB'
%left 'MULT' 'DIV' 'MOD'
%left 'POWER'

%start MathlFile

/* grammar */
%%
MathlFile
    : MathlStatement MathlFile
        {
            $2.statements.push($1);
            $$ = $2;
        }
    | MathlStatement
        {
            $$ = {
                "type": "MathlFile",
                "statements": [$1]
            };
        }
    ;

MathlStatement
    : FunctionStatement
        {
            return $1;
        }
    | FunctionCallStatement
        {
            return $1;
        }
    ;

Expression
    : MathExpr
        {
            $$ = $1;
        }
    | FunctionCallExpr
        {
            $$ = $1;
        }
    ;

MathExpr
    : MathExpr 'ADD' MathExpr
        {
            $$ = {
                "type": "Addition",
                "left": $1,
                "right": $3
            };
        }
    | MathExpr 'SUB' MathExpr
        {
            $$ = {
                "type": "Substraction",
                "left": $1,
                "right": $3
            };
        }
    | MathExpr 'MULT' MathExpr
        {
            $$ = {
                "type": "Multiplication",
                "left": $1,
                "right": $3
            };
        }
    | MathExpr 'DIV' MathExpr
        {
            $$ = {
                "type": "Division",
                "left": $1,
                "right": $3
            };
        }
	| MathExpr 'MOD' MathExpr
		{
			$$ = {
				"type": "Modulo",
				"dividend": $1,
				"divisor": $3
			};
		}
    | MathExpr 'POWER' MathExpr
        {
            $$ = {
                "type": "Power",
                "base": $1,
                "exponent": $3
            };
        }
    | 'LPAREN' MathExpr 'RPAREN'
        {
            $$ = {
                "type": "Closure",
                "val": $2
            };
        }
    | 'NUMBER'
        {
            $$ = {
                "type": "Number",
                "val": $1
            };
        }
    | 'E'
        {
            $$ = {
                "type": "Constant",
                "val": Math.E
            };
        }
    | 'PI'
        {
            $$ = {
                "type": "Constant",
                "val": Math.PI
            };
        }
    | 'STRING'
        {
            $$ = {
                "type": "Variable",
                "val": $1
            };
        }
    ;

FunctionStatement
    : 'LPAREN' FunctionStatement 'RPAREN' 'SEMICOL'
        {
            $$ = {
                "type": "Closure",
                "val": $2
            };
        }
    | 'STRING' 'LPAREN' StringCommaList 'RPAREN' 'EQUAL' MathExpr 'SEMICOL'
        {
            $$ = {
                "type": "FunctionDefinition",
                "name": $1,
                "vars": $3,
                "val": $6
            };
        }
    ;

ExprCommaList
	: Expression 'COMMA' ExprCommaList
		{
			$3.val.push($1);
			$$ = $3;
		}
	| Expression
		{
			$$ = {
				"type": "ExprCommaList",
				"val": [$1]
			};
		}
	;

FunctionCallStatement
    : FunctionCallExpr 'SEMICOL'
        {
            $$ = $1;
        }
    ;

FunctionCallExpr
    : 'STRING' 'LPAREN' ExprCommaList 'RPAREN'
        {
            $$ = {
                "type": "FunctionCall",
                "name": $1,
                "vars": $3
            };
        }
    ;