%{
#include <math.h>   
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
<<<<<<< HEAD
ID  ({LETTER}|"_")({LETTER}|{DIGIT}|"_")*   
=======
ID  {LETTER}({LETTER}|{DIGIT}|"_")*
LABEL @({LETTER}|{DIGIT}|"_")*  
UNACCEPTABLE .+
>>>>>>> ef4a6ea3d1ff1d3872e3a2a18b6493e04bb08fc3

%%
                            


program    		{ printf("%s ", yytext); }
proc       		{ printf("%s ", yytext); }
begin      		{ printf("%s ", yytext); }
end        		{ printf("%s ", yytext); }
func       		{ printf("%s ", yytext); }
const      		{ printf("%s ", yytext); }
type       		{ printf("%s ", yytext); }
var        		{ printf("%s ", yytext); }
if         		{ printf("%s ", yytext); }
else       		{ printf("%s ", yytext); }
goto       		{ printf("%s ", yytext); }
for        		{ printf("%s ", yytext); }
to         		{ printf("%s ", yytext); }
do         		{ printf("%s ", yytext); }
step       		{ printf("%s ", yytext); }
in         		{ printf("%s ", yytext); }
of         		{ printf("%s ", yytext); }
loop       		{ printf("%s ", yytext); }
exitwhen   		{ printf("%s ", yytext); }
case       		{ printf("%s ", yytext); }
write      		{ printf("%s ", yytext); }
writeln    		{ printf("%s ", yytext); }
read       		{ printf("%s ", yytext); }
readln     		{ printf("%s ", yytext); }
return     		{ printf("%s ", yytext); }
int        		{ printf("%s ", yytext); }
bool       		{ printf("%s ", yytext); }
real       		{ printf("%s ", yytext); }
char       		{ printf("%s ", yytext); }
string     		{ printf("%s ", yytext); }
array      		{ printf("%s ", yytext); }
record     		{ printf("%s ", yytext); }
enum       		{ printf("%s ", yytext); }
subrange   		{ printf("%s ", yytext); }
set        		{ printf("%s ", yytext); }
true|false|nil  { printf("boolconstant ");} 
"+"             { printf("plus "); }
"-"         	{ printf("minus "); }
"*"         	{ printf("multiplication "); }
"/"        		{ printf("division "); }
"%"        		{ printf("mod "); }
"<="        	{ printf("lessequal "); }
"<"         	{ printf("less "); }
">"         	{ printf("greater "); }
">="        	{ printf("greaterequal "); }
"=="        	{ printf("equal "); }
"!="        	{ printf("notequal "); }
"&&"        	{ printf("and "); }
"||"        	{ printf("or "); }
"!"        		{ printf("not "); }
"="         	{ printf("assignop "); }
":="         	{ printf("attributionop "); }
";"         	{ printf("semicolon "); }
","         	{ printf("comma "); }
"("         	{ printf("leftparen "); }
")"         	{ printf("rightparen "); }
"["         	{ printf("leftbracket "); }
"]"         	{ printf("rightbracket "); }
"{"         	{ printf("leftbrace "); }
"}"         	{ printf("rightbrace "); }

<<<<<<< HEAD
=======
{LABEL}			{ printf("label: %s ", yytext); }
>>>>>>> ef4a6ea3d1ff1d3872e3a2a18b6493e04bb08fc3
{CHARACTER}		{ printf("char: %s ", yytext); }
{LINECOMMENT}	{ printf("LineComment\n"); }
{NEW_LINE}      { printf("\n"); }
{NATURAL}       { printf("natural "); }
{INTEGER}       { printf("integer: %s", yytext); }
{REAL_LITERAL}  { printf("real: %s", yytext); }
{STRING}		{ printf("string: %s ", yytext); }
{ID}            { printf("id: %s ", yytext); }
<<<<<<< HEAD

.               {; }
=======
{UNACCEPTABLE}	{ printf("error: %s ", yytext); }
>>>>>>> ef4a6ea3d1ff1d3872e3a2a18b6493e04bb08fc3

%%

int yywrap(void) {
    return 1;
}

FILE *yyin;

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1], "r");
    yylex();
    return 0;
}
