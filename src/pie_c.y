%{
#include "include/utils.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <iostream>
#include <algorithm>

extern int yylex();
extern void init_lexer(char* arg);

extern int num_column;
extern int num_line;
extern char* lex;
extern char* file_path;
int lastlabel = 0;
int lastenum = 0;

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

std::string removeSpace(std::string &str){
    str.erase(std::remove(str.begin(), str.end(), ' '), str.end());
      return str;
}

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
 	lastlabel += 1;
	std::string newLabel = "_$" + std::to_string(lastlabel);
 	return newLabel;
}

std::string generateNewEnum() {
 	lastenum += 1;
	std::string newEnum = "enum_$" + std::to_string(lastenum);
 	return newEnum;
}

std::string forOutput(std::string variable, std::string from, std::string to, int step, std::string content){
	std::string output = "\n";
	output += variable + "=" + from + ";\n";

	bool downto = step < 0;
	std::string label1 = generateNewLabel();
	std::string label2 = generateNewLabel();
	output += label1 + ":\nif ("+ variable;
	output += downto ? "<" : ">";
	output += to + ") goto " + label2 + ";\n";
	output += content + "\n" + variable + "+=" + std::to_string(step) + ";\ngoto " + label1 + "; \n" + label2 + ": ";

	return output;
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
program : PROGRAM_TOKEN ID_TOKEN ';' decl block '.' { $$.cs = includes() + $4.cs + "int main() " + $5.cs; $$.cs = $$.cs.substr(0, $$.cs.size()-3); $$.cs = $$.cs + "\nreturn 1;\n}\n"; fprintf(f, "%s", $$.cs.c_str()); }
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
types : ID_TOKEN typesprime { $$.type = $1; $$.cs = ""; }
	  | primtypes { $$.type = $1.type; $$.cs = $1.cs; }
	  ;
typesprime : { $$.cs = ""; }
		   | subrangepart { $$.cs = $1.cs; }
		   | variable subrangepart { $$.cs = $1.cs + $2.cs; }
		   ;
primtypes : INT_TOKEN { $$.type = "int"; $$.cs = ""; }
		  | REAL_TOKEN { $$.type = "float"; $$.cs = ""; }
		  | BOOL_TOKEN { $$.type = "bool"; $$.cs = ""; }
		  | CHAR_TOKEN { $$.type = "char"; $$.cs = ""; }
		  | STRING_TOKEN { $$.type = "char*"; $$.cs = ""; }
		  | arraytype { $$.type = $1.cs; $$.cs = ""; }
		  | settype { $$.type = $1.cs; $$.cs = ""; }
		  | enumtype { $$.type = $1.cs; $$.cs = ""; }
		  | recordtype { $$.type = $1.cs; $$.cs = ""; }
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
settype : SET_TOKEN OF_TOKEN types { $$.cs = $3.type + std::string("*"); }
		;
enumtype : '(' idlist ')' {
				$$.cs = "enum " + generateNewEnum() + "{" + $2.cs + "}";
			}
		 ;
recordtype : RECORD_TOKEN varlistlist END_TOKEN {
					$$.cs = "struct {\n" + $2.cs + "\n}";
				}
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
varlist : types idlist ';' { $$.sts = addIds($1.type, $2.ids); $$.cs = $1.type + std::string(" ") + $2.cs + $1.cs + ";\n"; }
		;
idlist : ID_TOKEN idattr idlistprime { $$.ids = $3.ids; $$.ids.push_back($1); $$.cs = $1 + $2.cs + $3.cs; }
	   ;
idlistprime : { $$.cs = ""; }
			| ',' idlist { $$.ids = $2.ids; $$.sts = $2.sts; $$.cs = ", " + $2.cs; }
			;
idattr : { $$.cs = ""; }
	   | '=' expr { $$.cs = "= " + $2.cs; }
	   ;
variable : ACCESS_TOKEN ID_TOKEN variableprime { $$.cs = "." + std::string($2) + $3.cs; }
		 | '[' exprlistplus ']' variableprime { $$.cs = "[" + $2.cs + "]" + $4.cs;}
		 ;
variableprime : { $$.cs = ""; }
			  | variable { $$.cs = $1.cs; }
			  ;
block : { $<attrs>$.sti = $<attrs>0.sts; } BEGIN_TOKEN stmts END_TOKEN { $$.sts = $3.sts; $$.cs = "{\n" + $3.cs + "\n}\n";  }
	  ;
stmts : { $<attrs>$.sti = $<attrs>-1.sti; } stmt stmtlistprime { $$.cs = $2.cs + $3.cs; }
	  ;
stmtlistprime : { $$.cs = ""; }
			  | { $<attrs>$.sti = $<attrs>-1.sti; } ';' stmts { $$.cs = $3.cs; }
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
	 | gotostmt { $$.cs = $1.cs; }
	 | { $<attrs>$.sti = $<attrs>0.sti; } ID_TOKEN stmtprime { $$.cs = $2 + $3.cs; }
	 | { $<attrs>$.afterlabel = $<attrs>0.afterlabel; } exitstmt { $$.cs = $2.cs; }
	 | returnstmt { $$.cs = $1.cs; }
	 ;
A : { $<attrs>$.sti = $<attrs>-1.sti; }
  ;
stmtprime : { $<attrs>$.sti = $<attrs>-1.sti; } attrstmt { $$.cs = $2.cs; }
		  | { $<attrs>$.sti = $<attrs>-1.sti; } subprogcall { $$.cs = $2.cs; }
		  ;
subprogcall : '(' exprlist ')'
			;
exitstmt : { $<attrs>$.sti = $<attrs>0.sti; $<attrs>$.afterlabel = $<attrs>0.afterlabel; } EXITWHEN_TOKEN expr { $$.cs = "if(" + $3.cs + ") goto " + $$.afterlabel + ";\n"; }
		 ;
returnstmt : { $<attrs>$.sti = $<attrs>0.sti; } RETURN_TOKEN expr { $$.cs = "return " + $3.cs + ";\n"; }
		   ;
attrstmt : variable ATTR_TOKEN expr { $$.cs = $1.cs + " = " + $3.cs + ";\n"; }
		 | ATTR_TOKEN expr { $$.cs = " = " + $2.cs + ";\n"; }
		 ;
ifblock : { $<attrs>$.sti = $<attrs>0.sti; } IF_TOKEN expr B stmt elseblock { std::string label1 = generateNewLabel(), label2 = generateNewLabel();
 $$.cs =  "if (!(" + $3.cs + ")) goto " + label1 + ";\n" + $5.cs + "goto " + label2 + ";\n" + label1 + ":\n" + $6.cs + label2 + ":\n";}
		;
B : { $<attrs>$.sti = $<attrs>-2.sti; }
  ;
elseblock : { $$.cs = ""; }
		  | ELSE_TOKEN { $<attrs>$.sti = $<attrs>-5.sti; } A stmt { $$.cs = $4.cs; }
		  ;
loopblock : {$<attrs>$.sti = $<attrs>0.sti; } LOOP_TOKEN E stmt { std::string label1 = generateNewLabel(); $$.cs = label1 + ":\n" + $4.cs + "\ngoto " + label1 + ";\n" + $3.afterlabel + ":\n"; }
		  ;
E : { $<attrs>$.sti = $<attrs>-1.sti; $<attrs>$.afterlabel = generateNewLabel(); }
  ;
caseblock : { $<attrs>$.sti = $<attrs>0.sti; } CASE_TOKEN expr OF_TOKEN caselist caseblockprime
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
gotostmt : { $<attrs>$.sti = $<attrs>0.sti; } GOTO_TOKEN LABEL_TOKEN { $$.cs = "goto " + std::string($3); }
		 ;
		 forblock : FOR_TOKEN ID_TOKEN forblockprime {$$.cs = $3.cs;}
		 		 ;
		 forblockprime : { $<attrs>$.id_token = $<lexeme>0; } variable ATTR_TOKEN expr TO_TOKEN expr STEP_TOKEN expr DO_TOKEN C stmt { $$.cs = forOutput($$.id_token+$2.cs, $4.cs, $6.cs, std::stoi(removeSpace($8.cs)), $11.cs); }
		 			  | { $<attrs>$.id_token = $<lexeme>0; } ATTR_TOKEN expr TO_TOKEN expr STEP_TOKEN expr DO_TOKEN D stmt {$$.cs = forOutput($$.id_token, $3.cs, $5.cs, std::stoi(removeSpace($7.cs)),  $10.cs);}
		 			  ;
C : { $<attrs>$.sti = $<attrs>-8.sti; }
  ;
D : { $<attrs>$.sti = $<attrs>-7.sti; }
  ;
expr : { $<attrs>$.sti = $<attrs>0.sti; } conj disj {
			if ($3.type == "nobool") {
				$$.type = $2.type;
			} else {
				$$.type = $3.type;
			}
			$$.cs = $2.cs + $3.cs;
		}
	 ;
finalterm : { $<attrs>$.sti = $<attrs>0.sti; } ID_TOKEN finaltermprime {
					$$.type = $$.sti[$2];
					$$.cs = $2 + $3.cs;
				}
		  | literal {
					$$.type = $1.type;
					$$.cs = $1.cs;
				}
		  | { $<attrs>$.sti = $<attrs>0.sti; } '(' A expr ')' {
					$$.type = $4.type;
					$$.cs = "(" + $4.cs + ")";
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
	 | { $<attrs>$.sti = $<attrs>-1.sti; } OR_TOKEN A conj {
	 	$$.type = "bool";
		$$.cs = " || " + $4.cs;
	 }
	 ;
conj : { $<attrs>$.sti = $<attrs>0.sti; } comp conjprime {
			if ($3.type == "nobool") {
				$$.type = $2.type;
			} else {
				$$.type = $3.type;
			}
			$$.cs = $2.cs + $3.cs;
		}
	 ;
conjprime : { $$.type = "nobool"; $$.cs = ""; }
		  | { $<attrs>$.sti = $<attrs>-1.sti; } AND_TOKEN A comp {
				$$.type = "bool";
				$$.cs = " && " + $4.cs;
			}
		  ;
comp : { $<attrs>$.sti = $<attrs>0.sti; } relational compprime {
			if ($3.type == "nobool") {
				$$.type = $2.type;
			} else {
				$$.type = $3.type;
			}
			$$.cs = $2.cs + $3.cs;
		}
	 ;
relational : { $<attrs>$.sti = $<attrs>0.sti; } sum relationalprime {
					if ($3.type == "nobool") {
						$$.type = $2.type;
					} else {
						$$.type = $3.type;
					}
					$$.cs = $2.cs + $3.cs;
				}
		   ;
relationalprime : { $$.type = "nobool"; $$.cs = ""; }
				| { $<attrs>$.sti = $<attrs>-1.sti; } relationalop A sum {
					$$.type = "bool";
					$$.cs = $2.cs + $4.cs;
				}
				;
compprime : { $$.type = "nobool"; $$.cs = ""; }
		  | { $<attrs>$.sti = $<attrs>-1.sti; } equalityop A relational {
				$$.type = "bool";
				$$.cs = $2.cs + $4.cs;
			}
		  ;
sum : { $<attrs>$.sti = $<attrs>0.sti; } neg sumprime {
			if ($3.type == "nobool") {
				$$.type = $2.type;
			} else {
				$$.type = $3.type;
			}
			$$.cs = $2.cs + $3.cs;
		}
	| { $<attrs>$.sti = $<attrs>0.sti; } addop A neg sumprime {
			if ($5.type == "nobool") {
				$$.type = $4.type;
			} else {
				$$.type = $5.type;
			}
			$$.cs = $2.cs + $4.cs + $5.cs;
		}
	;
sumprime : { $$.type = "nobool"; $$.cs = ""; }
		 | { $<attrs>$.sti = $<attrs>-1.sti; } addop A neg sumprime {
			 $$.type = "bool";
			 $$.cs = $2.cs + $4.cs + $5.cs;
		 }
		 ;
neg : { $<attrs>$.sti = $<attrs>0.sti; } mul {
		$$.type = $2.type;
		$$.cs = $2.cs;
	}
	| { $<attrs>$.sti = $<attrs>0.sti; } '!' A mul {
		$$.type = $4.type;
		$$.cs = "!" + $4.cs;
	}
	;
mul : { $<attrs>$.sti = $<attrs>0.sti; } finalterm mulprime {
			if ($3.type == "nobool") {
				$$.type = $2.type;
			} else {
				$$.type = $3.type;
			}
			$$.cs = $2.cs + $3.cs;
		}
	;
mulprime : { $$.type = "nobool"; $$.cs = ""; }
		 | { $<attrs>$.sti = $<attrs>-1.sti; } mulop A finalterm mulprime {
		 			if ($5.type == "nobool") {
		 				$$.type = $4.type;
		 			} else {
		 				$$.type = $5.type;
		 			}
		 			$$.cs = $2.cs + $4.cs + $5.cs;
		 		}
		 ;
addop : '+' { $$.cs = " + "; }
	  | '-' { $$.cs = " - "; }
	  ;
mulop : '*' { $$.cs = " * "; }
	  | '/' { $$.cs = " / "; }
	  | '%' { $$.cs = " % "; }
	  ;
equalityop : EQUAL_TOKEN {$$.cs = " == "; }
		   | DIFF_TOKEN {$$.cs = " != "; }
		   ;
relationalop : '<' { $$.cs = " < "; }
			 | LE_TOKEN { $$.cs = " <= "; }
			 | '>' { $$.cs = " > "; }
			 | GE_TOKEN { $$.cs = " >= "; }
			 ;
literal : INTLITERAL_TOKEN    { $$.type = "int"; $$.cs = $1; }
    	| BOOLLITERAL_TOKEN     { $$.type = "bool"; $$.cs = $1; }
		  | REALLITERAL_TOKEN     { $$.type = "real"; $$.cs = $1; }
		  | CHARLITERAL_TOKEN     { $$.type = "char"; $$.cs = $1; }
		  | STRINGLITERAL_TOKEN   { $$.type = "char*"; $$.cs = $1; }
		  | SUBRANGELITERAL_TOKEN { $$.type = "null"; $$.cs = $1; }
		  | NIL_TOKEN             { $$.type = "null"; $$.cs = "null"; }
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
writestmt : { $<attrs>$.sti = $<attrs>0.sti; } WRITE_TOKEN '(' B expr ')' {
				io = true;
				if ($5.type == "char*") {
					$5.cs.erase(0,1); $5.cs.erase($5.cs.size() - 1);
					$$.cs = "printf(\"" + get_io_type($5.type) + "\", \"" + $5.cs + "\");\n";
				} else {
					$$.cs = "printf(\"" + get_io_type($5.type) + "\", " + $5.cs + ");\n";
				}}
		  ;
writelnstmt : { $<attrs>$.sti = $<attrs>0.sti; } WRITELN_TOKEN '(' B expr ')' {
					io = true;
					if ($5.type == "char*") {
						$5.cs.erase(0,1); $5.cs.erase($5.cs.size() - 1);
						$$.cs = "printf(\"" + get_io_type($5.type) + "\\n\", \"" + $5.cs + "\");\n";
					} else {
						$$.cs = "printf(\"" + get_io_type($5.type) + "\\n\", " + $5.cs + ");\n" ;
					}}
		    ;
readstmt : { $<attrs>$.sti = $<attrs>0.sti; } READ_TOKEN '(' ID_TOKEN variableprime ')' { io = true;
				if (!$$.sti.empty()) {
					if ($$.sti[$4] == "char*") {
						$$.cs = "fgets(" + std::string($4) + ", sizeof(" + std::string($4) + ") , stdin);\n";
					} else {
						$$.cs = "scanf(\"" + get_io_type($$.sti[$4]) + "\", &" + std::string($4) + ");\n";
					}
				}
				else {
					$$.cs = "";
				}
		  }
		 ;
readlnstmt : { $<attrs>$.sti = $<attrs>0.sti; } READLN_TOKEN '(' ID_TOKEN variableprime ')' { io = true;
					if (!$$.sti.empty()) {
						if ($$.sti[$4] == "char*") {
							$$.cs = "fgets(" + std::string($4) + ", sizeof(" + std::string($4) + "), stdin);\n printf(\"\\n\");\n";
						} else {
							$$.cs = "scanf(\"" + get_io_type($$.sti[$4]) + "\", &" + std::string($4) + ");\n printf(\"\\n\");\n";
						}
					}
					else {
						$$.cs = "";
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
