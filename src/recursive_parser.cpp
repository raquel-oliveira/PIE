#include <iostream>
#include <fstream>
#include <string>
#include "../include/recursive_parser.hpp"

int main(int argc, char *argv[]) {
	if(argc < 2) {
		std::cout << "Not enough arguments." << argc << std::endl;
		return 0;
	}
	init_lexer(argv[1]);
	next_token();
	if(token.id != ENDOFFILE_TOKEN && token.id != ERROR_TOKEN) {
		prog();
	}
	if(token.id == ERROR_TOKEN) {
		std::cout << "Non recognized symbol '" << token.lexeme << "' in line " << token.row << " column " << token.col << std::endl;
	}
	return 0;
}

void eat(int expected) {
	if(token.id != expected) {
		std::cout << "ERROR: At row " << token.row << " column " << token.col << std::endl;
		std::cout << "	Expected: ";
		print_token(expected);
		std::cout << std::endl;
		std::cout << "	Found: ";
		print_token(token.id);
		if(token.lexeme != NULL) {
			std::cout << " (with lexeme " << token.lexeme << ")";
		}
		std::cout << std::endl;
	}
	if(token.id != ENDOFFILE_TOKEN)
		next_token();
}

void error() {
	std::cout << "ERROR: At row " << token.row << " column " << token.col << std::endl;
	std::cout << "	Not expected symbol: ";
	print_token(token.id);
	if(token.lexeme != NULL) {
		std::cout << " (with lexeme " << token.lexeme << ")";
	}
	std::cout << std::endl;
	if(token.id != ENDOFFILE_TOKEN)
		next_token();
}

void prog() {
	switch(token.id) {
		case PROGRAM_TOKEN:
			eat(PROGRAM_TOKEN);
			eat(ID_TOKEN);
			eat(';');
			decl();
			block();
			eat('.');
			break;
		default:
			error();
	}
}

//DECL -> CONSTS USERTYPES VARS SUBPROGRAMS
void decl() {
	switch(token.id) {
		case BEGIN_TOKEN:
		case CONST_TOKEN:
		case TYPE_TOKEN:
		case VAR_TOKEN:
		case PROC_TOKEN:
		case FUNC_TOKEN:
			consts();
			usertypes();
			vars();
			subprograms();
			break;
		default:
			error();
	}
}

//CONSTS -> ''
//CONSTS -> 'const' LISTCONST
void consts() {
	switch(token.id) {
		case CONST_TOKEN:
			eat(CONST_TOKEN);
			listconst();
			break;
		case VAR_TOKEN:
		case PROC_TOKEN:
		case FUNC_TOKEN:
		case TYPE_TOKEN:
		case BEGIN_TOKEN:
			break;
		default:
			error();
	}
}

//LISTCONST -> CONSTDECL LISTCONSTPRIME
void listconst() {
	switch(token.id) {
		case ID_TOKEN:
			constdecl();
			listconstprime();
			break;
		default:
			error();
	}
}

//LISTCONSTPRIME -> LISTCONST
void listconstprime() {
	switch(token.id) {
		case ID_TOKEN:
			listconst();
			break;
		case VAR_TOKEN:
		case PROC_TOKEN:
		case FUNC_TOKEN:
		case TYPE_TOKEN:
		case BEGIN_TOKEN:
			break;
		default:
			error();
	}
}

//CONSTDECL -> 'id' '=' EXPR ';'
void constdecl() {
	switch(token.id) {
		case ID_TOKEN:
			eat(ID_TOKEN);
			eat('=');
			expr();
			eat(';');
			break;
		default:
			error();
	}
}

//TYPES -> 'id' TYPESPRIME
//TYPES -> PRIMTYPES
void types() {
	switch(token.id) {
		case ID_TOKEN:
			eat(ID_TOKEN);
			typesprime();
			break;
		case INT_TOKEN:
		case REAL_TOKEN:
		case BOOL_TOKEN:
		case CHAR_TOKEN:
		case STRING_TOKEN:
		case ARRAY_TOKEN:
		case RECORD_TOKEN:
		case SET_TOKEN:
		case '(':
			primtypes();
			break;
		default:
			error();
	}
}

//TYPESPRIME -> ''
//TYPESPRIME -> '..' SUBRANGETYPE
void typesprime() {
	switch(token.id) {
		case RANGE_TOKEN:
			eat(RANGE_TOKEN);
			subrangetype();
			break;
		case ';':
		case ID_TOKEN:
			break;
		default:
			error();
	}
}

