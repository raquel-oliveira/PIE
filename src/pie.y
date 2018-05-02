%{
#include "include/utils.h"
#include <stdio.h>

extern int yylex();
extern void init_lexer(char* arg);

int tabs = 0;
void printTabs() {
	for(int i = 0; i < tabs; i++) {
		printf("\t");
	}
}
int yyerror( char *s ) { fprintf( stderr, "%s\n", s); }
%}
%union {
  int id;
  int row;
  int col;
  char* lexeme;
} 

%token <lexeme> ID_TOKEN REALLITERAL_TOKEN STRINGLITERAL_TOKEN SUBRANGELITERAL_TOKEN CHARLITERAL_TOKEN INTLITERAL_TOKEN LABEL_TOKEN BOOLLITERAL_TOKEN
%token PROGRAM_TOKEN PROC_TOKEN BEGIN_TOKEN END_TOKEN FUNC_TOKEN CONST_TOKEN TYPE_TOKEN VAR_TOKEN IF_TOKEN ELSE_TOKEN GOTO_TOKEN
%token FOR_TOKEN TO_TOKEN DO_TOKEN STEP_TOKEN IN_TOKEN OF_TOKEN LOOP_TOKEN EXITWHEN_TOKEN CASE_TOKEN WRITE_TOKEN WRITELN_TOKEN READ_TOKEN READLN_TOKEN
%token RETURN_TOKEN INT_TOKEN BOOL_TOKEN REAL_TOKEN CHAR_TOKEN STRING_TOKEN ARRAY_TOKEN RECORD_TOKEN SUBRANGE_TOKEN SET_TOKEN TRUE_TOKEN FALSE_TOKEN
%token NIL_TOKEN LE_TOKEN GE_TOKEN EQUAL_TOKEN DIFF_TOKEN AND_TOKEN OR_TOKEN ATTR_TOKEN ACCESS_TOKEN 
%token ERROR_TOKEN RANGE_TOKEN REF_TOKEN ENDOFFILE_TOKEN

%start program

%%
program : PROGRAM_TOKEN ID_TOKEN { printf("program %s", $2); } ';' { printf(";\n\n"); }  decl { printf("\n"); printTabs(); } block '.' { printf(".\n"); }
		;
decl : consts usertypes vars subprograms
	 ;
consts :
	   | CONST_TOKEN { printTabs(); printf("const\n"); tabs++; } listconst { tabs--; }
	   ;
listconst : constdecl listconstprime
		  ;
listconstprime :
			   | listconst
			   ;
constdecl : ID_TOKEN { printTabs(); printf("%s", $1); } '=' { printf(" = "); } expr ';' { printf(";\n"); }
		  ;
types : ID_TOKEN { printf("%s", $1); } typesprime
	  | primtypes
	  ;
typesprime :
		   | RANGE_TOKEN { printf(".."); } subrangetype
		   ;
primtypes : INT_TOKEN { printf("int"); } typesprime 
		  | REAL_TOKEN { printf("real"); }
		  | BOOL_TOKEN { printf("bool"); }
		  | CHAR_TOKEN { printf("char"); } typesprime
		  | STRING_TOKEN { printf("string"); }
		  | arraytype
		  | settype
		  | enumtype
		  | recordtype
		  ;
arraytype : ARRAY_TOKEN '[' { printf("array ["); } subrangelist ']' OF_TOKEN { printf("] of "); } types
		  ;
subrangelist : ID_TOKEN { printf("%s", $1); } subrangeprime
			 | INT_TOKEN RANGE_TOKEN { printf(""); } subrangetype subrangelistprime
			 | CHAR_TOKEN RANGE_TOKEN subrangetype subrangelistprime
			 ;
subrangeprime : subrangelistprime
			  | RANGE_TOKEN subrangetype subrangelistprime
			  ;
subrangelistprime :
				  | ',' { printf(", "); } subrangelist
				  ;
subrangetype : ID_TOKEN
			 | INT_TOKEN
			 | CHAR_TOKEN
			 ;
settype : SET_TOKEN OF_TOKEN { printf("set of "); } types
		;
