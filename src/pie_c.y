%{
#include "include/utils.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <iostream>

extern int yylex();
extern void init_lexer(char* arg);

extern int num_column;
extern int num_line;
extern char* lex;
extern char* file_path;
int lastlabel = 0;

FILE *f;

char*  getPathFile (char *arg){
	char * file_input = arg;
	char * folder = strtok (file_input,"/");
	char * file = strtok (NULL,"/");
	if (file == NULL ) file = folder;
	char * file_name = strcat(strtok (file,"."), ".c");

	char *path_name = NULL;
	path_name = (char*) malloc (strlen("generated_code/") + strlen(file_name) + 1);

	strcpy(path_name, "generated_code/");
	strcat(path_name, file_name);
	char * out = path_name;
	return out;
}

bool io = false;

std::string includes() {
	std::string str = "";
	if (io) {
		str += "#include <stdio.h>\n\n";
		io = false;
	}
	return str;
}

std::string get_io_type(std::string s) {
	if (s == "int") {
		return "%i";
	} else if (s == "float") {
		return "%f";
	} else if (s == "bool") {
		return "%d";
	} else if (s == "char") {
		return "%c";
	} else if (s == "char*") {
		return "%s";
	}
	return "";
}

std::map<std::string, std::string> st_union(const std::map<std::string, std::string>& st1, const std::map<std::string, std::string>& st2) {
	std::map<std::string, std::string> unionST;
	unionST.insert(st1.begin(), st1.end());
	unionST.insert(st2.begin(), st2.end());
	return unionST;
}

std::map<std::string,std::string> addIds(std::string type, std::vector<std::string>& ids) {
	std::map<std::string,std::string> ST;
	for(int i = 0; i < ids.size(); i++) {
		ST[ids[i]] = type;
	}
	return ST;
}


std::string generateNewLabel() {
	int oneMore = lastlabel + 1;
	lastlabel++;
	std::string newLabel = "_$" + std::to_string(oneMore);
	return newLabel ;
}

int yyerror( char *s ) { fprintf( stderr, "%s\nLine: %d, column: %d at token: %s \n", s, num_line, num_column, lex); }
%}
%define api.value.type {struct {
  int id;
  int row;
  int col;
  char* lexeme;
  Attributes attrs;
}}

%token <lexeme> ID_TOKEN REALLITERAL_TOKEN STRINGLITERAL_TOKEN SUBRANGELITERAL_TOKEN CHARLITERAL_TOKEN INTLITERAL_TOKEN LABEL_TOKEN BOOLLITERAL_TOKEN
%token CONST_TOKEN PROGRAM_TOKEN PROC_TOKEN BEGIN_TOKEN END_TOKEN FUNC_TOKEN TYPE_TOKEN VAR_TOKEN IF_TOKEN ELSE_TOKEN GOTO_TOKEN
%token FOR_TOKEN TO_TOKEN DO_TOKEN STEP_TOKEN OF_TOKEN LOOP_TOKEN EXITWHEN_TOKEN CASE_TOKEN WRITE_TOKEN WRITELN_TOKEN READ_TOKEN READLN_TOKEN
%token RETURN_TOKEN INT_TOKEN BOOL_TOKEN REAL_TOKEN CHAR_TOKEN STRING_TOKEN ARRAY_TOKEN RECORD_TOKEN SET_TOKEN
%token NIL_TOKEN LE_TOKEN GE_TOKEN EQUAL_TOKEN DIFF_TOKEN AND_TOKEN OR_TOKEN ATTR_TOKEN ACCESS_TOKEN
%token ERROR_TOKEN RANGE_TOKEN REF_TOKEN ENDOFFILE_TOKEN