// PRIMTYPES -> 'int' TYPESPRIME
// PRIMTYPES -> 'real'
// PRIMTYPES -> 'bool'
// PRIMTYPES -> 'char' TYPESPRIME
// PRIMTYPES -> 'string'
// PRIMTYPES -> ARRAYTYPE
// PRIMTYPES -> SETTYPE
// PRIMTYPES -> ENUMTYPE
// PRIMTYPES -> RECORDTYPE
void primtypes() {
	switch(token.id) {
		case INT_TOKEN:
			eat(INT_TOKEN);
			typesprime();
			break;
		case REAL_TOKEN:
			eat(REAL_TOKEN);
			break;
		case BOOL_TOKEN:
			eat(BOOL_TOKEN);
			break;
		case CHAR_TOKEN:
			eat(CHAR_TOKEN);
			typesprime();
			break;
		case STRING_TOKEN:
			eat(STRING_TOKEN);
			break;
		case ARRAY_TOKEN:
			arraytype();
			break;
		case RECORD_TOKEN:
			recordtype();
			break;
		case SET_TOKEN:
			settype();
			break;
		case '(':
			enumtype();
			break;
		default:
			error();
	}
}

//ARRAYTYPE -> 'array' '[' SUBRANGELIST ']' 'of' TYPES
void arraytype() {
	switch(token.id) {
		case ARRAY_TOKEN:
			eat(ARRAY_TOKEN);
			eat('[');
			subrangelist();
			eat(']');
			eat(OF_TOKEN);
			types();
			break;
		default:
			error();
	}
}

void subrangelist() {
	switch(token.id) {
		case ID_TOKEN:
			eat(ID_TOKEN);
			subrangeprime();
			break;
		case INT_TOKEN:
			eat(INT_TOKEN);
			eat(RANGE_TOKEN);
			subrangetype();
			subrangelistprime();
			break;
		case CHAR_TOKEN:
			eat(CHAR_TOKEN);
			eat(RANGE_TOKEN);
			subrangetype();
			subrangelistprime();
			break;
		default:
			error();
	}
}

void subrangeprime() {
	switch(token.id) {
		case RANGE_TOKEN:
			eat(RANGE_TOKEN);
			subrangetype();
			subrangelistprime();
			break;
		case ']':
		case ',':
			subrangelistprime();
			break;
		default:
			error();
	}
}

void subrangelistprime() {
	switch(token.id) {
		case ',':
			eat(',');
		    subrangelist();
		case ']':
			break;
		default:
			error();
	}
}

void subrangetype() {
	switch(token.id) {
		case ID_TOKEN:
			eat(ID_TOKEN);
			break;
		case INT_TOKEN:
			eat(INT_TOKEN);
			break;
		case CHAR_TOKEN:
			eat(CHAR_TOKEN);
			break;
		default:
			error();
	}
}

void settype() {
	switch(token.id) {
		case SET_TOKEN:
			eat(SET_TOKEN);
			eat(OF_TOKEN);
			types();
			break;
		default:
			error();
	}
}

void enumtype() {
	switch(token.id) {
		case '(':
			eat('(');
			idlist();
			eat(')');
			break;
		default:
			error();
	}
}

void recordtype() {
	switch(token.id) {
		case RECORD_TOKEN:
			eat(RECORD_TOKEN);
			varlistlist();
			eat(END_TOKEN);
			break;
		default:
			error();
	}
}

void usertypes() {
	switch(token.id) {
		case TYPE_TOKEN:
			eat(TYPE_TOKEN);
			listusertypes();
		case VAR_TOKEN:
		case PROC_TOKEN:
		case FUNC_TOKEN:
		case BEGIN_TOKEN:
			break;
		default:
			error();
	}
}

void listusertypes() {
	switch(token.id) {
		case ID_TOKEN:
			usertype();
			listusertypesprime();
			break;
		default:
			error();
	}
}

void listusertypesprime() {
	switch(token.id) {
		case VAR_TOKEN:
		case BEGIN_TOKEN:
		case PROC_TOKEN:
		case FUNC_TOKEN:
			break;
		case ID_TOKEN:
			listusertypes();
			break;
		default:
			error();
	}
}