enumtype : '(' { printf("("); } idlist ')' { printf(")"); }
		 ;
recordtype : RECORD_TOKEN { printf("record\n"); tabs++; } varlistlist END_TOKEN { printf("end"); tabs--; }
		   ;
usertypes :
		  | TYPE_TOKEN { printTabs(); printf("type\n"); tabs++; } listusertypes { tabs--; }
		  ;
listusertypes : usertype listusertypesprime
			  ;
listusertypesprime :
				   | listusertypes
				   ;
usertype : ID_TOKEN { printTabs(); printf("%s", $1); } '=' { printTabs(); printf(" = "); } types ';' { printf(";\n"); }
		 ;
vars :
	 | VAR_TOKEN { printTabs(); printf("var\n"); tabs++; } varlistlist { tabs--; }
	 ;
varlistlist : varlist varlistlistprime
			;
varlistlistprime :
				 | varlistlist
				 ;
varlist : { printTabs(); } types { printf(" "); } idlist ';' { printf(";\n"); }
		;
idlist : ID_TOKEN { printf($1); } idattr idlistprime
	   ;
idlistprime :
			| ',' { printf(", "); } idlist
			;
idattr :
	   | '=' { printf("= "); } expr
	   ;
variable : ACCESS_TOKEN ID_TOKEN { printf("->%s", $2); } variableprime
		 | '[' { printf("["); } exprlistplus ']' { printf("]"); } variableprime
		 ;
variableprime :
			  | variable
			  ;
block : BEGIN_TOKEN { printf("begin\n"); tabs++; } stmts END_TOKEN { printf("\n"); tabs--; printTabs(); printf("end"); }
	  ;
stmts : { printTabs(); } stmt stmtlistprime
	  ;
stmtlistprime :
			  | ';' { printf(";\n"); } stmts
			  ;
stmt :
	 | LABEL_TOKEN { printf("%s ", $1); } stmt
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
	 | ID_TOKEN { printf("%s", $1); } stmtprime
	 | exitstmt
	 | returnstmt
	 ;
stmtprime : attrstmt
		  | subprogcall
		  ;
subprogcall : '(' { printf("("); } exprlist ')' { printf(")"); }
			;
exitstmt : EXITWHEN_TOKEN { printf("exitwhen "); } expr
		 ;
returnstmt : RETURN_TOKEN { printf("return "); } expr
		   ;
attrstmt : variable { printf(" "); } ATTR_TOKEN { printf(":= "); } expr
		 | { printf(" "); } ATTR_TOKEN { printf(":= "); } expr
		 ;
ifblock : IF_TOKEN { printf("if "); } expr { printf("\n"); tabs++; printTabs(); } stmt { printf("\n"); tabs--; } elseblock
		;
elseblock :
		  | ELSE_TOKEN { printTabs(); printf("else\n"); tabs++; printTabs(); } stmt { tabs--; }
		  ;
loopblock : LOOP_TOKEN { printf("loop\n"); tabs++; printTabs(); } stmt { tabs--; }
		  ;
caseblock : CASE_TOKEN { printf("case "); } expr OF_TOKEN { printf("of "); tabs++; } caselist  { tabs--; } caseblockprime
		  ;
caseblockprime :  { printTabs(); } END_TOKEN { printf("end"); }
			   | { tabs++; printTabs(); } ELSE_TOKEN { printf("else\n"); tabs++; printTabs(); } stmt END_TOKEN { tabs-=2; printTabs(); printf("end"); }
			   ;
caselist : { printTabs(); } literallist ':' { printf(":\n"); tabs++; printTabs(); } stmt ';' { printf(";\n"); tabs--; }
		 ;
literallist : literal literallistprime
			;
literallistprime :
				 | ',' { printf(", "); } literallist
				 ;
gotostmt : GOTO_TOKEN LABEL_TOKEN { printf("goto %s", $2); }
		 ;
forblock : FOR_TOKEN ID_TOKEN { printf("for %s", $2); } forblockprime
		 ;
