%{
//https://github.com/jinankjain/Lexical-Analyzer-for-C/blob/master/analyzer.l
#include <math.h>
#include "include/tokens.h"

int num_line = 1, num_column = 1;

void updateColumn(int yyleng) {
	num_column += yyleng;
}

void updateToken(int token, int row, int col, char* lexeme) {
	t.token = token;
	t.row = row;
	t.col = col;
	t.lexeme = lexeme;
}

%}

LETTER        [a-zA-Z]
DIGIT         [0-9]
INTLITERAL    ("-"|"+")?{DIGIT}+
EXPONENT      ([E|e]("+"|"-")?({DIGIT}+))
R             ([0-9]*[.])?[0-9]+
R2 	 		  ([0-9]*[.])?[0-9]+{EXPONENT}?
REALLITERAL   (("-"|"+")?{R}|("-"|"+")?{R2})
NEW_LINE      (\n)
TAB           [ \t]+
STRINGLITERAL \"[^"\n]*\"
LINECOMMENT   "#"((.)*)\n
CHARLITERAL   \'[^']*\'
ID            {LETTER}({LETTER}|{DIGIT}|"_")*
LABEL         @({LETTER}|{DIGIT}|"_")*
WHITESPACE    [ \t\v\f]*
UNACCEPTABLE  .

%%


<<EOF>>     	{ updateToken(ENDOFFILE_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
program    		{ updateToken(PROGRAM_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
proc       		{ updateToken(PROC_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
begin      		{ updateToken(BEGIN_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
end        		{ updateToken(END_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
func       		{ updateToken(FUNC_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
const      		{ updateToken(CONST_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
type       		{ updateToken(TYPE_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
var        		{ updateToken(VAR_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
if         		{ updateToken(IF_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
else       		{ updateToken(ELSE_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
goto       		{ updateToken(GOTO_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
for        		{ updateToken(FOR_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
to         		{ updateToken(TO_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
do         		{ updateToken(DO_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
step       		{ updateToken(STEP_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
in         		{ updateToken(IN_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
of         		{ updateToken(OF_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
loop       		{ updateToken(LOOP_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
exitwhen   		{ updateToken(EXITWHEN_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
case       		{ updateToken(CASE_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
write      		{ updateToken(WRITE_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
writeln    		{ updateToken(WRITELN_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
read       		{ updateToken(READ_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
readln     		{ updateToken(READLN_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
return     		{ updateToken(RETURN_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
int        		{ updateToken(INT_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
bool       		{ updateToken(BOOL_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
real       		{ updateToken(REAL_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
char       		{ updateToken(CHAR_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
string     		{ updateToken(STRING_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
array      		{ updateToken(ARRAY_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
record     		{ updateToken(RECORD_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
enum       		{ updateToken(ENUM_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
subrange   		{ updateToken(SUBRANGE_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
set        		{ updateToken(SET_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
true			{ updateToken(TRUE_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
false			{ updateToken(FALSE_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
nil  			{ updateToken(NIL_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"+"             { updateToken('+', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"-"         	{ updateToken('-', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"*"         	{ updateToken('*', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"/"        		{ updateToken('/', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"%"        		{ updateToken('%', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"<="        	{ updateToken(LE_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"<"         	{ updateToken('<', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
">"         	{ updateToken('>', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
">="        	{ updateToken(GE_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"=="        	{ updateToken(EQUAL_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"!="        	{ updateToken(DIFF_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"&&"        	{ updateToken(AND_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"||"        	{ updateToken(OR_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"!"        		{ updateToken('!', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"="         	{ updateToken('=', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
":="         	{ updateToken(ATTR_TOKEN, num_line, num_column, NULL); updateColumn(yyleng); return 0; }
";"         	{ updateToken(';', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
","         	{ updateToken(',', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"."         	{ updateToken('.', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"("         	{ updateToken('(', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
")"         	{ updateToken(')', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"["         	{ updateToken('[', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"]"         	{ updateToken(']', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"{"         	{ updateToken('{', num_line, num_column, NULL); updateColumn(yyleng); return 0; }
"}"         	{ updateToken('}', num_line, num_column, NULL); updateColumn(yyleng); return 0; }


{LABEL}			{ updateToken(LABEL_TOKEN, num_line, num_column, yytext); updateColumn(yyleng); return 0; }
{CHARLITERAL}	{ updateToken(CHARLITERAL_TOKEN, num_line, num_column, yytext); updateColumn(yyleng); return 0; }
{LINECOMMENT}	{ num_line++; num_column = 1; }
{NEW_LINE}      { num_line++; num_column = 1; }
{INTLITERAL}    { updateToken(INTLITERAL_TOKEN, num_line, num_column, yytext); updateColumn(yyleng); return 0; }
{REALLITERAL}   { updateToken(REALLITERAL_TOKEN, num_line, num_column, yytext); updateColumn(yyleng); return 0; }
{STRINGLITERAL} { updateToken(STRINGLITERAL_TOKEN, num_line, num_column, yytext); updateColumn(yyleng); return 0; }
{ID}            { updateToken(ID_TOKEN, num_line, num_column, yytext); updateColumn(yyleng); return 0; }
{WHITESPACE}    { updateColumn(yyleng); }
{UNACCEPTABLE}	{ updateToken(ERROR_TOKEN, num_line, num_column, yytext); return 0; }

%%

void nextToken() {
	yylex();
}

void initLexer(char* arg) {
	yyin = fopen(arg, "r");
}