void usertype() {
	switch(token.id) {
		case ID_TOKEN:
			eat(ID_TOKEN);
			eat('=');
			types();
			eat(';');
			break;
		default:
			error();
	}
}

void vars() {
	switch(token.id) {
		case PROC_TOKEN:
		case FUNC_TOKEN:
		case BEGIN_TOKEN:
			break;
		case VAR_TOKEN:
			eat(VAR_TOKEN);
			varlistlist();
			break;
		default:
			error();
	}
}

void varlistlist() {
	switch(token.id) {
		case '(':
		case ID_TOKEN:
		case INT_TOKEN:
		case REAL_TOKEN:
		case BOOL_TOKEN:
		case CHAR_TOKEN:
		case STRING_TOKEN:
		case ARRAY_TOKEN:
		case SET_TOKEN:
		case RECORD_TOKEN:
			varlist();
			varlistlistprime();
			break;
		default:
			error();
	}
}

void varlistlistprime() {
	switch(token.id) {
		case ID_TOKEN:
		case INT_TOKEN:
		case REAL_TOKEN:
		case BOOL_TOKEN:
		case CHAR_TOKEN:
		case STRING_TOKEN:
		case ARRAY_TOKEN:
		case SET_TOKEN:
		case '(':
		case RECORD_TOKEN:
			varlistlist();
			break;
		case ')':
		case END_TOKEN:
		case BEGIN_TOKEN:
		case PROC_TOKEN:
		case FUNC_TOKEN:
			break;
		default:
			error();

	}
}

void varlist() {
	switch(token.id) {
		case '(':
		case ID_TOKEN:
		case INT_TOKEN:
		case REAL_TOKEN:
		case BOOL_TOKEN:
		case CHAR_TOKEN:
		case STRING_TOKEN:
		case ARRAY_TOKEN:
		case SET_TOKEN:
		case RECORD_TOKEN:
			types();
			idlist();
			eat(';');
			break;
		default:
			error();
	}
}

void idlist() {
	switch(token.id) {
		case ID_TOKEN:
			eat(ID_TOKEN);
			idattr();
			idlistprime();
			break;
		default:
			error();
	}
}

void idlistprime() {
	switch(token.id) {
		case ';':
		case ')':
			break;
		case ',':
			eat(',');
			idlist();
			break;
		default:
			error();
	}
}

void idattr() {
	switch(token.id) {
		case ';':
		case ',':
		case ')':
			break;
		case '=':
			eat('=');
			expr();
			break;
		default:
			error();
	}
}

void variable() {
	switch(token.id) {
		case '[':
			eat('[');
			exprlist_plus();
			eat(']');
			variableprime();
			break;
		case ACCESS_TOKEN:
			eat(ACCESS_TOKEN);
			eat(ID_TOKEN);
			variableprime();
			break;
		default:
			error();
	}
}

void variableprime() {
	switch(token.id) {
		case ';':
		case ']':
		case ',':
		case ')':
		case '+':
		case '-':
		case '*':
		case '/':
		case '%':
		case '<':
		case '>':
		case ID_TOKEN:
		case OF_TOKEN:
		case END_TOKEN:
		case BEGIN_TOKEN:
		case LABEL_TOKEN:
		case EXITWHEN_TOKEN:
		case RETURN_TOKEN:
		case ATTR_TOKEN:
		case IF_TOKEN:
		case ELSE_TOKEN:
		case LOOP_TOKEN:
		case CASE_TOKEN:
		case GOTO_TOKEN:
		case FOR_TOKEN:
		case TO_TOKEN:
		case STEP_TOKEN:
		case DO_TOKEN:
		case OR_TOKEN:
		case EQUAL_TOKEN:
		case DIFF_TOKEN:
		case LE_TOKEN:
		case GE_TOKEN:
		case AND_TOKEN:
		case WRITE_TOKEN:
		case WRITELN_TOKEN:
		case READ_TOKEN:
		case READLN_TOKEN:
			break;
		case '[':
		case ACCESS_TOKEN:
			variable();
			break;
		default:
			error();
	}
}

void block() {
	switch(token.id) {
		case BEGIN_TOKEN:
			eat(BEGIN_TOKEN);
			stmts();
			eat(END_TOKEN);
			break;
		default:
			error();
	}
}

