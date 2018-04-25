%option yylineno
%{
//https://github.com/jinankjain/Lexical-Analyzer-for-C/blob/master/analyzer.l
#include <math.h>
#include "../include/utils.h"

int yycolumn = 1;
#define YY_USER_ACTION         \
  yylloc.first_line = yylloc.last_line = yylineno;\
  yylloc.first_column = yycolumn;\
  yylloc.last_column = yycolumn + yyleng;\
  yycolumn += yyleng; 



int num_line = 1, num_column = 1;

void update_column(int yyleng) {
	num_column += yyleng;
}

void update_token(int id, int row, int col, char* lexeme) {
	yylval.id = id;
	yylval.row = row;
	yylval.col = col;
	yylval.lexeme = lexeme;
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


<<EOF>>     	{ update_token(ENDOFFILE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return ENDOFFILE_TOKEN; }
program    		{ update_token(PROGRAM_TOKEN, num_line, num_column, NULL); update_column(yyleng); return PROGRAM_TOKEN; }
proc       		{ update_token(PROC_TOKEN, num_line, num_column, NULL); update_column(yyleng); return PROC_TOKEN; }
begin      		{ update_token(BEGIN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return BEGIN_TOKEN; }
end        		{ update_token(END_TOKEN, num_line, num_column, NULL); update_column(yyleng); return END_TOKEN; }
func       		{ update_token(FUNC_TOKEN, num_line, num_column, NULL); update_column(yyleng); return FUNC_TOKEN; }
const      		{ update_token(CONST_TOKEN, num_line, num_column, NULL); update_column(yyleng); return CONST_TOKEN; }
type       		{ update_token(TYPE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return TYPE_TOKEN; }
var        		{ update_token(VAR_TOKEN, num_line, num_column, NULL); update_column(yyleng); return VAR_TOKEN; }
if         		{ update_token(IF_TOKEN, num_line, num_column, NULL); update_column(yyleng); return IF_TOKEN; }
else       		{ update_token(ELSE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return ELSE_TOKEN; }
goto       		{ update_token(GOTO_TOKEN, num_line, num_column, NULL); update_column(yyleng); return GOTO_TOKEN; }
for        		{ update_token(FOR_TOKEN, num_line, num_column, NULL); update_column(yyleng); return FOR_TOKEN; }
to         		{ update_token(TO_TOKEN, num_line, num_column, NULL); update_column(yyleng); return TO_TOKEN; }
do         		{ update_token(DO_TOKEN, num_line, num_column, NULL); update_column(yyleng); return DO_TOKEN; }
step       		{ update_token(STEP_TOKEN, num_line, num_column, NULL); update_column(yyleng); return STEP_TOKEN; }
in         		{ update_token(IN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return IN_TOKEN; }
of         		{ update_token(OF_TOKEN, num_line, num_column, NULL); update_column(yyleng); return OF_TOKEN; }
loop       		{ update_token(LOOP_TOKEN, num_line, num_column, NULL); update_column(yyleng); return LOOP_TOKEN; }
exitwhen   		{ update_token(EXITWHEN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return EXITWHEN_TOKEN; }
case       		{ update_token(CASE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return CASE_TOKEN; }
write      		{ update_token(WRITE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return WRITE_TOKEN; }
writeln    		{ update_token(WRITELN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return WRITELN_TOKEN; }
read       		{ update_token(READ_TOKEN, num_line, num_column, NULL); update_column(yyleng); return READ_TOKEN; }
readln     		{ update_token(READLN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return READLN_TOKEN; }
return     		{ update_token(RETURN_TOKEN, num_line, num_column, NULL); update_column(yyleng); return RETURN_TOKEN; }
int        		{ update_token(INT_TOKEN, num_line, num_column, NULL); update_column(yyleng); return INT_TOKEN; }
bool       		{ update_token(BOOL_TOKEN, num_line, num_column, NULL); update_column(yyleng); return BOOL_TOKEN; }
real       		{ update_token(REAL_TOKEN, num_line, num_column, NULL); update_column(yyleng); return REAL_TOKEN; }
char       		{ update_token(CHAR_TOKEN, num_line, num_column, NULL); update_column(yyleng); return CHAR_TOKEN; }
string     		{ update_token(STRING_TOKEN, num_line, num_column, NULL); update_column(yyleng); return STRING_TOKEN; }
array      		{ update_token(ARRAY_TOKEN, num_line, num_column, NULL); update_column(yyleng); return ARRAY_TOKEN; }
record     		{ update_token(RECORD_TOKEN, num_line, num_column, NULL); update_column(yyleng); return RECORD_TOKEN; }
subrange   		{ update_token(SUBRANGE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return SUBRANGE_TOKEN; }
set        		{ update_token(SET_TOKEN, num_line, num_column, NULL); update_column(yyleng); return SET_TOKEN; }
true			{ update_token(TRUE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return TRUE_TOKEN; }
false			{ update_token(FALSE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return FALSE_TOKEN; }
ref				{ update_token(REF_TOKEN, num_line, num_column, NULL); update_column(yyleng); return REF_TOKEN; }
nil  			{ update_token(NIL_TOKEN, num_line, num_column, NULL); update_column(yyleng); return NIL_TOKEN; }
"+"             { update_token('+', num_line, num_column, NULL); update_column(yyleng); return '+'; }
"-"         	{ update_token('-', num_line, num_column, NULL); update_column(yyleng); return '-'; }
"*"         	{ update_token('*', num_line, num_column, NULL); update_column(yyleng); return '*'; }
"/"        		{ update_token('/', num_line, num_column, NULL); update_column(yyleng); return '/'; }
"%"        		{ update_token('%', num_line, num_column, NULL); update_column(yyleng); return '%'; }
"<="        	{ update_token(LE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return LE_TOKEN; }
"<"         	{ update_token('<', num_line, num_column, NULL); update_column(yyleng); return '<'; }
">"         	{ update_token('>', num_line, num_column, NULL); update_column(yyleng); return '>'; }
">="        	{ update_token(GE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return GE_TOKEN; }
"=="        	{ update_token(EQUAL_TOKEN, num_line, num_column, NULL); update_column(yyleng); return EQUAL_TOKEN; }
"!="        	{ update_token(DIFF_TOKEN, num_line, num_column, NULL); update_column(yyleng); return DIFF_TOKEN; }
"&&"        	{ update_token(AND_TOKEN, num_line, num_column, NULL); update_column(yyleng); return AND_TOKEN; }
"||"        	{ update_token(OR_TOKEN, num_line, num_column, NULL); update_column(yyleng); return OR_TOKEN; }
"!"        		{ update_token('!', num_line, num_column, NULL); update_column(yyleng); return '!'; }
"="         	{ update_token('=', num_line, num_column, NULL); update_column(yyleng); return '='; }
":="         	{ update_token(ATTR_TOKEN, num_line, num_column, NULL); update_column(yyleng); return ATTR_TOKEN; }
"->"         	{ update_token(ACCESS_TOKEN, num_line, num_column, NULL); update_column(yyleng); return ACCESS_TOKEN; }
";"         	{ update_token(';', num_line, num_column, NULL); update_column(yyleng); return ';'; }
","         	{ update_token(',', num_line, num_column, NULL); update_column(yyleng); return ','; }
"."         	{ update_token('.', num_line, num_column, NULL); update_column(yyleng); return '.'; }
"("         	{ update_token('(', num_line, num_column, NULL); update_column(yyleng); return '('; }
")"         	{ update_token(')', num_line, num_column, NULL); update_column(yyleng); return ')'; }
"["         	{ update_token('[', num_line, num_column, NULL); update_column(yyleng); return '['; }
"]"         	{ update_token(']', num_line, num_column, NULL); update_column(yyleng); return ']'; }
"{"         	{ update_token('{', num_line, num_column, NULL); update_column(yyleng); return '{'; }
"}"         	{ update_token('}', num_line, num_column, NULL); update_column(yyleng); return '}'; }
".."         	{ update_token(RANGE_TOKEN, num_line, num_column, NULL); update_column(yyleng); return RANGE_TOKEN; }

{LABEL}			  { update_token(LABEL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return LABEL_TOKEN; }
{CHARLITERAL}	  { update_token(CHARLITERAL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return CHARLITERAL_TOKEN; }
{LINECOMMENT}	  { num_line++; num_column = 1; }
{NEW_LINE}        { num_line++; num_column = 1; }
{INTLITERAL}      { update_token(INTLITERAL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return INTLITERAL_TOKEN; }
{REALLITERAL}     { update_token(REALLITERAL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return REALLITERAL_TOKEN; }
{STRINGLITERAL}   { update_token(STRINGLITERAL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return STRINGLITERAL_TOKEN; }
{SUBRANGELITERAL} { update_token(SUBRANGELITERAL_TOKEN, num_line, num_column, yytext); update_column(yyleng); return SUBRANGELITERAL_TOKEN; }
{ID}              { update_token(ID_TOKEN, num_line, num_column, yytext); update_column(yyleng); return ID_TOKEN; }
{WHITESPACE}      { update_column(yyleng); }
{UNACCEPTABLE}	  { update_token(ERROR_TOKEN, num_line, num_column, yytext); return ERROR_TOKEN; }

%%

void next_token() {
	yylex();
}

void init_lexer(char* arg) {
	yyin = fopen(arg, "r");
}
