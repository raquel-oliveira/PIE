%{
//https://github.com/jinankjain/Lexical-Analyzer-for-C/blob/master/analyzer.l
#include <math.h>

FILE *yyin;
int num_line = 0, num_column = 0;

void printInfo() {
	printf("{%d, %d} ", num_line, num_column);
}

void updateColumn(int yyleng){
	num_column += yyleng;
}
%}

LETTER       [a-zA-Z]
DIGIT        [0-9]
NATURAL      {DIGIT}+
INTLITERAL      ("-"|"+")?{NATURAL}+
EXPONENT     ([E|e]("+"|"-")?({DIGIT}+))
R            ([0-9]*[.])?[0-9]+
R2 	 		 ([0-9]*[.])?[0-9]+{EXPONENT}?
REALLITERAL 		 (("-"|"+")?{R}|("-"|"+")?{R2})
NEW_LINE     (\n)
TAB          [ \t]+
STRINGLITERAL       \"[^"\n]*\"
LINECOMMENT  "#"((.)*)\n
CHARLITERAL 	 \'[^']*\'
ID           {LETTER}({LETTER}|{DIGIT}|"_")*
LABEL        @({LETTER}|{DIGIT}|"_")*
WHITESPACE   [ \t\v\n\f]*
UNACCEPTABLE .

%%