void stmts() {
	switch(token.id) {
		case ID_TOKEN:
		case ';':
		case END_TOKEN:
		case BEGIN_TOKEN:
		case LABEL_TOKEN:
		case EXITWHEN_TOKEN:
		case RETURN_TOKEN:
		case IF_TOKEN:
		case LOOP_TOKEN:
		case CASE_TOKEN:
		case GOTO_TOKEN:
		case FOR_TOKEN:
		case WRITE_TOKEN:
		case WRITELN_TOKEN:
		case READ_TOKEN:
		case READLN_TOKEN:
			stmt();
			stmtlistprime();
			break;
		default:
			error();
	}
}

void stmtlistprime() {
	switch(token.id) {
		case END_TOKEN:
			break;
		case ';':
			eat(';');
			stmts();
			break;
		default:
			error();
	}
}

void stmt() {
	switch(token.id) {
		case ';':
		case END_TOKEN:
		case ELSE_TOKEN:
			break;
		case LABEL_TOKEN:
			eat(LABEL_TOKEN);
			stmt();
			break;
		case BEGIN_TOKEN:
			block();
			break;
		case WRITE_TOKEN:
			writestmt();
			break;
		case WRITELN_TOKEN:
			writelnstmt();
			break;
		case READ_TOKEN:
			readstmt();
			break;
		case READLN_TOKEN:
			readlnstmt();
			break;
		case LOOP_TOKEN:
			loopblock();
			break;
		case IF_TOKEN:
			ifblock();
			break;
		case FOR_TOKEN:
			forblock();
			break;
		case CASE_TOKEN:
			caseblock();
			break;
		case GOTO_TOKEN:
			gotostmt();
			break;
		case ID_TOKEN:
			eat(ID_TOKEN);
			stmtprime();
			break;
		case EXITWHEN_TOKEN:
			exitstmt();
			break;
		case RETURN_TOKEN:
			returnstmt();
			break;
		default:
			error();
	}
}

//STMTPRIME -> ATTRSTMT
//STMTPRIME -> SUBPROGCALL
void stmtprime() {
	switch(token.id) {
		case '[':
		case ACCESS_TOKEN:
		case ATTR_TOKEN:
			attrstmt();
			break;
		case '(':
			subprogcall();
			break;
		default:
			error();
	}
}

//SUBPROGCALL -> '(' EXPRLIST ')'
void subprogcall() {
	switch(token.id){
		case '(':
			eat('(');
			exprlist();
			eat(')');
			break;
		default:
			error();
	}
}

//EXITSTMT -> 'exitwhen' EXPR
void exitstmt() {
	switch (token.id) {
		case EXITWHEN_TOKEN:
			eat(EXITWHEN_TOKEN);
			expr();
			break;
		default:
			error();
	}
}

//RETURNSTMT -> 'return' EXPR
void returnstmt() {
	switch (token.id) {
		case RETURN_TOKEN:
			eat(RETURN_TOKEN);
			expr();
			break;
		default:
			error();
	}
}

//ATTRSTMT -> VARIABLE ':=' EXPR
//ATTRSTMT -> ':=' EXPR
void attrstmt() {
	switch (token.id) {
		case '[':
		case ACCESS_TOKEN:
			variable();
			eat(ATTR_TOKEN);
			expr();
			break;
		case ATTR_TOKEN:
			eat(ATTR_TOKEN);
			expr();
			break;
		default:
			error();
	}
}

// IFBLOCK -> 'if' EXPR STMT ELSEBLOCK
void ifblock() {
	switch(token.id){
		case IF_TOKEN:
			eat(IF_TOKEN);
			expr();
			stmt();
			elseblock();
			break;
		default:
			error();

	}
}

//ELSEBLOCK -> 'else' STMT
void elseblock() {
	switch(token.id){
		case ';':
		case END_TOKEN:
			break;
		case ELSE_TOKEN:
			eat(ELSE_TOKEN);
			stmt();
			break;
		default:
			error();
	}
}

//LOOPBLOCK -> 'loop' STMT
void loopblock() {
	switch(token.id){
		case LOOP_TOKEN:
			eat(LOOP_TOKEN);
			stmt();
			break;
		default:
			error();
	}
}

//CASEBLOCK -> 'case' EXPR 'of' CASELIST CASEBLOCKPRIME
void caseblock() {
	switch(token.id){
		case CASE_TOKEN:
			eat(CASE_TOKEN);
			expr();
			eat(OF_TOKEN);
			caselist();
			caseblockprime();
			break;
		default:
			error();
	}
}