%type <attrs> program decl consts listconst listconstprime constdecl types typesprime primtypes arraytype subrangelist subrangelisttype1 subrangepart subrangepartprime subrangelistprime subrangetype1 subrangetype2 subrangetvarpart settype enumtype recordtype usertypes listusertypes listusertypesprime usertype vars varlistlist varlistlistprime varlist idlist idlistprime idattr variable variableprime block stmts stmtlistprime stmt stmtprime subprogcall exitstmt returnstmt attrstmt ifblock elseblock loopblock caseblock caseblockprime caselist literallist literallistprime gotostmt forblock forblockprime expr finalterm finaltermprime disj conj conjprime comp relational relationalprime compprime sum sumprime neg mul mulprime addop mulop equalityop relationalop literal exprlist exprlistplus exprlistplusprime subprograms subprogramsprime procedure function param paramlistlist paramlistlistprime paramlist writestmt writelnstmt readstmt readlnstmt A B C D E

%start program

%%
program : PROGRAM_TOKEN ID_TOKEN ';' decl block '.' { $$.cs = includes() + $4.cs + "void main() " + $5.cs; fprintf(f, "%s", $$.cs.c_str()); }
		;
decl : consts usertypes vars subprograms { $$.sts = st_union($1.sts, st_union($2.sts, $3.sts)); $$.cs = $1.cs + $2.cs + $3.cs; }
	 ;
consts : { $$.cs = ""; }
	   | CONST_TOKEN listconst { $$.sts = $2.sts; $$.cs = $2.cs; }
	   ;
listconst : constdecl listconstprime { $$.sts = st_union($1.sts, $2.sts); $$.cs = $1.cs + $2.cs; }
		  ;
listconstprime : { $$.cs = ""; }
			   | listconst { $$.sts = $1.sts; $$.cs = $1.cs; }
			   ;
constdecl : ID_TOKEN '=' expr ';' { $$.sts[$1] = $3.type; $$.cs = "const " + $3.type + " " + $1 + " = " + $3.cs + ";\n"; }
		  ;
types : ID_TOKEN typesprime
	  | primtypes { $$.type = $1.type; $$.cs = $1.cs; }
	  ;
typesprime : { $$.cs = ""; }
		   | subrangepart
		   | variable subrangepart
		   ;
primtypes : INT_TOKEN { $$.type = "int"; $$.cs = "int "; }
		  | REAL_TOKEN { $$.type = "float"; $$.cs = "float "; }
		  | BOOL_TOKEN { $$.type = "bool"; $$.cs = "bool "; }
		  | CHAR_TOKEN { $$.type = "char"; $$.cs = "char "; }
		  | STRING_TOKEN { $$.type = "char*"; $$.cs = "char* "; }
		  | arraytype
		  | settype
		  | enumtype
		  | recordtype
		  | subrangetype2 subrangepart
		  ;
arraytype : ARRAY_TOKEN '[' subrangelist ']' OF_TOKEN types
		  ;
subrangelist : subrangetype2 subrangepart subrangelistprime
			 | subrangetype1 subrangelisttype1
			 ;
subrangelisttype1 : subrangepart subrangelistprime
				  | subrangelistprime
				  ;
subrangepart : RANGE_TOKEN subrangepartprime
			 ;
subrangepartprime : subrangetype1
				  | subrangetype2
				  ;
subrangelistprime : { $$.cs = ""; }
				  | ',' subrangelist
				  ;
subrangetype1 : ID_TOKEN subrangetvarpart
			 ;
subrangetype2 : INTLITERAL_TOKEN
				  | CHARLITERAL_TOKEN
				  ;
subrangetvarpart : { $$.cs = ""; }
				 | variable
				 ;
settype : SET_TOKEN OF_TOKEN types
		;
enumtype : '(' idlist ')'
		 ;
recordtype : RECORD_TOKEN varlistlist END_TOKEN
		   ;
usertypes : { $$.cs = ""; }
		  | TYPE_TOKEN listusertypes { $$.sts = $2.sts; $$.cs = $2.cs; }
		  ;
listusertypes : usertype listusertypesprime { $$.sts = st_union($1.sts, $2.sts); $$.cs = $1.cs + $2.cs; }
			  ;