forblockprime : variable ATTR_TOKEN { printf(" := "); } expr TO_TOKEN { printf(" to "); } expr STEP_TOKEN { printf(" step "); } expr DO_TOKEN { printf(" do\n"); tabs++; printTabs(); } stmt { tabs--; }
			  | ATTR_TOKEN { printf(" := "); } expr TO_TOKEN { printf(" to "); } expr STEP_TOKEN { printf(" step "); } expr DO_TOKEN { printf(" do\n"); tabs++; printTabs(); } stmt { tabs--; }
			  ;
expr : conj disj
	 ;
finalterm : ID_TOKEN { printf("%s", $1); } finaltermprime
		  | literal
		  | '(' { printf("("); } expr ')' { printf(")"); } 
		  ;
finaltermprime :
			   | variable
			   | subprogcall
			   ;
disj :
	 | OR_TOKEN { printf(" || "); } conj
	 ;
conj : comp conjprime
	 ;
conjprime :
		  | AND_TOKEN { printf(" && "); } comp
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
	| '!' { printf("!"); } mul
	;
mul : finalterm mulprime
	;
mulprime :
		 | mulop finalterm mulprime
		 ;
addop : '+' { printf(" + "); } 
	  | '-' { printf(" - "); } 
	  ;
mulop : '*' { printf(" * "); } 
	  | '/' { printf(" / "); } 
	  | '%' { printf(" % "); } 
	  ;
equalityop : EQUAL_TOKEN { printf(" == "); } 
		   | DIFF_TOKEN { printf(" != "); } 
		   ;
relationalop : '<' { printf(" < "); } 
			 | LE_TOKEN { printf(" <= "); } 
			 | '>' { printf(" > "); } 
			 | GE_TOKEN { printf(" >= "); } 
			 ;
literal : INTLITERAL_TOKEN { printf("%s", $1); } 
    	| BOOLLITERAL_TOKEN { printf("%s", $1); } 
		| REALLITERAL_TOKEN { printf("%s", $1); } 
		| CHARLITERAL_TOKEN { printf("%s", $1); } 
		| STRINGLITERAL_TOKEN { printf("%s", $1); } 
		| SUBRANGELITERAL_TOKEN { printf("%s", $1); } 
		;
exprlist :
		 | exprlistplus
exprlistplus : expr exprlistplusprime
			 ;
exprlistplusprime :
				  | ',' { printf(", "); } exprlistplus
				  ;
subprograms :
			| procedure subprogramsprime
			| function subprogramsprime
			;
subprogramsprime :
				 | ';' { printf(";\n"); } subprograms
				 ;
procedure : PROC_TOKEN ID_TOKEN { printf("\nproc %s", $2); } '(' { printf("("); } param ')' ';' { printf(");\n"); tabs++; } decl { printTabs(); } block { tabs--; }
		  ;
function : FUNC_TOKEN { printf("\nfunc "); } types ID_TOKEN { printf(" %s", $4); } '(' { printf("("); } param ')' ';'{  printf(");\n"); tabs++; }  decl { printTabs(); } block { tabs--; }
		 ;
param :
	  | paramlistlist
	  ;
paramlistlist : paramlist paramlistlistprime
			  ;
paramlistlistprime :
				   | ';' { printf("; "); }  paramlistlist
				   ;
paramlist : REF_TOKEN { printf("ref "); } types { printf(" "); } idlist
          | types { printf(" "); } idlist
          ;
writestmt : WRITE_TOKEN '(' { printf("write("); } expr ')' { printf(")"); } 
		  ;
writelnstmt : WRITELN_TOKEN '(' { printf("writeln("); } expr ')' { printf(")"); }
		    ;
readstmt : READ_TOKEN '(' ID_TOKEN { printf("read(%s", $3); } variableprime ')' { printf(")"); }
		 ;
readlnstmt : READLN_TOKEN '(' ID_TOKEN { printf("readln(%s", $3); } variableprime ')' { printf(")"); }
		   ;
%%

int main(int argc, char *argv[]) {
	if(argc < 2) {
		printf("Not enough arguments.");
		return 0;
	}
	init_lexer(argv[1]);
	yyparse();
	return 0;
}
