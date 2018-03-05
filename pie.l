  int value;
  char* word;
  enum {ENDOFFILE = 128, NUMBER, ID, ENDTOKEN};

DIGIT [0-9]
NATURAL {DIGIT}+
INTEGER ("-"|"+")?{NATURAL}+
/* Mudar integer to accept E... */
R  ([0-9]*[.])?[0-9]+
REALLITERAL (("-"|"+")?{R})
NUMBER ({NATURAL}|{INTEGER}|{REAL})
CHARLITERAL [a-zA-Z]
ID {CHARLITERAL}({CHARLITERAL}|{DIGIT}|_)*
LABEL "@"{ID}
PROGRAM program
PROC proc
BEGIN begin
ENDTOKEN end
FUNC func
CONST const
TYPE type
VAR var
IF if
ELSE else
GOTO goto
FOR for
TO to
DO do
STEP step
IN in
OF of
LOOP loop
EXITWHEN exitwhen
CASE case
WRITE write
WRITELN writeln
READ read
READLN readln
RETURN return
INT int
BOOL bool
REAL real
CHAR char
STRING string
ARRAY array
RECORD record
ENUM enum
SUBRANGE subrange
SET set
BOOLLITERAL (true)|(false)|(nil)

%%

{ENDTOKEN} {return ENDTOKEN;}
; {return ';';}
{NUMBER} {value = atoi(yytext); return NUMBER;}
{ID} {word = yytext; return ID;}
<<EOF>>  {return EOF;}

%%
int main () {
	int x;
	while((x = yylex()) && x != ENDOFFILE) {
		printf ("%d \n", x);
		if(x == NUMBER)
			printf("%d\n", value);
		else if(x == ID)
			printf("%s\n", word);
	}
	return 0;
}