listusertypesprime : { $$.cs = ""; }
				   | listusertypes { $$.sts = $1.sts; $$.cs = $1.cs; }
				   ;
usertype : ID_TOKEN '=' types ';' { $$.sts[$1] = $3.type; $$.cs = "typedef " + $3.type + " " + $1 + ";\n"; }
		 ;
vars : { $$.cs = ""; }
	 | VAR_TOKEN varlistlist { $$.sts = $2.sts; $$.cs = $2.cs + "\n"; }
	 ;
varlistlist : varlist varlistlistprime { $$.sts = st_union($1.sts, $2.sts); $$.cs = $1.cs + $2.cs; }
			;
varlistlistprime : { $$.cs = ""; }
				 | varlistlist { $$.sts = $1.sts; $$.cs = $1.cs; }
				 ;
varlist : types idlist ';' { $$.sts = addIds($1.type, $2.ids); $$.cs = $1.cs + $2.cs + ";\n"; }
		;
idlist : ID_TOKEN idattr idlistprime { $$.cs = $1 + $3.cs; }
	   ;
idlistprime : { $$.cs = ""; }
			| ',' idlist { $$.sts = $2.sts; $$.cs = ", " + $2.cs; }
			;
idattr : { $$.cs = ""; }
	   | '=' expr
	   ;
variable : ACCESS_TOKEN ID_TOKEN variableprime
		 | '[' exprlistplus ']' variableprime
		 ;
variableprime : { $$.cs = ""; }
			  | variable
			  ;
block : { $<attrs>$.sti = $<attrs>0.sts; } BEGIN_TOKEN stmts END_TOKEN { $$.sts = $3.sts; $$.cs = "{\n" + $3.cs + "\n}\n";  }
	  ;
stmts : { $<attrs>$.sti = $<attrs>-1.sti; } stmt stmtlistprime { $$.cs = $2.cs + $3.cs;}
	  ;
stmtlistprime : { $$.cs = ""; }
			  | { $<attrs>$.sti = $<attrs>-2.sti; } ';' stmts { $$.cs = $3.cs; }
			  ;
stmt : {  $$.cs = ""; }
	 | { $<attrs>$.sti = $<attrs>0.sti; } LABEL_TOKEN A stmt { std::string label = $2; label[0] = '_'; $$.cs = label + ":\n" + $4.cs; }
	 | { $<attrs>$.sti = $<attrs>0.sti; } block { $$.cs = $2.cs; }
	 | { $<attrs>$.sti = $<attrs>0.sti; } writestmt { $$.cs = $2.cs; }
	 | { $<attrs>$.sti = $<attrs>0.sti; } writelnstmt { $$.cs = $2.cs; }
	 | { $<attrs>$.sti = $<attrs>0.sti; } readstmt { $$.cs = $2.cs; }
	 | { $<attrs>$.sti = $<attrs>0.sti; } readlnstmt { $$.cs = $2.cs; }
	 | { $<attrs>$.sti = $<attrs>0.sti; } loopblock { $$.cs = $2.cs; }
	 | { $<attrs>$.sti = $<attrs>0.sti; } ifblock { $$.cs = $2.cs; }
	 | { $<attrs>$.sti = $<attrs>0.sti; } forblock { $$.cs = $2.cs; }
	 | { $<attrs>$.sti = $<attrs>0.sti; } caseblock { $$.cs = $2.cs; }
	 | gotostmt
	 | { $<attrs>$.sti = $<attrs>0.sti; } ID_TOKEN stmtprime { $$.cs = $2 + $3.cs; }
	 | { $<attrs>$.afterlabel = $<attrs>0.afterlabel; } exitstmt
	 | returnstmt
	 ;
A : { $<attrs>$.sti = $<attrs>-1.sti; } 
  ;
stmtprime : attrstmt
		  | subprogcall
		  ;
