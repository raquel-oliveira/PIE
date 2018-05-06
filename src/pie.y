%{
#include "include/utils.h"
#include <stdio.h>

extern int yylex();
extern void init_lexer(char* arg);

FILE *f = fopen("pretty_printing/pretty_printing_file.txt", "w");

int tabs = 0;
void printTabs() {
	for(int i = 0; i < tabs; i++) {
		fprintf(f, "\t");
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
%token RETURN_TOKEN INT_TOKEN BOOL_TOKEN REAL_TOKEN CHAR_TOKEN STRING_TOKEN ARRAY_TOKEN RECORD_TOKEN SUBRANGE_TOKEN SET_TOKEN 
%token NIL_TOKEN LE_TOKEN GE_TOKEN EQUAL_TOKEN DIFF_TOKEN AND_TOKEN OR_TOKEN ATTR_TOKEN ACCESS_TOKEN 
%token ERROR_TOKEN RANGE_TOKEN REF_TOKEN ENDOFFILE_TOKEN

%start program

%%
program : PROGRAM_TOKEN ID_TOKEN { fprintf(f, "program %s", $2); } ';' { fprintf(f, ";\n\n"); }  decl { fprintf(f, "\n"); printTabs(); } block '.' { fprintf(f, ".\n"); }
		;
decl : consts usertypes vars subprograms
	 ;
consts :
	   | CONST_TOKEN { printTabs(); fprintf(f, "const\n"); tabs++; } listconst { tabs--; }
	   ;
listconst : constdecl listconstprime
		  ;
listconstprime :
			   | listconst
			   ;
constdecl : ID_TOKEN { printTabs(); fprintf(f, "%s", $1); } '=' { fprintf(f, " = "); } expr ';' { fprintf(f, ";\n"); }
		  ;
types : ID_TOKEN { fprintf(f, "%s", $1); } typesprime
	  | primtypes
	  ;
typesprime :
		   | subrangepart
		   | variable subrangepart
		   ;
primtypes : INT_TOKEN { fprintf(f, "int"); } 
		  | REAL_TOKEN { fprintf(f, "real"); }
		  | BOOL_TOKEN { fprintf(f, "bool"); }
		  | CHAR_TOKEN { fprintf(f, "char"); }
		  | STRING_TOKEN { fprintf(f, "string"); }
		  | arraytype
		  | settype
		  | enumtype
		  | recordtype
		  | subrangetype2 subrangepart
		  ;
arraytype : ARRAY_TOKEN '[' { fprintf(f, "array ["); } subrangelist ']' OF_TOKEN { fprintf(f, "] of "); } types
		  ;
subrangelist : subrangetype2 subrangepart subrangelistprime
			 | subrangetype1 subrangelisttype1
			 ;
subrangelisttype1 : subrangepart subrangelistprime
				  | subrangelistprime
				  ;
subrangepart : RANGE_TOKEN { fprintf(f, ".."); } subrangepartprime
			 ;
subrangepartprime : subrangetype1
				  | subrangetype2
				  ;
subrangelistprime :
				  | ',' { fprintf(f, ", "); } subrangelist
				  ;
subrangetype1 : ID_TOKEN { fprintf(f, "%s", $1); } subrangetvarpart
			 ;
subrangetype2 : INTLITERAL_TOKEN { fprintf(f, "%s", $1); }
				  | CHARLITERAL_TOKEN { fprintf(f, "%s", $1); }
				  ;
subrangetvarpart : 
				 | variable
				 ;
settype : SET_TOKEN OF_TOKEN { fprintf(f, "set of "); } types
		;
enumtype : '(' { fprintf(f, "("); } idlist ')' { fprintf(f, ")"); }
		 ;
recordtype : RECORD_TOKEN { fprintf(f, "record\n"); tabs++; } varlistlist END_TOKEN { fprintf(f, "end"); tabs--; }
		   ;
usertypes :
		  | TYPE_TOKEN { printTabs(); fprintf(f, "type\n"); tabs++; } listusertypes { tabs--; }
		  ;
listusertypes : usertype listusertypesprime
			  ;
listusertypesprime :
				   | listusertypes
				   ;
usertype : ID_TOKEN { printTabs(); fprintf(f, "%s", $1); } '=' { printTabs(); fprintf(f, " = "); } types ';' { fprintf(f, ";\n"); }
		 ;
vars :
	 | VAR_TOKEN { printTabs(); fprintf(f, "var\n"); tabs++; } varlistlist { tabs--; }
	 ;
varlistlist : varlist varlistlistprime
			;
varlistlistprime :
				 | varlistlist
				 ;
varlist : { printTabs(); } types { fprintf(f, " "); } idlist ';' { fprintf(f, ";\n"); }
		;
idlist : ID_TOKEN { fprintf(f, $1); } idattr idlistprime
	   ;
idlistprime :
			| ',' { fprintf(f, ", "); } idlist
			;
idattr :
	   | '=' { fprintf(f, "= "); } expr
	   ;
variable : ACCESS_TOKEN ID_TOKEN { fprintf(f, "->%s", $2); } variableprime
		 | '[' { fprintf(f, "["); } exprlistplus ']' { fprintf(f, "]"); } variableprime
		 ;
variableprime :
			  | variable
			  ;
block : BEGIN_TOKEN { fprintf(f, "begin\n"); tabs++; } stmts END_TOKEN { fprintf(f, "\n"); tabs--; printTabs(); fprintf(f, "end"); }
	  ;
stmts : { printTabs(); } stmt stmtlistprime
	  ;
stmtlistprime :
			  | ';' { fprintf(f, ";\n"); } stmts
			  ;
stmt :
	 | LABEL_TOKEN { fprintf(f, "%s ", $1); } stmt
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
	 | ID_TOKEN { fprintf(f, "%s", $1); } stmtprime
	 | exitstmt
	 | returnstmt
	 ;
stmtprime : attrstmt
		  | subprogcall
		  ;
subprogcall : '(' { fprintf(f, "("); } exprlist ')' { fprintf(f, ")"); }
			;
exitstmt : EXITWHEN_TOKEN { fprintf(f, "exitwhen "); } expr
		 ;
returnstmt : RETURN_TOKEN { fprintf(f, "return "); } expr
		   ;
attrstmt : variable { fprintf(f, " "); } ATTR_TOKEN { fprintf(f, ":= "); } expr
		 | { fprintf(f, " "); } ATTR_TOKEN { fprintf(f, ":= "); } expr
		 ;
ifblock : IF_TOKEN { fprintf(f, "if "); } expr { fprintf(f, "\n"); tabs++; printTabs(); } stmt { tabs--; } elseblock
		;
elseblock :
		  | ELSE_TOKEN { fprintf(f, "\n"); printTabs(); fprintf(f, "else\n"); tabs++; printTabs(); } stmt { tabs--; }
		  ;
loopblock : LOOP_TOKEN { fprintf(f, "loop\n"); tabs++; printTabs(); } stmt { tabs--; }
		  ;
caseblock : CASE_TOKEN { fprintf(f, "case "); } expr OF_TOKEN { fprintf(f, "of "); tabs++; } caselist  { tabs--; } caseblockprime
		  ;
caseblockprime :  { printTabs(); } END_TOKEN { fprintf(f, "end"); }
			   | { tabs++; printTabs(); } ELSE_TOKEN { fprintf(f, "else\n"); tabs++; printTabs(); } stmt END_TOKEN { tabs-=2; printTabs(); fprintf(f, "end"); }
			   ;
caselist : { printTabs(); } literallist ':' { fprintf(f, ":\n"); tabs++; printTabs(); } stmt ';' { fprintf(f,";\n"); tabs--; }
		 ;
literallist : literal literallistprime
			;
literallistprime :
				 | ',' { fprintf(f, ", "); } literallist
				 ;
gotostmt : GOTO_TOKEN LABEL_TOKEN { fprintf(f, "goto %s", $2); }
		 ;
forblock : FOR_TOKEN ID_TOKEN { fprintf(f, "for %s", $2); } forblockprime
		 ;
forblockprime : variable ATTR_TOKEN { fprintf(f, " := "); } expr TO_TOKEN { fprintf(f," to "); } expr STEP_TOKEN { fprintf(f, " step "); } expr DO_TOKEN { fprintf(f, " do\n"); tabs++; printTabs(); } stmt { tabs--; }
			  | ATTR_TOKEN { fprintf(f, " := "); } expr TO_TOKEN { fprintf(f, " to "); } expr STEP_TOKEN { fprintf(f, " step "); } expr DO_TOKEN { fprintf(f, " do\n"); tabs++; printTabs(); } stmt { tabs--; }
			  ;
expr : conj disj
	 ;
finalterm : ID_TOKEN { fprintf(f, "%s", $1); } finaltermprime
		  | literal
		  | '(' { fprintf(f, "("); } expr ')' { fprintf(f, ")"); } 
		  ;
finaltermprime :
			   | variable
			   | subprogcall
			   ;
disj :
	 | OR_TOKEN { fprintf(f, " || "); } conj
	 ;
conj : comp conjprime
	 ;
conjprime :
		  | AND_TOKEN { fprintf(f, " && "); } comp
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
	| '!' { fprintf(f, "!"); } mul
	;
mul : finalterm mulprime
	;
mulprime :
		 | mulop finalterm mulprime
		 ;
addop : '+' { fprintf(f, " + "); } 
	  | '-' { fprintf(f, " - "); } 
	  ;
mulop : '*' { fprintf(f, " * "); } 
	  | '/' { fprintf(f, " / "); } 
	  | '%' { fprintf(f, " % "); } 
	  ;
equalityop : EQUAL_TOKEN { fprintf(f, " == "); } 
		   | DIFF_TOKEN { fprintf(f, " != "); } 
		   ;
relationalop : '<' { fprintf(f, " < "); } 
			 | LE_TOKEN { fprintf(f, " <= "); } 
			 | '>' { fprintf(f, " > "); } 
			 | GE_TOKEN { fprintf(f, " >= "); } 
			 ;
literal : INTLITERAL_TOKEN { fprintf(f, "%s", $1); } 
    	| BOOLLITERAL_TOKEN { fprintf(f, "%s", $1); } 
		| REALLITERAL_TOKEN { fprintf(f, "%s", $1); } 
		| CHARLITERAL_TOKEN { fprintf(f, "%s", $1); } 
		| STRINGLITERAL_TOKEN { fprintf(f, "%s", $1); } 
		| SUBRANGELITERAL_TOKEN { fprintf(f, "%s", $1); } 
		;
exprlist :
		 | exprlistplus
exprlistplus : expr exprlistplusprime
			 ;
exprlistplusprime :
				  | ',' { fprintf(f, ", "); } exprlistplus
				  ;
subprograms :
			| procedure subprogramsprime
			| function subprogramsprime
			;
subprogramsprime :
				 | ';' { fprintf(f, ";\n"); } subprograms
				 ;
procedure : PROC_TOKEN ID_TOKEN { fprintf(f, "\n"); printTabs(); fprintf(f, "proc %s", $2); } '(' { fprintf(f, "("); } param ')' ';' { fprintf(f,");\n"); tabs++; } decl { fprintf(f, "\n"); printTabs(); }  block { tabs--; }
		  ;
function : FUNC_TOKEN { fprintf(f, "\n"); printTabs(); fprintf(f, "func "); } types ID_TOKEN { fprintf(f, " %s", $4); } '(' { fprintf(f,"("); } param ')' ';' { fprintf(f, ");\n"); tabs++; }  decl { fprintf(f, "\n"); printTabs(); } block { tabs--; }
		 ;
param :
	  | paramlistlist
	  ;
paramlistlist : paramlist paramlistlistprime
			  ;
paramlistlistprime :
				   | ';' { fprintf(f, "; "); }  paramlistlist
				   ;
paramlist : REF_TOKEN { fprintf(f, "ref "); } types { fprintf(f, " "); } idlist
          | types { fprintf(f, " "); } idlist
          ;
writestmt : WRITE_TOKEN '(' { fprintf(f, "write("); } expr ')' { fprintf(f, ")"); } 
		  ;
writelnstmt : WRITELN_TOKEN '(' { fprintf(f, "writeln("); } expr ')' { fprintf(f, ")"); }
		    ;
readstmt : READ_TOKEN '(' ID_TOKEN { fprintf(f, "read(%s", $3); } variableprime ')' { fprintf(f, ")"); }
		 ;
readlnstmt : READLN_TOKEN '(' ID_TOKEN { fprintf(f, "readln(%s", $3); } variableprime ')' { fprintf(f, ")"); }
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