program    		{ printInfo(); printf("PROGRAM "); updateColumn(yyleng); }
proc       		{ printInfo(); printf("PROC "); updateColumn(yyleng); }
begin      		{ printInfo(); printf("BEGIN "); updateColumn(yyleng); }
end        		{ printInfo(); printf("END "); updateColumn(yyleng); }
func       		{ printInfo(); printf("FUNC "); updateColumn(yyleng); }
const      		{ printInfo(); printf("CONST "); updateColumn(yyleng); }
type       		{ printInfo(); printf("TYPE "); updateColumn(yyleng); }
var        		{ printInfo(); printf("VAR "); updateColumn(yyleng); }
if         		{ printInfo(); printf("IF "); updateColumn(yyleng); }
else       		{ printInfo(); printf("ELSE "); updateColumn(yyleng); }
goto       		{ printInfo(); printf("GOTO "); updateColumn(yyleng); }
for        		{ printInfo(); printf("FOR "); updateColumn(yyleng); }
to         		{ printInfo(); printf("TO "); updateColumn(yyleng); }
do         		{ printInfo(); printf("DO "); updateColumn(yyleng); }
step       		{ printInfo(); printf("STEP "); updateColumn(yyleng); }
in         		{ printInfo(); printf("IN "); updateColumn(yyleng); }
of         		{ printInfo(); printf("OF "); updateColumn(yyleng); }
loop       		{ printInfo(); printf("LOOP "); updateColumn(yyleng); }
exitwhen   		{ printInfo(); printf("EXITWHEN "); updateColumn(yyleng); }
case       		{ printInfo(); printf("CASE "); updateColumn(yyleng); }
write      		{ printInfo(); printf("WRITE "); updateColumn(yyleng); }
writeln    		{ printInfo(); printf("WRITELN "); updateColumn(yyleng); }
read       		{ printInfo(); printf("READ "); updateColumn(yyleng); }
readln     		{ printInfo(); printf("READLN "); updateColumn(yyleng); }
return     		{ printInfo(); printf("RETURN "); updateColumn(yyleng); }
int        		{ printInfo(); printf("INT "); updateColumn(yyleng); }
bool       		{ printInfo(); printf("BOOL "); updateColumn(yyleng); }
real       		{ printInfo(); printf("REAL "); updateColumn(yyleng); }
char       		{ printInfo(); printf("CHAR "); updateColumn(yyleng); }
string     		{ printInfo(); printf("STRING "); updateColumn(yyleng); }
array      		{ printInfo(); printf("ARRAY "); updateColumn(yyleng); }
record     		{ printInfo(); printf("RECORD "); updateColumn(yyleng); }
enum       		{ printInfo(); printf("ENUM "); updateColumn(yyleng); }
subrange   		{ printInfo(); printf("SUBRANGE "); updateColumn(yyleng); }
set        		{ printInfo(); printf("SET "); updateColumn(yyleng); }
true			    { printInfo(); printf("TRUE "); updateColumn(yyleng); }
false			    { printInfo(); printf("FALSE "); updateColumn(yyleng); }
nil  			    { printInfo(); printf("NIL "); updateColumn(yyleng); }
"+"           { printInfo(); printf("PLUS "); updateColumn(yyleng); }
"-"         	{ printInfo(); printf("MINUS "); updateColumn(yyleng); }
"*"         	{ printInfo(); printf("MULTIPLICATION "); updateColumn(yyleng); }
"/"        		{ printInfo(); printf("DIVISION "); updateColumn(yyleng); }
"%"        		{ printInfo(); printf("MOD "); updateColumn(yyleng); }
"<="        	{ printInfo(); printf("LESSEQUALl "); updateColumn(yyleng); }
"<"         	{ printInfo(); printf("LESS "); updateColumn(yyleng); }
">"         	{ printInfo(); printf("GREATER "); updateColumn(yyleng); }
">="        	{ printInfo(); printf("GREATEREQUAL "); updateColumn(yyleng); }
"=="        	{ printInfo(); printf("EQUAL "); updateColumn(yyleng); }
"!="        	{ printInfo(); printf("NOTEQUAL "); updateColumn(yyleng); }
"&&"        	{ printInfo(); printf("AND "); updateColumn(yyleng); }
"||"        	{ printInfo(); printf("OR "); updateColumn(yyleng); }
"!"        		{ printInfo(); printf("NOT "); updateColumn(yyleng); }
"="         	{ printInfo(); printInfo(); printf("ASSIGN "); updateColumn(yyleng); }
":="         	{ printInfo(); printf("ATTRIBUTION "); updateColumn(yyleng); }
";"         	{ printInfo(); printf("SEMICOLON "); updateColumn(yyleng); }
","         	{ printInfo(); printf("COMMA "); updateColumn(yyleng); }
"."         	{ printInfo(); printf("DOT "); updateColumn(yyleng); }
"("         	{ printInfo(); printf("LEFTPAREN "); updateColumn(yyleng); }
")"         	{ printInfo(); printf("RIGHTPAREN "); updateColumn(yyleng); }
"["         	{ printInfo(); printf("LEFTBRACKET "); updateColumn(yyleng); }
"]"         	{ printInfo(); printf("RIGHTBRACKET "); updateColumn(yyleng); }
"{"         	{ printInfo(); printf("LEFTBRACE "); updateColumn(yyleng); }
"}"         	{ printInfo(); printf("RIGHTBRACE "); updateColumn(yyleng); }

{LABEL}			    { printInfo(); printf("LABEL: %s ", yytext); updateColumn(yyleng); }
{CHARLITERAL}		  { printInfo(); printf("CHAR: %s ", yytext); updateColumn(yyleng); }
{LINECOMMENT}	  { printInfo(); printf("LINECOMMENT\n"); num_line++; num_column = 0; }
{NEW_LINE}      { printf("\n"); num_line++; num_column = 0; }
{NATURAL}       { printInfo(); printf("NATURAL %s ", yytext); updateColumn(yyleng);}
{INTLITERAL}       { printInfo(); printf("INTEGER: %s ", yytext); updateColumn(yyleng);}
{REALLITERAL}  { printInfo(); printf("REAL: %s ", yytext); updateColumn(yyleng);}
{STRINGLITERAL}		    { printInfo(); printf("STRING: %s ", yytext); updateColumn(yyleng);}
{ID}            { printInfo(); printf("ID: %s ", yytext); updateColumn(yyleng); }
{WHITESPACE}    {updateColumn(yyleng);}
{UNACCEPTABLE}	{ printInfo(); printf("ERROR: %s ", yytext); }

%%

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1], "r");
    yylex();
    return 0;
}