subprogcall : '(' exprlist ')'
			;
exitstmt : { $<attrs>$.afterlabel = $<attrs>0.afterlabel; } EXITWHEN_TOKEN expr { $$.cs = "if(" + $3.cs + ") goto " + $$.afterlabel + ";\n"; }
		 ;
returnstmt : RETURN_TOKEN expr { $$.cs = "return " + $2.cs + ";\n"; }
		   ;
attrstmt : variable ATTR_TOKEN expr
		 | ATTR_TOKEN expr { $$.cs = " = " + $2.cs + ";\n"; }
		 ;
ifblock : { $<attrs>$.sti = $<attrs>0.sti; } IF_TOKEN expr B stmt elseblock { std::string label1 = generateNewLabel(), label2 = generateNewLabel();
 $$.cs =  "if (!(" + $3.cs + ")) goto " + label1 + ";\n" + $5.cs + "goto " + label2 + ";\n" + label1 + ":\n" + $6.cs + label2 + ":\n";}
		;
B : { $<attrs>$.sti = $<attrs>-2.sti; }
  ;
elseblock : { $$.cs = ""; }
		  | { $<attrs>$.sti = $<attrs>-4.sti; } ELSE_TOKEN A stmt { $$.cs = $4.cs; }
		  ;
loopblock : {$<attrs>$.sti = $<attrs>0.sti; } LOOP_TOKEN E stmt { std::string label1 = generateNewLabel(); $$.cs = label1 + ":\n" + $4.cs + "\ngoto " + label1 + ";\n" + $3.afterlabel + ":\n"; }
		  ;
E : { $<attrs>$.sti = $<attrs>-1.sti; $<attrs>$.afterlabel = generateNewLabel(); }
  ;
caseblock : CASE_TOKEN expr OF_TOKEN caselist caseblockprime
		  ;
caseblockprime : END_TOKEN
			   | ELSE_TOKEN A stmt END_TOKEN
			   ;
caselist : literallist ':' B stmt ';'
		 ;
literallist : literal literallistprime
			;
literallistprime : { $$.cs = ""; }
				 | ',' literallist
				 ;
gotostmt : GOTO_TOKEN LABEL_TOKEN {}
		 ;
forblock : FOR_TOKEN ID_TOKEN forblockprime
		 ;
forblockprime : variable ATTR_TOKEN expr TO_TOKEN expr STEP_TOKEN expr DO_TOKEN C stmt
			  | ATTR_TOKEN expr TO_TOKEN expr STEP_TOKEN expr DO_TOKEN D stmt
			  ;
C : { $<attrs>$.sti = $<attrs>-8.sti; }
  ;
D : { $<attrs>$.sti = $<attrs>-7.sti; }
  ;
expr : conj disj {
			$1.sti = $$.sti;
			$2.sti = $$.sti;
			if ($2.type.compare("nobool")) {
				$$.type = $1.type;
			} else {
				$$.type = $2.type;
			}
			$$.cs = $1.cs + $2.cs;
		}
	 ;
finalterm : ID_TOKEN finaltermprime {
					$$.type = $$.sti[$1];
					$$.cs = $1 + $2.cs;
				}
		  | literal {
					$$.type = $1.type;
					$$.cs = $1.cs;
				}
		  | '(' expr ')' {
					$$.type = $2.type;
					$$.cs = "(" + $2.cs + ")";
				}
		  ;
finaltermprime : { $$.cs = ""; }
			   | variable {
					 	 $$.cs = $1.cs;
					 }
			   | subprogcall {
					 	 $$.cs = $1.cs;
					 }
			   ;
disj : { $$.type = "nobool"; $$.cs = ""; }
	 | OR_TOKEN conj {
	 	$2.sti = $$.sti;
	 	$$.type = "bool";
		$$.cs = " || " + $2.cs;
	 }
	 ;