//CASEBLOCKPRIME -> 'end'
//CASEBLOCKPRIME -> 'else' STMT 'end'
void caseblockprime() {
	switch(token.id){
		case END_TOKEN:
			eat(END_TOKEN);
			break;
		case ELSE_TOKEN:
			eat(ELSE_TOKEN);
			stmt();
			eat(END_TOKEN);
			break;
		default:
			error();
	}
}

//CASELIST -> LITERALLIST ':' STMT ';'
void caselist() {
	switch(token.id){
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGE_TOKEN:
			eat(':');
			stmt();
			eat(';');
			break;
		default:
			error();
	}
}

//LITERALLIST -> LITERAL LITERALLISTPRIME
void literallist() {
	switch (token.id) {
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGE_TOKEN:
		 	literallistprime();
			break;
		default:
			error();
	}
}

//LITERALLISTPRIME -> LAMBDA
//LITERALLISTPRIME -> ',' LITERALLIST
void literallistprime() {
	switch (token.id) {
		case ':':
			break;
		case ',':
			eat(',');
			literallist();
			break;
		default:
			error();
	}
}

//GOTOSTMT -> 'goto' 'label'
void gotostmt() {
	switch (token.id) {
		case GOTO_TOKEN:
			eat(GOTO_TOKEN);
			eat(LABEL_TOKEN);
			break;
		default:
			error();
	}
}

//FORBLOCK -> 'for' 'id' FORBLOCKPRIME
void forblock() {
	switch (token.id) {
		case FOR_TOKEN:
			eat(FOR_TOKEN);
			eat(ID_TOKEN);
			forblockprime();
			break;
		default:
			error();
	}
}

//FORBLOCKPRIME -> VARIABLE ':=' EXPR to EXPR 'step' EXPR 'do' STMT
//FORBLOCKPRIME -> ':=' EXPR to EXPR 'step' EXPR 'do' STMT
void forblockprime() {
	switch (token.id) {
		case '[':
		case ACCESS_TOKEN:
			variable();
		case ATTR_TOKEN:
			eat(ATTR_TOKEN);
			expr();
			eat(TO_TOKEN);
			expr();
			eat(STEP_TOKEN);
			expr();
			eat(DO_TOKEN);
			stmt();
			break;
		default:
			error();
	}
}

void expr() {
	switch(token.id) {
		case ID_TOKEN:
		case '(':
		case '!':
		case CHARLITERAL_TOKEN:
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGELITERAL_TOKEN:
			conj();
			disj();
			break;
		default:
			error();
	}
}

void disj() {
	switch(token.id) {
		case ';':
		case ']':
		case OF_TOKEN:
		case ',':
		case ')':
		case ID_TOKEN:
		case END_TOKEN:
		case BEGIN_TOKEN:
		case LABEL_TOKEN:
		case EXITWHEN_TOKEN:
		case RETURN_TOKEN:
		case IF_TOKEN:
		case LOOP_TOKEN:
		case CASE_TOKEN:
		case FOR_TOKEN:
		case GOTO_TOKEN:
		case ELSE_TOKEN:
		case TO_TOKEN:
		case STEP_TOKEN:
		case DO_TOKEN:
		case WRITE_TOKEN:
		case WRITELN_TOKEN:
		case READ_TOKEN:
		case READLN_TOKEN:
			break;
		case OR_TOKEN:
			eat(OR_TOKEN);
			conj();
			break;
		default:
			error();
	}
}

void final_term() {
	switch(token.id) {
		case ID_TOKEN:
			eat(ID_TOKEN);
			final_termprime();
			break;
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGELITERAL_TOKEN:
			literal();
			break;
		case '(':
			eat('(');
			expr();
			eat(')');
			break;
		default:
			error();
	}
}

void final_termprime() {
	switch(token.id) {
		case '[':
		case ACCESS_TOKEN:
			variable();
			break;
		case ';':
		case ']':
		case OF_TOKEN:
		case ID_TOKEN:
		case ',':
		case ')':
		case END_TOKEN:
		case BEGIN_TOKEN:
		case LABEL_TOKEN:
		case EXITWHEN_TOKEN:
		case RETURN_TOKEN:
		case ELSE_TOKEN:
		case IF_TOKEN:
		case LOOP_TOKEN:
		case CASE_TOKEN:
		case GOTO_TOKEN:
		case FOR_TOKEN:
		case TO_TOKEN:
		case STEP_TOKEN:
		case DO_TOKEN:
		case OR_TOKEN:
		case '+':
		case '-':
		case '*':
		case '/':
		case '%':
		case EQUAL_TOKEN:
		case DIFF_TOKEN:
		case '>':
		case LE_TOKEN:
		case '<':
		case GE_TOKEN:
		case AND_TOKEN:
		case WRITELN_TOKEN:
		case WRITE_TOKEN:
		case READLN_TOKEN:
		case READ_TOKEN:
			break;
		case '(':
			subprogcall();
			break;
		default:
			error();
	}
}

