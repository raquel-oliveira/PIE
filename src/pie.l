%{
//https://github.com/jinankjain/Lexical-Analyzer-for-C/blob/master/analyzer.l
#include <math.h>
#include "include/tokens.h"

int num_line = 1, num_column = 1;
struct Token t;

void update_column(int yyleng) {
	num_column += yyleng;
}

void update_token(int id, int row, int col, char* lexeme) {
	t.id = id;
	t.row = row;
	t.col = col;
	t.lexeme = lexeme;
}

%}

LETTER          [a-zA-Z]
DIGIT           [0-9]
INTLITERAL      ("-"|"+")?{DIGIT}+
EXPONENT        ([E|e]("+"|"-")?({DIGIT}+))
R               ([0-9]*[.])?[0-9]+
R2 	 		    ([0-9]*[.])?[0-9]+{EXPONENT}?
REALLITERAL     (("-"|"+")?{R}|("-"|"+")?{R2})
NEW_LINE        (\n)
TAB             [ \t]+
STRINGLITERAL   \"[^"\n]*\"
SUBRANGELITERAL (INTLITERAL".."INTLITERAL)|(LETTER".."LETTER)
LINECOMMENT     "#"((.)*)\n
CHARLITERAL     \'[^']*\'
ID              {LETTER}({LETTER}|{DIGIT}|"_")*
LABEL           @({LETTER}|{DIGIT}|"_")*
WHITESPACE      [ \t\v\f]*
UNACCEPTABLE    .

%%


<<EOF>>     	{ update_token(ENDOFFILE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
program    		{ update_token(PROGRAM_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
proc       		{ update_token(PROC_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
begin      		{ update_token(BEGIN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
end        		{ update_token(END_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
func       		{ update_token(FUNC_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
const      		{ update_token(CONST_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
type       		{ update_token(TYPE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
var        		{ update_token(VAR_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
if         		{ update_token(IF_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
else       		{ update_token(ELSE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
goto       		{ update_token(GOTO_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
for        		{ update_token(FOR_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
to         		{ update_token(TO_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
do         		{ update_token(DO_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
step       		{ update_token(STEP_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
in         		{ update_token(IN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
of         		{ update_token(OF_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
loop       		{ update_token(LOOP_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
exitwhen   		{ update_token(EXITWHEN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
case       		{ update_token(CASE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
write      		{ update_token(WRITE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
writeln    		{ update_token(WRITELN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
read       		{ update_token(READ_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
readln     		{ update_token(READLN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
return     		{ update_token(RETURN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
int        		{ update_token(INT_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
bool       		{ update_token(BOOL_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
real       		{ update_token(REAL_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
char       		{ update_token(CHAR_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
string     		{ update_token(STRING_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
array      		{ update_token(ARRAY_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
record     		{ update_token(RECORD_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
enum       		{ update_token(ENUM_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
subrange   		{ update_token(SUBRANGE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
set        		{ update_token(SET_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
true			{ update_token(TRUE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
false			{ update_token(FALSE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
nil  			{ update_token(NIL_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
"+"             { update_token('+', num_line, num_column, NULL); update_column(yyleng); return 0; }
"-"         	{ update_token('-', num_line, num_column, NULL); update_column(yyleng); return 0; }
"*"         	{ update_token('*', num_line, num_column, NULL); update_column(yyleng); return 0; }
"/"        		{ update_token('/', num_line, num_column, NULL); update_column(yyleng); return 0; }
"%"        		{ update_token('%', num_line, num_column, NULL); update_column(yyleng); return 0; }
"<="        	{ update_token(LE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
"<"         	{ update_token('<', num_line, num_column, NULL); update_column(yyleng); return 0; }
">"         	{ update_token('>', num_line, num_column, NULL); update_column(yyleng); return 0; }
">="        	{ update_token(GE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
"=="        	{ update_token(EQUAL_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
"!="        	{ update_token(DIFF_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
"&&"        	{ update_token(AND_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
"||"        	{ update_token(OR_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
"!"        		{ update_token('!', num_line, num_column, NULL); update_column(yyleng); return 0; }
"="         	{ update_token('=', num_line, num_column, NULL); update_column(yyleng); return 0; }
":="         	{ update_token(ATTR_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
"->"         	{ update_token(ACCESS_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }
";"         	{ update_token(';', num_line, num_column, NULL); update_column(yyleng); return 0; }
","         	{ update_token(',', num_line, num_column, NULL); update_column(yyleng); return 0; }
"."         	{ update_token('.', num_line, num_column, NULL); update_column(yyleng); return 0; }
"("         	{ update_token('(', num_line, num_column, NULL); update_column(yyleng); return 0; }
")"         	{ update_token(')', num_line, num_column, NULL); update_column(yyleng); return 0; }
"["         	{ update_token('[', num_line, num_column, NULL); update_column(yyleng); return 0; }
"]"         	{ update_token(']', num_line, num_column, NULL); update_column(yyleng); return 0; }
"{"         	{ update_token('{', num_line, num_column, NULL); update_column(yyleng); return 0; }
"}"         	{ update_token('}', num_line, num_column, NULL); update_column(yyleng); return 0; }
".."         	{ update_token(RANGE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return 0; }

{LABEL}			  { update_token(LABEL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return 0; }
{CHARLITERAL}	  { update_token(CHARLITERAL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return 0; }
{LINECOMMENT}	  { num_line++; num_column = 1; }
{NEW_LINE}        { num_line++; num_column = 1; }
{INTLITERAL}      { update_token(INTLITERAL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return 0; }
{REALLITERAL}     { update_token(REALLITERAL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return 0; }
{STRINGLITERAL}   { update_token(STRINGLITERAL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return 0; }
{SUBRANGELITERAL} { update_token(SUBRANGELITERAL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return 0; }
{ID}              { update_token(ID_TOKEN, num_line, num_column, yytext); update_column(yyleng); return 0; }
{WHITESPACE}      { update_column(yyleng); }
{UNACCEPTABLE}	  { update_token(ERROR_TOKEN, num_line, num_column, yytext); return 0; }

%%

void next_token() {
	yylex();
}

void init_lexer(char* arg) {
	yyin = fopen(arg, "r");
}