conj : comp conjprime {
			$1.sti = $$.sti;
			$2.sti = $$.sti;
			if ($2.type.compare("nobool")) {
				$$.type = $1.type;
			} else {
				$$.type = $2.type;
			}
			$$.cs = $1.cs + $2.cs;
		}
	 ;
conjprime : { $$.type = "nobool"; $$.cs = ""; }
		  | AND_TOKEN comp {
				$2.sti = $$.sti;
				$$.type = "bool";
				$$.cs = " && " + $2.cs;
			}
		  ;
comp : relational compprime {
			$1.sti = $$.sti;
			$2.sti = $$.sti;
			if ($2.type.compare("nobool")) {
				$$.type = $1.type;
			} else {
				$$.type = $2.type;
			}
			$$.cs = $1.cs + $2.cs;
		}
	 ;
relational : sum relationalprime {
					$1.sti = $$.sti;
					$2.sti = $$.sti;
					if ($2.type.compare("nobool")) {
						$$.type = $1.type;
					} else {
						$$.type = $2.type;
					}
					$$.cs = $1.cs + $2.cs;
				}
		   ;
relationalprime : { $$.type = "nobool"; $$.cs = ""; }
				| relationalop sum {
					$1.sti = $$.sti;
					$2.sti = $$.sti;
					$$.type = "bool";
					$$.cs = $1.cs + $2.cs;
				}
				;
compprime : { $$.type = "nobool"; $$.cs = ""; }
		  | equalityop relational {
				$1.sti = $$.sti;
				$2.sti = $$.sti;
				$$.type = "bool";
				$$.cs = $1.cs + $2.cs;
			}
		  ;
sum : neg sumprime {
			$1.sti = $$.sti;
			$2.sti = $$.sti;
			if ($2.type.compare("nobool")) {
				$$.type = $1.type;
			} else {
				$$.type = $2.type;
			}
			$$.cs = $1.cs + $2.cs;
		}
	| addop neg sumprime {
			$2.sti = $$.sti;
			$3.sti = $$.sti;
			if ($3.type.compare("nobool")) {
				$$.type = $2.type;
			} else {
				$$.type = $3.type;
			}
			$$.cs = $1.cs + $2.cs + $3.cs;
		}
	;
sumprime : { $$.type = "nobool"; $$.cs = ""; }
		 | addop neg sumprime {
		 	 $1.sti = $$.sti;
			 $2.sti = $$.sti;
			 $3.sti = $$.sti;
			 $$.type = "bool";
			 $$.cs = $1.cs + $2.cs + $3.cs;
		 }
		 ;
neg : mul {
		$1.sti = $$.sti;
		$$.type = $1.type;
		$$.cs = $1.cs;
	}
	| '!' mul {
		$2.sti = $$.sti;
		$$.type = $2.type;
		$$.cs = "!" + $2.cs;
	}
	;
mul : finalterm mulprime {
			$1.sti = $$.sti;
			$2.sti = $$.sti;
			if ($2.type.compare("nobool")) {
				$$.type = $1.type;
			} else {
				$$.type = $2.type;
			}
			$$.cs = $1.cs + $2.cs;
		}
	;
mulprime : { $$.type = "nobool"; $$.cs = ""; }
		 | mulop finalterm mulprime {
		 			$1.sti = $$.sti;
		 			$2.sti = $$.sti;
		 			$3.sti = $$.sti;
		 			if ($3.type.compare("nobool")) {
		 				$$.type = $2.type;
		 			} else {
		 				$$.type = $3.type;
		 			}
		 			$$.cs = $1.cs + $2.cs + $3.cs;
		 		}
		 ;
addop : '+' { $$.cs = " + "; }
	  | '-' { $$.cs = " - "; }
	  ;
mulop : '*' { $$.cs = " * "; }
	  | '/' { $$.cs = " / "; }
	  | '%' { $$.cs = " % "; }
	  ;
equalityop : EQUAL_TOKEN
		   | DIFF_TOKEN
		   ;
