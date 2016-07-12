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

%start Expression

/* grammar */
%%

Expression
    : Expr
        {
            return $1;
        }
    | FunctionExpr
        {
            return $1;
        }
    ;

Expr
    : Expr 'ADD' Expr
        {
            $$ = {
                "type": "Addition",
                "left": $1,
                "right": $3
            };
        }
    | Expr 'SUB' Expr
        {
            $$ = {
                "type": "Substraction",
                "left": $1,
                "right": $3
            };
        }
    | Expr 'MULT' Expr
        {
            $$ = {
                "type": "Multiplication",
                "left": $1,
                "right": $3
            };
        }
    | Expr 'DIV' Expr
        {
            $$ = {
                "type": "Division",
                "left": $1,
                "right": $3
            };
        }
	| Expr 'MOD' Expr
		{
			$$ = {
				"type": "Modulo",
				"dividend": $1,
				"divisor": $3
			};
		}
    | Expr 'POWER' Expr
        {
            $$ = {
                "type": "Power",
                "base": $1,
                "exponent": $3
            };
        }
    | 'LPAREN' Expr 'RPAREN'
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

FunctionExpr
    : 'LPAREN' FunctionExpr 'RPAREN'
        {
            $$ = {
                "type": "Closure",
                "val": $2
            };
        }
    | 'STRING' 'LPAREN' CommaList 'RPAREN' 'EQUAL' Expr
        {
            $$ = {
                "type": "Function",
                "name": $1,
                "vars": $3,
                "val": $6
            };
        }
    ;

CommaList
	: 'STRING' 'COMMA' CommaList
		{
			$3.val.push($1);
			$$ = $3;
		}
	| 'STRING'
		{
			$$ = {
				"type": "CommaList",
				"val": [$1]
			};
		}
	;