void add_op() {
	switch(token.id) {
		case '+':
			eat('+');
			break;
		case '-':
			eat('-');
			break;
		default :
			error();
	}
}

void mul_op() {
	switch(token.id) {
		case '*':
			eat('*');
			break;
		case '/':
			eat('/');
			break;
		case '%':
			eat('%');
			break;
		default :
			error();
	}
}

void equality_op() {
	switch(token.id) {
		case EQUAL_TOKEN:
			eat(EQUAL_TOKEN);
			break;
		case DIFF_TOKEN:
			eat(DIFF_TOKEN);
			break;
		default:
			error();
	}
}

void relational_op() {
	switch(token.id) {
		case '<':
			eat('<');
			break;
		case LE_TOKEN:
			eat(LE_TOKEN);
			break;
		case '>':
			eat('>');
			break;
		case GE_TOKEN:
			eat(GE_TOKEN);
			break;
		default:
			error();
	}
}

void conj() {
	switch(token.id) {
		case ID_TOKEN:
		case '(':
		case '!':
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGELITERAL_TOKEN:
			comp();
			conjprime();
			break;
		default:
			error();
	}
}

void conjprime() {
	switch(token.id) {
		case ';':
		case ']':
		case OF_TOKEN:
		case ',':
		case ')':
		case ID_TOKEN:
		case END_TOKEN:
		case BEGIN_TOKEN:
		case LABEL_TOKEN:
		case EXITWHEN_TOKEN:
		case RETURN_TOKEN:
		case IF_TOKEN:
		case LOOP_TOKEN:
		case CASE_TOKEN:
		case FOR_TOKEN:
		case GOTO_TOKEN:
		case ELSE_TOKEN:
		case TO_TOKEN:
		case STEP_TOKEN:
		case DO_TOKEN:
		case WRITE_TOKEN:
		case WRITELN_TOKEN:
		case READ_TOKEN:
		case READLN_TOKEN:
		case OR_TOKEN:
			break;
		case AND_TOKEN:
			eat(AND_TOKEN);
			comp();
			break;
		default:
			error();
	}
}

void comp() {
	switch(token.id){
		case ID_TOKEN:
		case '(':
		case '!':
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGELITERAL_TOKEN:
			relational();
			compprime();
			break;
		default:
			error();
	}

}

void compprime() {
	switch(token.id) {
		case ID_TOKEN:
		case ';':
		case ']':
		case OF_TOKEN:
		case ',':
		case ')':
		case END_TOKEN:
		case BEGIN_TOKEN:
		case LABEL_TOKEN:
		case EXITWHEN_TOKEN:
		case RETURN_TOKEN:
		case IF_TOKEN:
		case ELSE_TOKEN:
		case LOOP_TOKEN:
		case CASE_TOKEN:
		case GOTO_TOKEN:
		case FOR_TOKEN:
		case TO_TOKEN:
		case STEP_TOKEN:
		case DO_TOKEN:
		case OR_TOKEN:
		case AND_TOKEN:
		case WRITE_TOKEN:
		case WRITELN_TOKEN:
		case READ_TOKEN:
		case READLN_TOKEN:
			break;
		case EQUAL_TOKEN:
		case DIFF_TOKEN:
			equality_op();
			relational();
			break;
		default:
			error();
	}
}

void relational() {
	switch(token.id){
		case ID_TOKEN:
		case '(':
		case '!':
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGELITERAL_TOKEN:
			sum();
			relationalprime();
			break;
		default:
			error();
	}
}

