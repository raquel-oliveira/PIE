#ifndef _TOKENS_H_
#define _TOKENS_H_

enum {
	ENDOFFILE_TOKEN = 128, 
	PROGRAM_TOKEN, 
	PROC_TOKEN, 
	BEGIN_TOKEN, 
	END_TOKEN,
    FUNC_TOKEN, 
    CONST_TOKEN, 
    TYPE_TOKEN, 
    VAR_TOKEN, 
    IF_TOKEN,
    ELSE_TOKEN,
    GOTO_TOKEN,
    FOR_TOKEN,
    TO_TOKEN,
    DO_TOKEN,
    STEP_TOKEN,
    IN_TOKEN,
    OF_TOKEN,
    LOOP_TOKEN,
    EXITWHEN_TOKEN,
    CASE_TOKEN,
    WRITE_TOKEN,
    WRITELN_TOKEN,
    READ_TOKEN,
    READLN_TOKEN,
    RETURN_TOKEN,
    INT_TOKEN,
    BOOL_TOKEN,
    REAL_TOKEN,
    CHAR_TOKEN,
    STRING_TOKEN,
    ARRAY_TOKEN,
    RECORD_TOKEN,
    ENUM_TOKEN,
    SUBRANGE_TOKEN,
    SET_TOKEN,
    TRUE_TOKEN,
    FALSE_TOKEN,
    NIL_TOKEN,
    LE_TOKEN,
    GE_TOKEN,
    EQUAL_TOKEN,
    DIFF_TOKEN,
    AND_TOKEN,
    OR_TOKEN,
    ATTR_TOKEN,
    LABEL_TOKEN,
    CHARLITERAL_TOKEN,
    INTLITERAL_TOKEN,
    REALLITERAL_TOKEN,
    STRINGLITERAL_TOKEN,
    ID_TOKEN,
    ERROR_TOKEN
 };

struct Token {
	int token;
	int row, col;
	char* lexeme;
};

struct Token t;

#endif