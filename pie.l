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
EXPONENT    ((E|e)("+"|"-")?({DIGIT}+))
ID  ({LETTER}|"_")({LETTER}|{DIGIT}|"_")*   

%%
"//"((.)*)\n                            printf("LineComment\n");
"/*"(([^*]|(("*"+)[^*/]))*)("*"+)"/"\n  printf("MultilineComment\n");


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
"<="        	{ printf("lessequal "); }
"<"         	{ printf("less "); }
">"         	{ printf("greater "); }
">="        	{ printf("greaterequal "); }
"=="        	{ printf("equal "); }
"!="        	{ printf("notequal "); }
"="         	{ printf("assignop "); }
";"         	{ printf("semicolon "); }
","         	{ printf("comma "); }
"("         	{ printf("leftparen "); }
")"         	{ printf("rightparen "); }
"["         	{ printf("leftbracket "); }
"]"         	{ printf("rightbracket "); }
"{"         	{ printf("leftbrace "); }
"}"         	{ printf("rightbrace "); }

{NEW_LINE}      { printf("\n"); }
{NATURAL}       { printf("natural "); }
{INTEGER}       { printf("integer "); }
{REAL_LITERAL}  { printf("real "); }
{STRING}        { printf("string "); }
{ID}            { printf("id "); }

.               {; }

%%

int yywrap(void) {
    return 1;
}

int main(void) {
    yylex();
    return 0;
}