void relationalprime() {
	switch(token.id) {
		case ID_TOKEN:
		case ';':
		case ']':
		case OF_TOKEN:
		case ',':
		case ')':
		case END_TOKEN:
		case BEGIN_TOKEN:
		case LABEL_TOKEN:
		case EXITWHEN_TOKEN:
		case RETURN_TOKEN:
		case IF_TOKEN:
		case ELSE_TOKEN:
		case LOOP_TOKEN:
		case CASE_TOKEN:
		case GOTO_TOKEN:
		case FOR_TOKEN:
		case TO_TOKEN:
		case STEP_TOKEN:
		case DO_TOKEN:
		case OR_TOKEN:
		case EQUAL_TOKEN:
		case DIFF_TOKEN:
		case AND_TOKEN:
		case WRITE_TOKEN:
		case WRITELN_TOKEN:
		case READ_TOKEN:
		case READLN_TOKEN:
			break;
		case '<':
		case LE_TOKEN:
		case '>':
		case GE_TOKEN:
			relational_op();
			sum();
			break;
		default:
			error();
	}
}

void sum() {
	switch(token.id){
		case ID_TOKEN:
		case '(':
		case '!':
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGELITERAL_TOKEN:
			neg();
			sumprime();
			break;
		default:
			error();
	}
}

void sumprime() {
	switch(token.id) {
		case ID_TOKEN:
		case ';':
		case ']':
		case OF_TOKEN:
		case ',':
		case ')':
		case END_TOKEN:
		case BEGIN_TOKEN:
		case LABEL_TOKEN:
		case EXITWHEN_TOKEN:
		case RETURN_TOKEN:
		case IF_TOKEN:
		case ELSE_TOKEN:
		case LOOP_TOKEN:
		case CASE_TOKEN:
		case GOTO_TOKEN:
		case FOR_TOKEN:
		case TO_TOKEN:
		case STEP_TOKEN:
		case DO_TOKEN:
		case OR_TOKEN:
		case EQUAL_TOKEN:
		case DIFF_TOKEN:
		case '<':
		case LE_TOKEN:
		case '>':
		case GE_TOKEN:
		case AND_TOKEN:
		case WRITE_TOKEN:
		case WRITELN_TOKEN:
		case READ_TOKEN:
		case READLN_TOKEN:
			break;
		case '+':
		case '-':
			add_op();
			neg();
			sumprime();
			break;
		default:
			error();
	}
}

/** --------- ARTHUR --------- **/
void neg() {
	switch (token.id) {
		case ID_TOKEN:
		case '(':
		case INTLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGELITERAL_TOKEN:
			mul();
			break;
		case '!':
			eat('!');
			mul();
			break;
		default:
			error();
	}
}

void mul() {
	switch (token.id) {
		case ID_TOKEN:
		case '(':
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGELITERAL_TOKEN:
			final_term();
			mulprime();
			break;
		default:
			error();
	}
}

void mulprime() {
	switch (token.id) {
		case '*':
		case '/':
		case '%':
			mul_op();
			final_term();
			mulprime();
			break;
		case ID_TOKEN:
		case ';':
		case ']':
		case OF_TOKEN:
		case ',':
		case ')':
		case END_TOKEN:
		case BEGIN_TOKEN:
		case LABEL_TOKEN:
		case EXITWHEN_TOKEN:
		case RETURN_TOKEN:
		case IF_TOKEN:
		case ELSE_TOKEN:
		case LOOP_TOKEN:
		case GOTO_TOKEN:
		case CASE_TOKEN:
		case FOR_TOKEN:
		case TO_TOKEN:
		case STEP_TOKEN:
		case DO_TOKEN:
		case OR_TOKEN:
		case '+':
		case '-':
		case EQUAL_TOKEN:
		case DIFF_TOKEN:
		case '<':
		case LE_TOKEN:
		case '>':
		case GE_TOKEN:
		case AND_TOKEN:
		case WRITE_TOKEN:
		case WRITELN_TOKEN:
		case READ_TOKEN:
		case READLN_TOKEN:
			break;
		default:
			error();
	}
}

void literal() {
	switch (token.id) {
		case INTLITERAL_TOKEN:
			eat(INTLITERAL_TOKEN);
			break;
		case REALLITERAL_TOKEN:
			eat(REALLITERAL_TOKEN);
			break;
		case CHARLITERAL_TOKEN:
			eat(CHARLITERAL_TOKEN);
			break;
		case STRINGLITERAL_TOKEN:
			eat(STRINGLITERAL_TOKEN);
			break;
		case SUBRANGELITERAL_TOKEN:
			eat(SUBRANGELITERAL_TOKEN);
			break;
		default:
			error();
	}
}

