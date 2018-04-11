#include "../include/tokens.h"

void print_token(int token) {
	switch(token) {
		case ENDOFFILE_TOKEN:
			std::cout << "ENDOFFILE_TOKEN";
			break;
		case PROGRAM_TOKEN:
			std::cout << "PROGRAM_TOKEN";
			break;
		case PROC_TOKEN:
			std::cout << "PROC_TOKEN";
			break;
		case BEGIN_TOKEN:
			std::cout << "BEGIN_TOKEN";
			break;
		case END_TOKEN:
			std::cout << "END_TOKEN";
			break;
		case FUNC_TOKEN:
			std::cout << "FUNC_TOKEN";
			break;
		case CONST_TOKEN:
			std::cout << "CONST_TOKEN";
			break;
		case TYPE_TOKEN:
			std::cout << "TYPE_TOKEN";
			break;
		case VAR_TOKEN:
			std::cout << "VAR_TOKEN";
			break;
		case IF_TOKEN:
			std::cout << "IF_TOKEN";
			break;
		case ELSE_TOKEN:
			std::cout << "ELSE_TOKEN";
			break;
		case GOTO_TOKEN:
			std::cout << "GOTO_TOKEN";
			break;
		case FOR_TOKEN:
			std::cout << "FOR_TOKEN";
			break;
		case TO_TOKEN:
			std::cout << "TO_TOKEN";
			break;
		case DO_TOKEN:
			std::cout << "DO_TOKEN";
			break;
		case STEP_TOKEN:
			std::cout << "STEP_TOKEN";
			break;
		case IN_TOKEN:
			std::cout << "IN_TOKEN";
			break;
		case OF_TOKEN:
			std::cout << "OF_TOKEN";
			break;
		case LOOP_TOKEN:
			std::cout << "LOOP_TOKEN";
			break;
		case EXITWHEN_TOKEN:
			std::cout << "EXITWHEN_TOKEN";
			break;
		case CASE_TOKEN:
			std::cout << "CASE_TOKEN";
			break;
		case WRITE_TOKEN:
			std::cout << "WRITE_TOKEN";
			break;
		case WRITELN_TOKEN:
			std::cout << "WRITELN_TOKEN";
			break;
		case READ_TOKEN:
			std::cout << "READ_TOKEN";
			break;
		case READLN_TOKEN:
			std::cout << "READLN_TOKEN";
			break;
		case RETURN_TOKEN:
			std::cout << "RETURN_TOKEN";
			break;
		case INT_TOKEN:
			std::cout << "INT_TOKEN";
			break;
		case BOOL_TOKEN:
			std::cout << "BOOL_TOKEN";
			break;
		case REAL_TOKEN:
			std::cout << "REAL_TOKEN";
			break;
		case CHAR_TOKEN:
			std::cout << "CHAR_TOKEN";
			break;
		case STRING_TOKEN:
			std::cout << "STRING_TOKEN";
			break;
		case ARRAY_TOKEN:
			std::cout << "ARRAY_TOKEN";
			break;
		case RECORD_TOKEN:
			std::cout << "RECORD_TOKEN";
			break;
		case ENUM_TOKEN:
			std::cout << "ENUM_TOKEN";
			break;
		case SUBRANGE_TOKEN:
			std::cout << "SUBRANGE_TOKEN";
			break;
		case SET_TOKEN:
			std::cout << "SET_TOKEN";
			break;
		case TRUE_TOKEN:
			std::cout << "TRUE_TOKEN";
			break;
		case FALSE_TOKEN:
			std::cout << "FALSE_TOKEN";
			break;
		case NIL_TOKEN:
			std::cout << "NIL_TOKEN";
			break;
		case LE_TOKEN:
			std::cout << "LE_TOKEN";
			break;
		case GE_TOKEN:
			std::cout << "GE_TOKEN";
			break;
		case EQUAL_TOKEN:
			std::cout << "EQUAL_TOKEN";
			break;
		case DIFF_TOKEN:
			std::cout << "DIFF_TOKEN";
			break;
		case AND_TOKEN:
			std::cout << "AND_TOKEN";
			break;
		case OR_TOKEN:
			std::cout << "OR_TOKEN";
			break;
		case ATTR_TOKEN:
			std::cout << "ATTR_TOKEN";
			break;
		case LABEL_TOKEN:
			std::cout << "LABEL_TOKEN";
			break;
		case CHARLITERAL_TOKEN:
			std::cout << "CHARLITERAL_TOKEN";
			break;
		case INTLITERAL_TOKEN:
			std::cout << "INTLITERAL_TOKEN";
			break;
		case REALLITERAL_TOKEN:
			std::cout << "REALLITERAL_TOKEN";
			break;
		case STRINGLITERAL_TOKEN:
			std::cout << "STRINGLITERAL_TOKEN";
			break;
		case ID_TOKEN:
			std::cout << "ID_TOKEN";
			break;
		case ERROR_TOKEN:
			std::cout << "ERROR_TOKEN";
			break;
		case RANGE_TOKEN:
			std::cout << "RANGE_TOKEN";
			break;
	}
}