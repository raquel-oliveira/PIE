%{
#include <iostream>
#include "../include/utils.h"

bool yydebug = false;
%}
%union {
  int id;
  int row;
  int col;
  char* lexeme;
}

%token PROGRAM_TOKEN PROC_TOKEN BEGIN_TOKEN END_TOKEN FUNC_TOKEN CONST_TOKEN TYPE_TOKEN VAR_TOKEN IF_TOKEN ELSE_TOKEN GOTO_TOKEN
%token FOR_TOKEN TO_TOKEN DO_TOKEN STEP_TOKEN IN_TOKEN OF_TOKEN LOOP_TOKEN EXITWHEN_TOKEN CASE_TOKEN WRITE_TOKEN WRITELN_TOKEN READ_TOKEN READLN_TOKEN
%token RETURN_TOKEN INT_TOKEN BOOL_TOKEN REAL_TOKEN CHAR_TOKEN STRING_TOKEN ARRAY_TOKEN RECORD_TOKEN SUBRANGE_TOKEN SET_TOKEN BOOLLITERAL_TOKEN
%token NIL_TOKEN LE_TOKEN GE_TOKEN EQUAL_TOKEN DIFF_TOKEN AND_TOKEN OR_TOKEN ATTR_TOKEN ACCESS_TOKEN LABEL_TOKEN CHARLITERAL_TOKEN INTLITERAL_TOKEN
%token REALLITERAL_TOKEN STRINGLITERAL_TOKEN SUBRANGELITERAL_TOKEN ID_TOKEN ERROR_TOKEN RANGE_TOKEN REF_TOKEN

%start program

%%
program : PROGRAM_TOKEN ID_TOKEN ';' decl block '.'
		;
decl : consts usertypes vars subprograms
	 ;
consts :
	   | CONST_TOKEN listconst
	   ;
listconst : constdecl listconstprime
		  ;
listconstprime :
			   | listconst
			   ;
constdecl : ID_TOKEN '=' expr ';'
		  ;
types : ID_TOKEN typesprime
	  | primtypes
	  ;
typesprime :
		   | SUBRANGE_TOKEN subrangetype
		   ;
primtypes : INT_TOKEN typesprime
		  | REAL_TOKEN
		  | BOOL_TOKEN
		  | CHAR_TOKEN typesprime
		  | STRING_TOKEN
		  | arraytype
		  | settype
		  | enumtype
		  | recordtype
		  ;
arraytype : ARRAY_TOKEN '[' subrangelist ']' OF_TOKEN types
		  ;
subrangelist : ID_TOKEN subrangeprime
			 | INT_TOKEN SUBRANGE_TOKEN subrangetype subrangelistprime
			 | CHAR_TOKEN SUBRANGE_TOKEN subrangetype subrangelistprime
			 ;
subrangeprime : subrangelistprime
			  | SUBRANGE_TOKEN subrangetype subrangelistprime
			  ;
subrangelistprime :
				  | ',' subrangelist
				  ;
subrangetype : ID_TOKEN
			 | INT_TOKEN
			 | CHAR_TOKEN
			 ;
settype : SET_TOKEN OF_TOKEN types
		;
enumtype : '(' idlist ')'
		 ;
recordtype : RECORD_TOKEN varlistlist END_TOKEN
		   ;
usertypes :
		  | TYPE_TOKEN listusertypes
		  ;
listusertypes : usertype listusertypesprime
			  ;
listusertypesprime :
				   | listusertypes
				   ;
usertype : ID_TOKEN '=' types ';'
		 ;
vars :
	 | VAR_TOKEN varlistlist
	 ;
varlistlist : varlist varlistlistprime
			;
varlistlistprime :
				 | varlistlist
				 ;
varlist : types idlist ';'
		;
idlist : ID_TOKEN idattr idlistprime
	   ;
idlistprime :
			| ',' idlist
			;
idattr :
	   | '=' expr
	   ;
variable : ACCESS_TOKEN ID_TOKEN variableprime
		 | '[' exprlistplus ']' variableprime
		 ;
variableprime :
			  | variable
			  ;
block : BEGIN_TOKEN stmts END_TOKEN
	  ;
stmts : stmt stmtlistprime
	  ;
stmtlistprime :
			  | ';' stmts
			  ;