void exprlist() {
	switch (token.id) {
		case ')':
			break;
		case ID_TOKEN:
		case '(':
		case '!':
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGELITERAL_TOKEN:
			exprlist_plus();
			break;
		default:
			error();
	}
}

void exprlist_plus() {
	switch (token.id) {
		case ID_TOKEN:
		case '(':
		case '!':
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGELITERAL_TOKEN:
			expr();
			exprlist_plusprime();
			break;
		default:
			error();
	}
}

void exprlist_plusprime() {
	switch (token.id) {
		case ']':
		case ')':
			break;
		case ',':
			eat(',');
			exprlist_plus();
			break;
		default:
			error();
	}
}

void subprograms() {
	switch (token.id) {
		case BEGIN_TOKEN:
			break;
		case PROC_TOKEN:
			procedure();
			subprogramsprime();
			break;
		case FUNC_TOKEN:
			function();
			subprogramsprime();
			break;
		default:
			error();
	}
}

void subprogramsprime() {
	switch (token.id) {
		case BEGIN_TOKEN:
			break;
		case ';':
			eat(';');
			subprograms();
			break;
		default:
			error();
	}
}

void procedure() {
	switch (token.id) {
		case PROC_TOKEN:
			eat(PROC_TOKEN);
			eat(ID_TOKEN);
			eat('(');
			param();
			eat(')');
			eat(';');
			decl();
			block();
			break;
		default:
			error();
	}
}

void function() {
	switch (token.id) {
		case FUNC_TOKEN:
			eat(FUNC_TOKEN);
			types();
			eat(ID_TOKEN);
			eat('(');
			param();
			eat(')');
			eat(';');
			decl();
			block();
			break;
		default:
			error();
	}
}

void param() {
	switch (token.id) {
		case ')':
			break;
		case '(':
		case ID_TOKEN:
		case INT_TOKEN:
		case REAL_TOKEN:
		case BOOL_TOKEN:
		case CHAR_TOKEN:
		case STRING_TOKEN:
		case ARRAY_TOKEN:
		case SET_TOKEN:
		case RECORD_TOKEN:
		case REF_TOKEN:
			paramlistlist();
			break;
		default:
			error();
	}
}

void paramlistlist() {
	switch(token.id) {
		case '(':
		case ID_TOKEN:
		case INT_TOKEN:
		case REAL_TOKEN:
		case BOOL_TOKEN:
		case CHAR_TOKEN:
		case STRING_TOKEN:
		case ARRAY_TOKEN:
		case SET_TOKEN:
		case RECORD_TOKEN:
		case REF_TOKEN:
			paramlist();
			paramlistlistprime();
			break;
		default:
			error();
	}
}

void paramlistlistprime() {
	switch(token.id) {
		case ')':
			break;
		case ';':
			eat(';');
			paramlistlist();
			break;
		default:
			error();
	}
}

void paramlist() {
	switch(token.id) {
		case '(':
		case ID_TOKEN:
		case INT_TOKEN:
		case REAL_TOKEN:
		case BOOL_TOKEN:
		case CHAR_TOKEN:
		case STRING_TOKEN:
		case ARRAY_TOKEN:
		case SET_TOKEN:
		case RECORD_TOKEN:
			types();
			idlist();
			break;
		case REF_TOKEN:
			eat(REF_TOKEN);
			types();
			idlist();
			break;
		default:
			error();
	}
}

void writestmt() {
	switch (token.id) {
		case WRITE_TOKEN:
			eat(WRITE_TOKEN);
			eat('(');
			expr();
			eat(')');
			break;
		default:
			error();
	}
}

void writelnstmt() {
	switch (token.id) {
		case WRITELN_TOKEN:
			eat(WRITELN_TOKEN);
			eat('(');
			expr();
			eat(')');
			break;
		default:
			error();
	}
}

void readstmt() {
	switch (token.id) {
		case READ_TOKEN:
			eat(READ_TOKEN);
			eat('(');
			eat(ID_TOKEN);
			variableprime();
			eat(')');
			break;
		default:
			error();
	}
}

void readlnstmt() {
	switch (token.id) {
		case READLN_TOKEN:
			eat(READLN_TOKEN);
			eat('(');
			eat(ID_TOKEN);
			variableprime();
			eat(')');
			break;
		default:
			error();
	}
}