relationalop : '<' { $$.cs = " < "; }
			 | LE_TOKEN { $$.cs = " <= "; }
			 | '>' { $$.cs = " > "; }
			 | GE_TOKEN { $$.cs = " >= "; }
			 ;
literal : INTLITERAL_TOKEN    { $$.cs = $1; }
    	| BOOLLITERAL_TOKEN     { $$.cs = $1; }
		  | REALLITERAL_TOKEN     { $$.cs = $1; }
		  | CHARLITERAL_TOKEN     { $$.cs = $1; }
		  | STRINGLITERAL_TOKEN   { $$.cs = $1; }
		  | SUBRANGELITERAL_TOKEN
		  | NIL_TOKEN
		  ;
exprlist : { $$.cs = ""; }
		 | exprlistplus
exprlistplus : expr exprlistplusprime
			 ;
exprlistplusprime : { $$.cs = ""; }
				  | ',' exprlistplus
				  ;
subprograms : { $<attrs>$.sti = st_union($<attrs>0.sts, st_union($<attrs>-1.sts, $<attrs>-2.sts)); }
			| { $<attrs>$.sti = st_union($<attrs>0.sts, st_union($<attrs>-1.sts, $<attrs>-2.sts)); } procedure subprogramsprime
			| { $<attrs>$.sti = st_union($<attrs>0.sts, st_union($<attrs>-1.sts, $<attrs>-2.sts)); } function subprogramsprime
			;
subprogramsprime : { $$.cs = ""; }
				 | ';' subprograms
				 ;
procedure : PROC_TOKEN ID_TOKEN '(' param ')' ';' decl block
		  ;
function : FUNC_TOKEN types ID_TOKEN '(' param ')' ';' decl block
		 ;
param : { $$.cs = ""; }
	  | paramlistlist
	  ;
paramlistlist : paramlist paramlistlistprime
			  ;
paramlistlistprime : { $$.cs = ""; }
				   | ';'  paramlistlist
				   ;
paramlist : REF_TOKEN types idlist
          | types idlist
          ;
writestmt : WRITE_TOKEN '(' expr ')' { io = true; $$.cs = "printf(" + $3.cs + ");\n" ; }
		  ;
writelnstmt : WRITELN_TOKEN '(' expr ')' { io = true; $3.cs.erase(0,1); $3.cs.erase($3.cs.size() - 1); $$.cs = "printf(\"" + $3.cs + "\\n\");\n" ; }
		    ;
readstmt : READ_TOKEN '(' ID_TOKEN variableprime ')' { io = true;
				if (!$$.sti.empty()) {
					if (!$$.sti.empty() && $$.sti[$3].compare("char*")) {
						$$.cs = "fgets(" + std::string($3) + ", sizeof(" + std::string($3) + ") , stdin);\n";
					} else {
						$$.cs = "scanf(\"" + get_io_type($$.sti[$3]) + "\", " + std::string($3) + ");\n";
					}
				}
		  }
		 ;
readlnstmt : READLN_TOKEN '(' ID_TOKEN variableprime ')' { io = true;
					if (!$$.sti.empty()) {
						if ($$.sti[$3].compare("char*")) {
							$$.cs = "fgets(" + std::string($3) + ", sizeof(" + std::string($3) + "), stdin);\n + printf(\"\\n\")";
						} else {
							$$.cs = "scanf(\"" + get_io_type($$.sti[$3]) + "\\n\", " + std::string($3) + ");\n";
						}
					}
			  }
		   ;
%%

int main(int argc, char *argv[]) {
	if(argc < 2) {
		printf("Not enough arguments.");
		return 0;
	}

	char * argFile = NULL;
	argFile = (char*) malloc (strlen(argv[1]) + 1);
	strcpy (argFile, argv[1]);
	f = fopen(getPathFile(argFile), "w");

	init_lexer(argv[1]);


	yyparse();
	return 0;
}