stmt :
	 | LABEL_TOKEN stmt
	 | block
	 | writestmt
	 | writelnstmt
	 | readstmt
	 | readlnstmt
	 | loopblock
	 | ifblock
	 | forblock
	 | caseblock
	 | gotostmt
	 | ID_TOKEN stmtprime
	 | exitstmt
	 | returnstmt
	 ;
stmtprime : attrstmt
		  | subprogcall
		  ;
subprogcall : '(' exprlist ')'
			;
exitstmt : EXITWHEN_TOKEN expr
		 ;
returnstmt : RETURN_TOKEN expr
		   ;
attrstmt : variable ATTR_TOKEN expr
		 | ATTR_TOKEN expr
		 ;
ifblock : IF_TOKEN expr stmt elseblock
		;
elseblock :
		  | ELSE_TOKEN stmt
		  ;
loopblock : LOOP_TOKEN stmt
		  ;
caseblock : CASE_TOKEN expr OF_TOKEN caselist caseblockprime
		  ;
caseblockprime : END_TOKEN
			   | ELSE_TOKEN stmt END_TOKEN
			   ;
caselist : literallist ':' stmt ';'
		 ;
literallist : literal literallistprime
			;
literallistprime :
				 | ',' literallist
				 ;
gotostmt : GOTO_TOKEN LABEL_TOKEN
		 ;
forblock : FOR_TOKEN ID_TOKEN forblockprime
		 ;
forblockprime : variable ATTR_TOKEN expr TO_TOKEN expr STEP_TOKEN expr DO_TOKEN stmt
			  | ATTR_TOKEN expr TO_TOKEN expr STEP_TOKEN expr DO_TOKEN stmt
			  ;
expr : conj disj
	 ;
finalterm : ID_TOKEN finaltermprime
		  | literal
		  | '(' expr ')'
		  ;
finaltermprime :
			   | variable
			   | subprogcall
			   ;
disj :
	 | OR_TOKEN conj
	 ;
conj : comp conjprime
	 ;
conjprime :
		  | AND_TOKEN comp
		  ;
comp : relational compprime
	 ;
relational : sum relationalprime
		   ;
relationalprime :
				| relationalop sum
				;
compprime :
		  | equalityop relational
		  ;
sum : neg sumprime
	;
sumprime :
		 | addop neg sumprime
		 ;
neg : mul
	| '!' mul
	;
mul : finalterm mulprime
	;
mulprime :
		 | mulop finalterm mulprime
		 ;
addop : '+'
	  | '-'
	  ;
mulop : '*'
	  | '/'
	  | '%'
	  ;
equalityop : EQUAL_TOKEN
		   | DIFF_TOKEN
		   ;
relationalop : '<'
			 | LE_TOKEN
			 | '>'
			 | GE_TOKEN
			 ;
literal : INTLITERAL_TOKEN
    | BOOLLITERAL_TOKEN
		| REALLITERAL_TOKEN
		| CHARLITERAL_TOKEN
		| STRINGLITERAL_TOKEN
		| SUBRANGELITERAL_TOKEN
		;
exprlist :
		 | exprlistplus
exprlistplus : expr exprlistplusprime
			 ;
exprlistplusprime :
				  | ',' exprlistplus
				  ;
subprograms :
			| procedure subprogramsprime
			| function subprogramsprime
			;
subprogramsprime :
				 | ';' subprograms
				 ;
procedure : PROC_TOKEN ID_TOKEN '(' param ')' ';' decl block
		  ;
function : FUNC_TOKEN types ID_TOKEN '(' param ')' ';' decl block
		 ;
param :
	  | paramlistlist
	  ;
paramlistlist : paramlist paramlistlistprime
			  ;
paramlistlistprime :
				   | ';' paramlistlist
				   ;
paramlist : REF_TOKEN types idlist
          | types idlist
          ;
writestmt : WRITE_TOKEN '(' expr ')'
		  ;
writelnstmt : WRITELN_TOKEN '(' expr ')'
		    ;
readstmt : READ_TOKEN '(' ID_TOKEN variableprime ')'
		 ;
readlnstmt : READLN_TOKEN '(' ID_TOKEN variableprime ')'
		   ;
%%

#include "lex.yy.c"

main() {
	yyparse();
}

int yyerror( char *s ) { fprintf( stderr, "%s\n", s); }
