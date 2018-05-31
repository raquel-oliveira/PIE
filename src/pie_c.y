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

ST st_union(const ST& st1, const ST& st2) {
	ST unionST;
	unionST = st1;
	unionST.st.insert(st2.st.begin(), st2.st.end());
	for(auto const& i : st2.struct_ST_idx) {
		if(unionST.struct_ST_idx.find(i.first) == unionST.struct_ST_idx.end()) {
			unionST.struct_ST_idx[i.first] = i.second + unionST.struct_STs.size();
		}
	}
	for(auto const& i : st2.array_ST_idx) {
		if(unionST.array_ST_idx.find(i.first) == unionST.array_ST_idx.end()) {
			unionST.array_ST_idx[i.first] = i.second + unionST.array_STs.size();
		}
	}
	for(auto const& i : st2.range_ST_idx) {
		if(unionST.range_ST_idx.find(i.first) == unionST.range_ST_idx.end()) {
			unionST.range_ST_idx[i.first] = i.second + unionST.range_STs.size();
		}
	}
	unionST.struct_STs.insert(unionST.struct_STs.end(), st2.struct_STs.begin(), st2.struct_STs.end());
	unionST.array_STs.insert(unionST.array_STs.end(), st2.array_STs.begin(), st2.array_STs.end());
	unionST.range_STs.insert(unionST.range_STs.end(), st2.range_STs.begin(), st2.range_STs.end());
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

std::string forOutput(std::string variable, std::string from, std::string to, int step, std::string content){
	std::string output = "\n";
	output += variable + "=" + from + ";\n";

	bool downto = step < 0;
	std::string label1 = generateNewLabel();
	std::string label2 = generateNewLabel();
	output += label1 + ":\nif ("+ variable;
	output += downto ? "<" : ">";
	output += to + ") goto " + label2 + ";\n";
	output += content + "\n" + variable + "+=" + std::to_string(step) + ";\ngoto " + label1 + "; \n" + label2 + ":;\n";

	return output;
}

std::string getType(ST& st, std::string id) {
	std::string type = st.st[id];
	if(type == "")
		return type;
	if(type == "int" || type == "float" || type == "char" || type == "bool" || type == "char*" || type == "struct" || type == "array") {
		return type;
	}
	return getType(st, type);
}

std::string getArrayType(const ST& st, int pos) {
	std::string type = st.array_STs[pos].type;
	if(type == "array") {
		return getArrayType(st, st.array_STs[pos].pos);
	}
	else {
		return type;
	}
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

%type <attrs> program decl consts listconst listconstprime constdecl types typesprime primtypes arraytype subrangelist subrangelisttype1 subrangepart subrangepartprime subrangelistprime subrangetype1 subrangetype2 subrangetvarpart settype enumtype recordtype usertypes listusertypes listusertypesprime usertype vars varlistlist varlistlistprime varlist idlist idlistprime idattr variable variableprime block stmts stmtlistprime stmt stmtprime subprogcall exitstmt returnstmt attrstmt ifblock elseblock loopblock caseblock caseblockprime caselist literallist literallistprime gotostmt forblock forblockprime expr finalterm finaltermprime disj conj conjprime comp relational relationalprime compprime sum sumprime neg mul mulprime addop mulop equalityop relationalop literal exprlist exprlistplus exprlistplusprime subprograms subprogramsprime procedure function param paramlistlist paramlistlistprime paramlist writestmt writelnstmt readstmt readlnstmt A B C D E F G H I J K L

%start program

%%
program : PROGRAM_TOKEN ID_TOKEN ';' decl I block '.' { $$.cs = includes() + "typedef int bool;\n#define true 1\n#define false 0\n\n" + $4.cs + "int main() {\n" + $6.cs + "\nreturn 0;\n}\n"; fprintf(f, "%s", $$.cs.c_str()); }
		;
I : { $<attrs>$.st = $<attrs>0.st; }
  ;
decl : consts usertypes vars F subprograms { $$.st = st_union($1.st, st_union($2.st, $3.st)); $$.cs = $1.cs + $2.cs + $3.cs + $5.cs; }
	 ;
F : { $<attrs>$.st = st_union($<attrs>0.st, st_union($<attrs>-1.st, $<attrs>-2.st)); }
  ;
consts : { $$.cs = ""; }
	   | CONST_TOKEN listconst { $$.st = $2.st; $$.cs = $2.cs; }
	   ;
listconst : constdecl listconstprime { $$.st = st_union($1.st, $2.st); $$.cs = $1.cs + $2.cs; }
		  ;
listconstprime : { $$.cs = ""; }
			   | listconst { $$.st = $1.st; $$.cs = $1.cs; }
			   ;
constdecl : ID_TOKEN '=' expr ';' { $$.st.st[$1] = $3.type; $$.cs = "const " + $3.type + " " + $1 + " = " + $3.cs + ";\n"; }
		  ;
types : { $<attrs>$.st = $<attrs>0.st; } ID_TOKEN typesprime { $$.type = $2; $$.cs = $2 + $3.cs; }
	  | primtypes { $$.st = $1.st; $$.type = $1.type; $$.arraybody = $1.arraybody; $$.cs = $1.cs; }
	  ;
typesprime : { $$.cs = ""; }
		   | subrangepart { $$.cs = $1.cs; }
		   | variable subrangepart { $$.cs = $1.cs + $2.cs; }
		   ;
primtypes : INT_TOKEN { $$.type = "int"; $$.cs = $$.type; }
		  | REAL_TOKEN { $$.type = "float"; $$.cs = $$.type; }
		  | BOOL_TOKEN { $$.type = "bool"; $$.cs = $$.type; }
		  | CHAR_TOKEN { $$.type = "char"; $$.cs = $$.type; }
		  | STRING_TOKEN { $$.type = "char*"; $$.cs = $$.type; }
		  | arraytype { $$.st = $1.st; $$.type = "array"; $$.arraybody = $1.arraybody; $$.cs = $1.cs; }
		  | settype { $$.type = "set"; $$.cs = $1.cs; }
		  | enumtype { $$.type = "int"; $$.cs = $1.cs; }
		  | recordtype { $$.st = $1.st; $$.type = "struct"; $$.cs = $1.cs; }
		  | subrangetype2 subrangepart
		  ;
arraytype : ARRAY_TOKEN '[' subrangelist ']' OF_TOKEN types { ArrayAttrs aa; aa.type = $6.type; aa.init_idx = $3.ra.init_idx; $$.st.array_STs.push_back(aa); $$.arraybody = "[" + std::to_string($3.ra.end_idx - $3.ra.init_idx + 1) + "]"; $$.cs = $6.type;}
		  ;
subrangelist : subrangetype2 subrangepart subrangelistprime { $$.ra.init_idx = $1.ra.init_idx; $$.ra.end_idx = $2.ra.end_idx; }
			 | subrangetype1 subrangelisttype1
			 ;
subrangelisttype1 : subrangepart subrangelistprime
				  | subrangelistprime
				  ;
subrangepart : RANGE_TOKEN subrangepartprime { $$.ra.init_idx = $2.ra.init_idx; $$.ra.end_idx = $2.ra.end_idx; }
			 ;
subrangepartprime : subrangetype1 
				  | subrangetype2 { $$.ra.init_idx = $1.ra.init_idx; $$.ra.end_idx = $1.ra.end_idx; }
				  ;
subrangelistprime : { $$.cs = ""; }
				  | ',' subrangelist
				  ;
subrangetype1 : ID_TOKEN subrangetvarpart
			 ;
subrangetype2 : INTLITERAL_TOKEN { $$.ra.init_idx = std::stoi($1); $$.ra.end_idx = std::stoi($1); }
				  | CHARLITERAL_TOKEN
				  ;
subrangetvarpart : { $$.cs = ""; }
				 | variable
				 ;
settype : SET_TOKEN OF_TOKEN types { $$.cs = $3.type + std::string("*"); }
		;
enumtype : '(' idlist ')' {
				$$.cs = "enum {" + $2.cs + "}";
			}
		 ;
recordtype : RECORD_TOKEN varlistlist END_TOKEN {
					$$.st = $2.st;
					$$.st.struct_STs.push_back($$.st.st);
					$$.st.st.clear();
					$$.cs = "struct {\n" + $2.cs + "\n}";
				}
		   ;
usertypes : { $$.cs = ""; }
		  | TYPE_TOKEN listusertypes { $$.st = $2.st; $$.cs = $2.cs; }
		  ;
listusertypes : usertype listusertypesprime { $$.st = st_union($1.st, $2.st); $$.cs = $1.cs + $2.cs; }
			  ;
listusertypesprime : { $$.cs = ""; }
				   | listusertypes { $$.st = $1.st; $$.cs = $1.cs; }
				   ;
usertype : ID_TOKEN '=' types ';' { 
				$$.st.st[$1] = $3.type; 
				if($3.type == "struct") {
					$$.st.struct_STs = $3.st.struct_STs;
					$$.st.struct_ST_idx[$1] = $$.st.struct_STs.size() - 1;
				}
				else if($3.type == "array") {
					$$.st.array_STs = $3.st.array_STs;
					$$.st.array_ST_idx[$1] = $$.st.array_STs.size() - 1;
				}
				if ($3.type == "array") {
					$$.cs = "typedef " + $3.cs + " " + $1 + $3.arraybody + ";\n";
				} else {
					$$.cs = "typedef " + $3.cs + " " + $1 + ";\n";
				}
			}
		 ;
vars : { $$.cs = ""; }
	 | VAR_TOKEN varlistlist { $$.st = $2.st; $$.cs = $2.cs + "\n"; }
	 ;
varlistlist : varlist varlistlistprime { $$.st = st_union($1.st, $2.st); $$.cs = $1.cs + $2.cs; }
			;
varlistlistprime : { $$.st.st.clear(); $$.cs = ""; }
				 | varlistlist { $$.st = $1.st; $$.cs = $1.cs; }
				 ;
varlist : types L idlist ';' { 
				$$.st.st = addIds($1.type, $3.ids);
				if($1.type == "struct") {
					$$.st.struct_STs = $1.st.struct_STs;
					for(int i = 0; i < $3.ids.size(); i++) {
						$$.st.struct_ST_idx[$3.ids[i]] = $$.st.struct_STs.size() - 1;
					}
				} 
				else if($1.type == "array") {
					$$.st.array_STs = $1.st.array_STs;
					for(int i = 0; i < $3.ids.size(); i++) {
						$$.st.array_ST_idx[$3.ids[i]] = $$.st.array_STs.size() - 1;
					}
				}
				if ($1.type == "array") {
					$$.cs = $1.cs + " ";
					for(int i = 0; i < $3.ids.size(); ) {
						$$.cs += $3.ids[i] + $1.arraybody;
						i++;
						if (i == $3.ids.size()) {
							$$.cs += ";\n";
						} else {
							$$.cs += ", ";
						}
					}
				} else {
					$$.cs = $1.cs + " " + $3.cs + ";\n";
				}
			}
		;
L : { $<attrs>$.ids_info.ref = false; $<attrs>$.ids_info.type = "var"; }
  ;
idlist : { $<attrs>$.ids_info = $<attrs>0.ids_info; } ID_TOKEN idattr idlistprime { $$.ids = $4.ids; $$.ids.push_back($2);
			if($$.ids_info.type == "var") {
				$$.cs = $2 + $3.cs + $4.cs;
			}
			else {
				if($$.ids_info.ref) {
					$$.cs = $$.ids_info.type + "& " + $2 + $3.cs + $4.cs;
				}
				else {
					$$.cs = $$.ids_info.type + " " + $2 + $3.cs + $4.cs;
				}
			}
		}
	   ;
idlistprime : { $$.cs = ""; }
			| { $<attrs>$.ids_info = $<attrs>-2.ids_info; } ',' M idlist { $$.ids = $4.ids; $$.st = $4.st; $$.cs = ", " + $4.cs; }
			;
M : { $<attrs>$.ids_info = $<attrs>-1.ids_info; }
  ;
idattr : { $$.cs = ""; }
	   | '=' expr { $$.cs = "= " + $2.cs; }
	   ;
variable : { $<attrs>$.st = $<attrs>0.st; $<attrs>$.id_token = $<attrs>0.id_token; } ACCESS_TOKEN ID_TOKEN variableprime { $$.type = $$.st.struct_STs[$$.st.struct_ST_idx[$$.id_token]][$3]; $$.cs = "." + std::string($3) + $4.cs; }
		 | { $<attrs>$.st = $<attrs>0.st; $<attrs>$.id_token = $<attrs>0.id_token; } '[' exprlistplus ']' variableprime { $$.type = ""; $$.cs = "[" + $3.cs + " - " + std::to_string($$.st.array_STs[$$.st.array_ST_idx[$$.id_token]].init_idx) + "]" + $5.cs;}
		 ;
variableprime : { $$.cs = ""; }
			  | { $<attrs>$.st = $<attrs>0.st; $<attrs>$.id_token = $<lexeme>0; } variable { $$.type = $2.type; $$.cs = $2.cs; }
			  ;
block : { $<attrs>$.st = $<attrs>0.st; $<attrs>$.afterlabel = $<attrs>0.afterlabel; } BEGIN_TOKEN stmts END_TOKEN { $$.cs = $3.cs;  }
	  ;
stmts : { $<attrs>$.st = $<attrs>-1.st; $<attrs>$.afterlabel = $<attrs>-1.afterlabel; } stmt stmtlistprime { $$.cs = $2.cs + $3.cs; }
	  ;
stmtlistprime : { $$.cs = ""; }
			  | { $<attrs>$.st = $<attrs>-1.st; $<attrs>$.afterlabel = $<attrs>-1.afterlabel; } ';' stmts { $$.cs = $3.cs; }
			  ;
stmt : {  $$.cs = ""; }
	 | { $<attrs>$.st = $<attrs>0.st; } LABEL_TOKEN A stmt { std::string label = $2; label[0] = '_'; $$.cs = label + ":\n" + $4.cs; }
	 | { $<attrs>$.st = $<attrs>0.st; $<attrs>$.afterlabel = $<attrs>0.afterlabel; } block { $$.cs = $2.cs; }
	 | { $<attrs>$.st = $<attrs>0.st; } writestmt { $$.cs = $2.cs; }
	 | { $<attrs>$.st = $<attrs>0.st; } writelnstmt { $$.cs = $2.cs; }
	 | { $<attrs>$.st = $<attrs>0.st; } readstmt { $$.cs = $2.cs; }
	 | { $<attrs>$.st = $<attrs>0.st; } readlnstmt { $$.cs = $2.cs; }
	 | { $<attrs>$.st = $<attrs>0.st; } loopblock { $$.cs = $2.cs; }
	 | { $<attrs>$.st = $<attrs>0.st; } ifblock { $$.cs = $2.cs; }
	 | { $<attrs>$.st = $<attrs>0.st; } forblock { $$.cs = $2.cs; }
	 | { $<attrs>$.st = $<attrs>0.st; } caseblock { $$.cs = $2.cs; }
	 | gotostmt { $$.cs = $1.cs; }
	 | { $<attrs>$.st = $<attrs>0.st; } ID_TOKEN stmtprime { $$.cs = $2 + $3.cs; }
	 | { $<attrs>$.afterlabel = $<attrs>0.afterlabel; } exitstmt { $$.cs = $2.cs; }
	 | returnstmt { $$.cs = $1.cs; }
	 ;
A : { $<attrs>$.st = $<attrs>-1.st; }
  ;
stmtprime : { $<attrs>$.st = $<attrs>-1.st; } attrstmt { $$.cs = $2.cs; }
		  | { $<attrs>$.st = $<attrs>-1.st; } subprogcall { $$.cs = $2.cs; }
		  ;
subprogcall : '(' exprlist ')' { $$.cs = "(" + $2.cs + ");\n"; }
			;
exitstmt : { $<attrs>$.st = $<attrs>0.st; $<attrs>$.afterlabel = $<attrs>0.afterlabel; } EXITWHEN_TOKEN expr { $$.cs = "if(" + $3.cs + ") goto " + $$.afterlabel + ";\n"; }
		 ;
returnstmt : RETURN_TOKEN expr { $$.cs = "return " + $2.cs + ";\n"; }
		   ;
attrstmt : variable ATTR_TOKEN expr { $$.cs = $1.cs + " = " + $3.cs + ";\n"; }
		 | ATTR_TOKEN expr { $$.cs = " = " + $2.cs + ";\n"; }
		 ;
ifblock : { $<attrs>$.st = $<attrs>0.st; } IF_TOKEN expr B stmt elseblock { std::string label1 = generateNewLabel(), label2 = generateNewLabel();
 $$.cs =  "if (!(" + $3.cs + ")) goto " + label1 + ";\n" + $5.cs + "goto " + label2 + ";\n" + label1 + ":\n" + $6.cs + label2 + ":;\n";}
		;
B : { $<attrs>$.st = $<attrs>-2.st; }
  ;
elseblock : { $$.cs = ""; }
		  | ELSE_TOKEN { $<attrs>$.st = $<attrs>-5.st; } A stmt { $$.cs = $4.cs; }
		  ;
loopblock : {$<attrs>$.st = $<attrs>0.st; } LOOP_TOKEN E stmt { std::string label1 = generateNewLabel(); $$.cs = label1 + ":\n" + $4.cs + "\ngoto " + label1 + ";\n" + $3.afterlabel + ":;\n"; }
		  ;
E : { $<attrs>$.st = $<attrs>-1.st; $<attrs>$.afterlabel = generateNewLabel(); }
  ;
caseblock : { $<attrs>$.st = $<attrs>0.st; } CASE_TOKEN expr OF_TOKEN caselist caseblockprime
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
gotostmt : GOTO_TOKEN LABEL_TOKEN { std::string label = $2; label[0] = '_'; $$.cs = "goto " + label; }
		 ;
forblock : { $<attrs>$.st = $<attrs>0.st; } FOR_TOKEN ID_TOKEN forblockprime {$$.cs = $4.cs;}
		 ;
forblockprime : { $<attrs>$.st = $<attrs>-2.st; $<attrs>$.id_token = $<lexeme>0; } variable ATTR_TOKEN expr TO_TOKEN expr STEP_TOKEN expr DO_TOKEN C stmt { $$.cs = forOutput($$.id_token+$2.cs, $4.cs, $6.cs, std::stoi(removeSpace($8.cs)), $11.cs); }
		 | { $<attrs>$.st = $<attrs>-2.st; $<attrs>$.id_token = $<lexeme>0; } ATTR_TOKEN expr TO_TOKEN expr STEP_TOKEN expr DO_TOKEN D stmt {$$.cs = forOutput($$.id_token, $3.cs, $5.cs, std::stoi(removeSpace($7.cs)),  $10.cs);}
		 ;
C : { $<attrs>$.st = $<attrs>-8.st; }
  ;
D : { $<attrs>$.st = $<attrs>-7.st; }
  ;
expr : { $<attrs>$.st = $<attrs>0.st; } conj disj {
			if ($3.type == "nobool") {
				$$.type = $2.type;
			} else {
				$$.type = $3.type;
			}
			$$.cs = $2.cs + $3.cs;
		}
	 ;
finalterm : { $<attrs>$.st = $<attrs>0.st; } ID_TOKEN finaltermprime {
					std::string type = getType($$.st, $2);
					if(type == "int" || type == "float" || type == "char" || type == "bool" || type == "char*") {
						$$.type = type;
					}
					else if(type == "struct") {
						if($3.type == "subprogcall") {
							$$.type = type;
						}
						else {
							$$.type = $3.type;
						}
					}
					else if(type == "array") {
						if($3.type == "subprogcall") {
							$$.type = type;
						}
						else {
							$$.type = getArrayType($$.st, $$.st.array_ST_idx[$2]);
						}
					}
					$$.cs = $2 + $3.cs;
				}
		  | literal {
					$$.type = $1.type;
					$$.cs = $1.cs;
				}
		  | { $<attrs>$.st = $<attrs>0.st; } '(' A expr ')' {
					$$.type = $4.type;
					$$.cs = "(" + $4.cs + ")";
				}
		  ;
finaltermprime : { $$.type = ""; $$.cs = ""; }
			   | { $<attrs>$.st = $<attrs>-1.st; $<attrs>$.id_token = $<lexeme>0; } variable {
			   		$$.type = $2.type;
					$$.cs = $2.cs;
				 }
			   | { $<attrs>$.st = $<attrs>-1.st; } subprogcall {
			   		$$.type = "subprogcall";
					$$.cs = $2.cs;
				 }
			   ;
disj : { $$.type = "nobool"; $$.cs = ""; }
	 | { $<attrs>$.st = $<attrs>-1.st; } OR_TOKEN A conj {
	 	$$.type = "bool";
		$$.cs = " || " + $4.cs;
	 }
	 ;
conj : { $<attrs>$.st = $<attrs>0.st; } comp conjprime {
			if ($3.type == "nobool") {
				$$.type = $2.type;
			} else {
				$$.type = $3.type;
			}
			$$.cs = $2.cs + $3.cs;
		}
	 ;
conjprime : { $$.type = "nobool"; $$.cs = ""; }
		  | { $<attrs>$.st = $<attrs>-1.st; } AND_TOKEN A comp {
				$$.type = "bool";
				$$.cs = " && " + $4.cs;
			}
		  ;
comp : { $<attrs>$.st = $<attrs>0.st; } relational compprime {
			if ($3.type == "nobool") {
				$$.type = $2.type;
			} else {
				$$.type = $3.type;
			}
			$$.cs = $2.cs + $3.cs;
		}
	 ;
relational : { $<attrs>$.st = $<attrs>0.st; } sum relationalprime {
					if ($3.type == "nobool") {
						$$.type = $2.type;
					} else {
						$$.type = $3.type;
					}
					$$.cs = $2.cs + $3.cs;
				}
		   ;
relationalprime : { $$.type = "nobool"; $$.cs = ""; }
				| { $<attrs>$.st = $<attrs>-1.st; } relationalop A sum {
					$$.type = "bool";
					$$.cs = $2.cs + $4.cs;
				}
				;
compprime : { $$.type = "nobool"; $$.cs = ""; }
		  | { $<attrs>$.st = $<attrs>-1.st; } equalityop A relational {
				$$.type = "bool";
				$$.cs = $2.cs + $4.cs;
			}
		  ;
sum : { $<attrs>$.st = $<attrs>0.st; } neg sumprime {
			if ($3.type == "nobool") {
				$$.type = $2.type;
			} else {
				$$.type = $3.type;
			}
			$$.cs = $2.cs + $3.cs;
		}
	| { $<attrs>$.st = $<attrs>0.st; } addop A neg sumprime {
			if ($5.type == "nobool") {
				$$.type = $4.type;
			} else {
				$$.type = $5.type;
			}
			$$.cs = $2.cs + $4.cs + $5.cs;
		}
	;
sumprime : { $$.type = "nobool"; $$.cs = ""; }
		 | { $<attrs>$.st = $<attrs>-1.st; } addop A neg sumprime {
			 $$.type = "bool";
			 $$.cs = $2.cs + $4.cs + $5.cs;
		 }
		 ;
neg : { $<attrs>$.st = $<attrs>0.st; } mul {
		$$.type = $2.type;
		$$.cs = $2.cs;
	}
	| { $<attrs>$.st = $<attrs>0.st; } '!' A mul {
		$$.type = $4.type;
		$$.cs = "!" + $4.cs;
	}
	;
mul : { $<attrs>$.st = $<attrs>0.st; } finalterm mulprime {
			if ($3.type == "nobool") {
				$$.type = $2.type;
			} else {
				$$.type = $3.type;
			}
			$$.cs = $2.cs + $3.cs;
		}
	;
mulprime : { $$.type = "nobool"; $$.cs = ""; }
		 | { $<attrs>$.st = $<attrs>-1.st; } mulop A finalterm mulprime {
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
		 | exprlistplus { $$.cs = $1.cs; }
exprlistplus : expr exprlistplusprime { $$.cs = $1.cs + $2.cs; }
			 ;
exprlistplusprime : { $$.cs = ""; }
				  | ',' exprlistplus { $$.cs = ", " + $2.cs; }
				  ;
subprograms : { $$.cs = ""; }
			| { $<attrs>$.st = $<attrs>0.st; } procedure subprogramsprime { $$.cs = $2.cs + $3.cs; }
			| { $<attrs>$.st = $<attrs>0.st; } function subprogramsprime { $$.cs = $2.cs + $3.cs; }
			;
subprogramsprime : { $$.cs = ""; }
				 | { $<attrs>$.st = $<attrs>-1.st; } ';' A subprograms { $$.cs = $4.cs;}
				 ;
procedure : { $<attrs>$.st = $<attrs>0.st; } PROC_TOKEN ID_TOKEN '(' param ')' ';' decl G block { $$.cs = "void " + std::string($3) + "(" + $5.cs + ") {\n" + $8.cs + $10.cs + "\n}\n"; }
		  ;
G : { $<attrs>$.st = st_union($<attrs>-3.st, st_union($<attrs>0.st, $<attrs>-7.st)); }
  ;
function : { $<attrs>$.st = $<attrs>0.st; } FUNC_TOKEN types ID_TOKEN '(' param ')' ';' decl H block { $$.cs = $3.type + " " + $4 + "(" + $6.cs + ") {\n" + $9.cs + $11.cs + "\n}\n"; }
		 ;
H : { $<attrs>$.st = st_union($<attrs>-3.st, st_union($<attrs>0.st, $<attrs>-8.st)); }
  ;
param : { $$.cs = ""; }
	  | paramlistlist { $$.st = $1.st; $$.cs = $1.cs; }
	  ;
paramlistlist : paramlist paramlistlistprime { $$.st = st_union($1.st, $2.st); $$.cs = $1.cs + $2.cs; }
			  ;
paramlistlistprime : { $$.cs = ""; }
				   | ';'  paramlistlist { $$.st = $2.st; $$.cs = ", " + $2.cs; }
				   ;
paramlist : REF_TOKEN types J idlist { $$.st.st = addIds($2.type, $4.ids); $$.cs = $4.cs; }
          | types K idlist { $$.st.st = addIds($1.type, $3.ids); $$.cs = $3.cs; }
          ;
J : { $<attrs>$.ids_info.ref = true; $<attrs>$.ids_info.type = $<attrs>0.type; }
  ;
K : { $<attrs>$.ids_info.ref = false; $<attrs>$.ids_info.type = $<attrs>0.type; }
  ;
writestmt : { $<attrs>$.st = $<attrs>0.st; } WRITE_TOKEN '(' B expr ')' {
				io = true;
				if ($5.type == "char*") {
					$$.cs = "printf(\"" + get_io_type($5.type) + "\", " + $5.cs + ");\n";
				} else {
					$$.cs = "printf(\"" + get_io_type($5.type) + "\", " + $5.cs + ");\n";
				}}
		  ;
writelnstmt : { $<attrs>$.st = $<attrs>0.st; } WRITELN_TOKEN '(' B expr ')' {
					io = true;
					if ($5.type == "char*") {
						$$.cs = "printf(\"" + get_io_type($5.type) + "\\n\", " + $5.cs + ");\n";
					} else {
						$$.cs = "printf(\"" + get_io_type($5.type) + "\\n\", " + $5.cs + ");\n" ;
					}}
		    ;
readstmt : { $<attrs>$.st = $<attrs>0.st; } READ_TOKEN '(' ID_TOKEN variableprime ')' { 
				io = true;
				std::string type = getType($$.st, $4);
				if(type == "struct") {
					type = $5.type;
				}
				else if(type == "array") {
					type = getArrayType($$.st, $$.st.array_ST_idx[$4]);
				}
				if (!$$.st.st.empty()) {
					if (type == "char*") {
						$$.cs = "fgets(" + std::string($4) + ", sizeof(" + std::string($4) + ") , stdin);\n";
					} else {
						$$.cs = "scanf(\"" + get_io_type(type) + "\", &" + std::string($4) + $5.cs + ");\n";
					}
				}
				else {
					$$.cs = "";
				}
		  }
		 ;
readlnstmt : { $<attrs>$.st = $<attrs>0.st; } READLN_TOKEN '(' ID_TOKEN variableprime ')' { 
					io = true;
					std::string type = getType($$.st, $4);
					if(type == "struct") {
						type = $5.type;
					}
					else if(type == "array") {
						type = getArrayType($$.st, $$.st.array_ST_idx[$4]);
					}
					if (!$$.st.st.empty()) {
						if (type == "char*") {
							$$.cs = "fgets(" + std::string($4) + ", sizeof(" + std::string($4) + "), stdin);\n";
							std::string l1 = generateNewLabel(), l2 = generateNewLabel();
							$$.cs = $$.cs + l1 + ":\n" + "if(getchar() == '\\n') goto " + l2 + ";\n goto " + l1 + ";\n" + l2 + ":;\n";
						} else {
							$$.cs = "scanf(\"" + get_io_type(type) + "\", &" + std::string($4) + $5.cs + ");\n";
							std::string l1 = generateNewLabel(), l2 = generateNewLabel();
							$$.cs = $$.cs + l1 + ":\n" + "if(getchar() == '\\n') goto " + l2 + ";\n goto " + l1 + ";\n" + l2 + ":;\n";
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
