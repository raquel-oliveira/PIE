%{
#include <math.h>

FILE *yyin;
int num_line = 0, num_column = 0;

void printInfo() {
	printf("{%d, %d} ", num_line, num_column);
}
%}

LETTER      [a-zA-Z]
DIGIT       [0-9]
NATURAL {DIGIT}+
INTEGER ("-"|"+")?{NATURAL}+
R  ([0-9]*[.])?[0-9]+
REAL_LITERAL (("-"|"+")?{R})
NEW_LINE     (\n)
TAB          [ \t]+
STRING      \"[^"\n]*\"
LINECOMMENT "#"((.)*)\n
EXPONENT    ([Ee]("+"|"-")?({DIGIT}+))
CHARACTER 	\'[^']*\'
ID  {LETTER}({LETTER}|{DIGIT}|"_")*
LABEL @({LETTER}|{DIGIT}|"_")*
UNACCEPTABLE .+

%%

program    		{ printInfo(); printf("PROGRAM "); num_column += 7; }
proc       		{ printInfo(); printf("PROC "); num_column += 4; }
begin      		{ printInfo(); printf("BEGIN "); num_column += 5; }
end        		{ printInfo(); printf("END "); num_column += 3; }
func       		{ printInfo(); printf("FUNC "); num_column += 4; }
const      		{ printInfo(); printf("CONST "); num_column += 5; }
type       		{ printInfo(); printf("TYPE "); num_column += 4; }
var        		{ printInfo(); printf("VAR "); num_column += 3; }
if         		{ printInfo(); printf("IF "); num_column += 2; }
else       		{ printInfo(); printf("ELSE "); num_column += 4; }
goto       		{ printInfo(); printf("GOTO "); num_column += 4; }
for        		{ printInfo(); printf("FOR "); num_column += 3; }
to         		{ printInfo(); printf("TO "); num_column += 2; }
do         		{ printInfo(); printf("DO "); num_column += 2; }
step       		{ printInfo(); printf("STEP "); num_column += 4; }
in         		{ printInfo(); printf("IN "); num_column += 2; }
of         		{ printInfo(); printf("OF "); num_column += 2; }
loop       		{ printInfo(); printf("LOOP "); num_column += 4; }
exitwhen   		{ printInfo(); printf("EXITWHEN "); num_column += 8; }
case       		{ printInfo(); printf("CASE "); num_column += 4; }
write      		{ printInfo(); printf("WRITE "); num_column += 5; }
writeln    		{ printInfo(); printf("WRITELN "); num_column += 7; }
read       		{ printInfo(); printf("READ "); num_column += 4; }
readln     		{ printInfo(); printf("READLN "); num_column += 6; }
return     		{ printInfo(); printf("RETURN "); num_column += 6; }
int        		{ printInfo(); printf("INT "); num_column += 3; }
bool       		{ printInfo(); printf("BOOL "); num_column += 4; }
real       		{ printInfo(); printf("REAL "); num_column += 4; }
char       		{ printInfo(); printf("CHAR "); num_column += 4; }
string     		{ printInfo(); printf("STRING "); num_column += 6; }
array      		{ printInfo(); printf("ARRAY "); num_column += 5; }
record     		{ printInfo(); printf("RECORD "); num_column += 6; }
enum       		{ printInfo(); printf("ENUM "); num_column += 4; }
subrange   		{ printInfo(); printf("SUBRANGE "); num_column += 8; }
set        		{ printInfo(); printf("SET "); num_column += 3; }
true			    { printInfo(); printf("TRUE "); num_column += 4; }
false			    { printInfo(); printf("FALSE "); num_column += 5; }
nil  			    { printInfo(); printf("NIL "); num_column += 3; }
"+"           { printInfo(); printf("PLUS "); num_column += 1; }
"-"         	{ printInfo(); printf("MINUS "); num_column += 1; }
"*"         	{ printInfo(); printf("MULTIPLICATION "); num_column += 1; }
"/"        		{ printInfo(); printf("DIVISION "); num_column += 1; }
"%"        		{ printInfo(); printf("MOD "); num_column += 1; }
"<="        	{ printInfo(); printf("LESSEQUALl "); num_column += 2; }
"<"         	{ printInfo(); printf("LESS "); num_column += 1; }
">"         	{ printInfo(); printf("GREATER "); num_column += 1; }
">="        	{ printInfo(); printf("GREATEREQUAL "); num_column += 2; }
"=="        	{ printInfo(); printf("EQUAL "); num_column += 2; }
"!="        	{ printInfo(); printf("NOTEQUAL "); num_column += 2; }
"&&"        	{ printInfo(); printf("AND "); num_column += 2; }
"||"        	{ printInfo(); printf("OR "); num_column += 2; }
"!"        		{ printInfo(); printf("NOT "); num_column += 1; }
"="         	{ printInfo(); printInfo(); printf("ASSIGN "); num_column += 1; }
":="         	{ printInfo(); printf("ATTRIBUTION "); num_column += 2; }
";"         	{ printInfo(); printf("SEMICOLON "); num_column += 1; }
","         	{ printInfo(); printf("COMMA "); num_column += 1; }
"("         	{ printInfo(); printf("LEFTPAREN "); num_column += 1; }
")"         	{ printInfo(); printf("RIGHTPAREN "); num_column += 1; }
"["         	{ printInfo(); printf("LEFTBRACKET "); num_column += 1; }
"]"         	{ printInfo(); printf("RIGHTBRACKET "); num_column += 1; }
"{"         	{ printInfo(); printf("LEFTBRACE "); num_column += 1; }
"}"         	{ printInfo(); printf("RIGHTBRACE "); num_column += 1; }

{LABEL}			    { printInfo(); printf("LABEL: %s ", yytext); }
{CHARACTER}		  { printInfo(); printf("CHAR: %s ", yytext); num_column++; }
{LINECOMMENT}	  { printInfo(); printf("LINECOMMENT\n"); num_line++; num_column = 0; }
{NEW_LINE}      { printf("NEWLINE\n"); num_line++; num_column = 0; }
{NATURAL}       { printInfo(); printf("NATURAL %s ", yytext); }
{INTEGER}       { printInfo(); printf("INTEGER: %s ", yytext); }
{REAL_LITERAL}  { printInfo(); printf("REAL: %s ", yytext); }
{STRING}		    { printInfo(); printf("STRING: %s ", yytext); }
{ID}            { printInfo(); printf("ID: %s ", yytext); }
{UNACCEPTABLE}	{ printInfo(); printf("ERROR: %s ", yytext); }

%%

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1], "r");
    yylex();
    return 0;
}
