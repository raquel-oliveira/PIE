%{
#include <math.h>   

FILE *yyin;
int num_line = 0, num_column = 0;

void printInfo(){
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
                            


program    		{ printInfo(); printf("%s ", yytext); }
proc       		{ printInfo(); printf("%s ", yytext); }
begin      		{ printInfo(); printf("%s ", yytext); }
end        		{ printInfo(); printf("%s ", yytext); }
func       		{ printInfo(); printf("%s ", yytext); }
const      		{ printInfo(); printf("%s ", yytext); }
type       		{ printInfo(); printf("%s ", yytext); }
var        		{ printInfo(); printf("%s ", yytext); }
if         		{ printInfo(); printf("%s ", yytext); }
else       		{ printInfo(); printf("%s ", yytext); }
goto       		{ printInfo(); printf("%s ", yytext); }
for        		{ printInfo(); printf("%s ", yytext); }
to         		{ printInfo(); printf("%s ", yytext); }
do         		{ printInfo(); printf("%s ", yytext); }
step       		{ printInfo(); printf("%s ", yytext); }
in         		{ printInfo(); printf("%s ", yytext); }
of         		{ printInfo(); printf("%s ", yytext); }
loop       		{ printInfo(); printf("%s ", yytext); }
exitwhen   		{ printInfo(); printf("%s ", yytext); }
case       		{ printInfo(); printf("%s ", yytext); }
write      		{ printInfo(); printf("%s ", yytext); }
writeln    		{ printInfo(); printf("%s ", yytext); }
read       		{ printInfo(); printf("%s ", yytext); }
readln     		{ printInfo(); printf("%s ", yytext); }
return     		{ printInfo(); printf("%s ", yytext); }
int        		{ printInfo(); printf("%s ", yytext); }
bool       		{ printInfo(); printf("%s ", yytext); }
real       		{ printInfo(); printf("%s ", yytext); }
char       		{ printInfo(); printf("%s ", yytext); }
string     		{ printInfo(); printf("%s ", yytext); }
array      		{ printInfo(); printf("%s ", yytext); }
record     		{ printInfo(); printf("%s ", yytext); }
enum       		{ printInfo(); printf("%s ", yytext); }
subrange   		{ printInfo(); printf("%s ", yytext); }
set        		{ printInfo(); printf("%s ", yytext); }
true|false|nil  { printInfo(); printf("boolconstant ");} 
"+"             { printInfo(); printf("plus "); }
"-"         	{ printInfo(); printf("minus "); }
"*"         	{ printInfo(); printf("multiplication "); }
"/"        		{ printInfo(); printf("division "); }
"%"        		{ printInfo(); printf("mod "); }
"<="        	{ printInfo(); printf("lessequal "); }
"<"         	{ printInfo(); printf("less "); }
">"         	{ printInfo(); printf("greater "); }
">="        	{ printInfo(); printf("greaterequal "); }
"=="        	{ printInfo(); printf("equal "); }
"!="        	{ printInfo(); printf("notequal "); }
"&&"        	{ printInfo(); printf("and "); }
"||"        	{ printInfo(); printf("or "); }
"!"        		{ printInfo(); printf("not "); }
"="         	{ printInfo(); printInfo(); printf("assignop "); }
":="         	{ printInfo(); printf("attributionop "); }
";"         	{ printInfo(); printf("semicolon "); }
","         	{ printInfo(); printf("comma "); }
"("         	{ printInfo(); printf("leftparen "); }
")"         	{ printInfo(); printf("rightparen "); }
"["         	{ printInfo(); printf("leftbracket "); }
"]"         	{ printInfo(); printf("rightbracket "); }
"{"         	{ printInfo(); printf("leftbrace "); }
"}"         	{ printInfo(); printf("rightbrace "); }

{LABEL}			{ printInfo(); printf("label: %s ", yytext); }
{CHARACTER}		{ printInfo(); printf("char: %s ", yytext); num_column++;}
{LINECOMMENT}	{ printInfo(); printf("LineComment\n"); num_line++; num_column = 0;}
{NEW_LINE}      { printf("\n"); num_line++; num_column = 0;}
{NATURAL}       { printInfo(); printf("natural "); }
{INTEGER}       { printInfo(); printf("integer: %s", yytext); }
{REAL_LITERAL}  { printInfo(); printf("real: %s", yytext); }
{STRING}		{ printInfo(); printf("string: %s ", yytext); }
{ID}            { printInfo(); printf("id: %s ", yytext); }
{UNACCEPTABLE}	{ printInfo(); printf("error: %s ", yytext);}

%%

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1], "r");
    yylex();
    return 0;
}
