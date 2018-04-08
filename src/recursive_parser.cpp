#include <iostream>
#include <fstream>
#include <string>
#include "../include/tokens.h"
#include "../include/recursive_parser.hpp"

int main(int argc, char *argv[]) {
	if(argc < 2) {
		std::cout << "Not enough arguments." << argc << std::endl;
		return 0;
	}
	initLexer(argv[1]);
	nextToken();
	if(t.id != ENDOFFILE_TOKEN && t.id != ERROR_TOKEN) {
		prog();
	}
	if(t.id == ERROR_TOKEN) {
		std::cout << "Non recognized symbol '" << t.lexeme << "' in line " << t.row << " column " << t.col << std::endl;
	}
	return 0;
}

void eat(int expected) {
	if(t.id != expected) {
		error();
	}
	else {
		nextToken();
	}
}

void error() {
	std::cout << "ERROR: Not expected symbol in line " << t.row << " column " << t.col << std::endl;
	nextToken();
}

bool prog() {
	switch(t.id) {
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

void decl() {
	switch(t.id) {
		case CONST_TOKEN: 
			consts();
		case USERTYPE_TOKEN: 
			usertypes();
		case VAR_TOKEN: 
			vars();
		case SUBPROGRAM_TOKEN: 
			subprograms();
			break;
		default:
			error();
	}
}

void consts() {
	switch(t.id) {
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

void listconst() {
	switch(t.id) {
		case ID_TOKEN: 
			constdecl();
			listconstprime();
			break;
		default:
			error();
	}
}

void listconstprime() {
	switch(t.id) {
		case ID_TOKEN: 
			listconstprime();
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

void constdecl() {
	switch(t.id) {
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

void types() {
	switch(t.id) {
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
		case ENUM_TOKEN:
			primtypes();
			break;
		default:
			error();
	}
}

void typesprime() {
	switch(t.id) {
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

void primtypes() {
	switch(t.id) {
		case INT_TOKEN: 
			eat(INT_TOKEN);
			primtypesprime();
			break;
		case REAL_TOKEN: 
			eat(REAL_TOKEN);
			break;
		case BOOL_TOKEN: 
			eat(BOOL_TOKEN);
			break;
		case CHAR_TOKEN: 
			eat(CHAR_TOKEN);
			primtypesprime();
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
		case ENUM_TOKEN: 
			enumtype();
			break;
		default:
			error();
	}
}

void primtypesprime() {
	switch(t.id) {
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

void arraytype() {
	switch(t.id) {
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
	switch(t.id) {
		case ID_TOKEN: 
			eat(ID_TOKEN);
			eat(RANGE_TOKEN);
			subrangetype();
			subrangelistprime();
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

void subrangelistprime() {
	switch(t.id) {
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
	switch(t.id) {
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
	switch(t.id) {
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
	switch(t.id) {
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
	switch(t.id) {
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
	switch(t.id) {
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
	switch(t.id) {
		case ID_TOKEN: 
			usertype();
			listusertypesprime();
			break;
		default:
			error();
	}
}

void listusertypesprime() {
	switch(t.id) {
		case VAR_TOKEN:
		case BEGIN_TOKEN: 
			break;
		case ID_TOKEN: 
			listusertypes();
			break;
		default:
			error();
	}
}

void usertype() {
	switch(t.id) {
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
	switch(t.id) {
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
	switch(t.id) {
		case ID_TOKEN: 
			varlist();
			varlistlistprime();
			break;
		default:
			error();
	}
}

void varlistlistprime() {
	switch(t.id) {
		case '(':
		case ID_TOKEN:
		case INT_TOKEN:
		case REAL_TOKEN:
		case BOOL_TOKEN:
		case CHAR_TOKEN:
		case STRING_TOKEN:
		case ARRAY_TOKEN:
		case SET_TOKEN:
		case RECORD_TYPE: 
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
	switch(t.id) {
		case '(':
		case ID_TOKEN:
		case INT_TOKEN:
		case REAL_TOKEN:
		case BOOL_TOKEN:
		case CHAR_TOKEN:
		case STRING_TOKEN:
		case ARRAY_TOKEN:
		case SET_TOKEN:
		case RECORD_TYPE: 
			types();
			idlist();
			eat(';');
			break;
		default:
			error();
	}
}

void idlist() {
	switch(t.id) {
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
	switch(t.id) {
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
	switch(t.id) {
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
	switch(t.id) {
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
	switch(t.id) {
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
		case OF_TOKEN:
		case END_TOKEN:
		case ATTR_TOKEN:
		case ELSE_TOKEN:
		case TO_TOKEN:
		case STEP_TOKEN:
		case DO_TOKEN:
		case OR_TOKEN:
		case EQUAL_TOKEN:
		case DIFF_TOKEN:
		case LE_TOKEN:
		case GE_TOKEN:
		case AND_TOKEN: 
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
	switch(t.id) {
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
	switch(t.id) {
		case ID_TOKEN:
		case ';':
		case END_TOKEN:
		case BEGIN_TOKEN:
		case LABEL_TOKEN:
		case EXITSTMT_TOKEN:
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
	switch(t.id) {
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
	switch(t.id) {
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
		case EXITSTMT_TOKEN:
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
	switch(t.id) {
		case ID_TOKEN:
			attrstmt();
			break;
		case '(':
			subprogcall();
			break;
		default:
			std::cout << "default\n"; // no error
      break;
	}
}

//SUBPROGCALL -> '(' EXPRLIST ')'
void subprogcall() {
	switch(t.id){
		case '(':
			eat('(');
			exprlist();
			eat(')');
			break;
		default:
			std::cout << "error\n";
			break;
	}
}

//EXISTSTMT -> 'exitwhen' '(' EXPR ')'
void exitstmt() {
	switch (t.id) {
		case EXITWHEN_TOKEN:
			eat(EXITWHEN_TOKEN);
			eat('(');
			expr();
			eat(')');
			break;
		default:
			std::cout << "error\n";
			break;
	}
}

//RETURNSTMT -> 'return' EXPR
void returnstmt() {
	switch (t.id) {
		case RETURN_TOKEN:
			eat(RETURN_TOKEN);
			expr();
			break;
		default:
			std::cout << "error\n";
			break;
	}
}

//ATTRSTMT -> 'id' ATTRSTMTPRIME
void attrstmt() {
	switch (t.id) {
		case ID_TOKEN:
			eat(ID_TOKEN);
			attrstmtprime();
			break;
		default:
			std::cout << "error\n";
			break;
	}
}

//ATTRSTMTPRIME -> VARIABLE ':=' EXPR
//ATTRSTMTPRIME -> ':=' EXPR
void attrstmtprime() {
	switch (t.id) {
		case '[':
		case '->':
			variable();
			eat(ATTR_TOKEN);
			expr();
			break;
		case ATTR_TOKEN:
			eat(ATTR_TOKEN);
			expr();
			break;
		default:
			std::cout << "error\n";
			break;
	}
}

// IFBLOCK -> 'if' '(' EXPR ')' STMT ELSEBLOCK
void ifblock() {
	switch(t.id){
		case IF_TOKEN:
			eat(IF_TOKEN);
			eat('(');
			expr();
			eat(')');
			stmt();
			elseblock();
			break;
		default:
			std::cout << "error\n";
			break;

	}
}

//ELSEBLOCK -> LAMBDA
//ELSEBLOCK -> 'else' STMT
void elseblock() {
	switch(t.id){
		case ';':
		case END_TOKEN:
			break;
		case ELSE_TOKEN:
			eat(ELSE_TOKEN);
			stmt();
		default:
			std::cout << "error\n";
			break;
	}
}

//LOOPBLOCK -> 'loop' STMT
void loopblock() {
	switch(t.id){
		case LOOP_TOKEN:
			eat(LOOP_TOKEN);
			stmt();
			break;
		default:
			std::cout << "error\n";
			break;
	}
}

//CASEBLOCK -> 'case' EXPR 'of' CASELIST CASEBLOCKPRIME
void caseblock() {
	switch(t.id){
		case CASE_TOKEN:
			eat(CASE_TOKEN);
			expr();
			eat(OF_TOKEN);
			caselist();
			caseblockprime();
			break;
		default:
			std::cout << "error\n";
			break;
	}
}

//CASEBLOCKPRIME -> 'end'
//CASEBLOCKPRIME -> 'else' STMT 'end'
void caseblockprime() {
	switch(t.id){
		case END_TOKEN:
			eat(END_TOKEN);
			break;
		case ELSE_TOKEN:
			eat(ELSE_TOKEN);
			stmt();
			eat(END_TOKEN);
			break;
		default:
			std::cout << "error\n";
			break;
	}
}

//CASELIST -> LITERALLIST ':' STMT ';'
void caselist() {
	switch(t.id){
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
			std::cout << "error\n";
			break;
	}
}

//LITERALLIST -> LITERAL LITERALLISTPRIME
void literallist() {
	switch (t.id) {
		case INTLITERAL_TOKEN:
		case REALLITERAL_TOKEN:
		case CHARLITERAL_TOKEN:
		case STRINGLITERAL_TOKEN:
		case SUBRANGE_TOKEN:
		 	listerallistprime();
			break;
		default:
			std::cout << "error\n";
			break;
	}
}

//LISTERALLISTPRIME -> LAMBDA
//LISTERALLISTPRIME -> ',' LITERALLIST
void listerallistprime() {
	switch (t.id) {
		case ',':
			eat(',');
			literallist();
			break;
		default:
			std::cout << "error\n";
			break;
	}
}

//GOTOSTMT -> 'goto' 'label'
void gotostmt() {
	switch (t.id) {
		case GOTO_TOKEN:
			eat(GOTO_TOKEN);
			eat(LABEL_TOKEN);
			break;
		default:
			std::cout << "error\n";
			break;
	}
}

bool forblock() {
	return true;
}

bool forblockprime() {
	return true;
}

void expr() {
	switch(t.id) {
		case ID_TOKEN 			  	:
		case '('	  			   	:
		case '!'	  			   	:
		case CHARLITERAL_TOKEN 	   	:   
		case INTLITERAL_TOKEN  	   	:
		case REALLITERAL_TOKEN	   	:
		case STRINGLITERAL_TOKEN   	:
		case SUBRANGELITERAL_TOKEN 	: conj(); disj(); break;
		default		  			   	: std::cout << "ERROR" << std::endl;
	}
}

void disj() {
	switch(t.id) {
		case ';' 		:
		case ']' 		:
		case OF_TOKEN 	:
		case ','		:
		case ')' 		:
		case END_TOKEN 	:
		case ELSE_TOKEN	:
		case TO_TOKEN	:
		case STEP_TOKEN	:
		case DO_TOKEN	: break(); // LAMBDA
		case OR_TOKEN	: eat(OR_TOKEN); break;
		default		  	: std::cout << "ERROR" << std::endl;
	}
}

void final_term() {
	switch(t.id) {
		case ID_TOKEN 			   	: eat(ID_TOKEN); final_termprime(); break;
		case INTLITERAL_TOKEN  	   	:
		case REALLITERAL_TOKEN	   	:
		case CHARLITERAL_TOKEN 	   	:  
		case STRINGLITERAL_TOKEN  	:
		case SUBRANGELITERAL_TOKEN 	: literal(); break();
		case '(' 			   	   	: eat('('); expr(); eat(')'); break;
		default		  		   	   	: std::cout << "ERROR" << std::endl;
	}
}

void final_termprime() {
	switch(t.id) {
		case '[' 		  	: 
		case  GE_TOKEN 		: variable(); break();
		case ';' 			:
		case ']' 			:
		case OF_TOKEN 		:
		case ',' 			:
		case ')' 			:
		case END_TOKEN 		:
		case ELSE_TOKEN 	:
		case TO_TOKEN 		:
		case STEP_TOKEN 	:
		case DO_TOKEN 		:
		case OR_TOKEN 		:
		case '+' 			:
		case '-' 			:
		case '*' 			:
		case '/' 			:
		case '%' 			:
		case EQUAL_TOKEN 	:		
		case DIFF_TOKEN 	:
		case '>' 			:
		case LE_TOKEN 		:
		case '>' 			:
		case GE_TOKEN 		:
		case AND_TOKEN 		: break();
		case '('			: subprogcall(); break;
		default		  		: std::cout << "ERROR" << std::endl;
	}
}

/** --------- GODEIRO --------- **/
void add_op() {
	switch(t.id) {
		case '+' : eat('+'); break;
		case '-' : eat('-'); break;
		default  : std::cout << "ERROR" << std::endl;
	}
}

void mul_op() {
	switch(t.id) {
		case '*' : eat('*'); break;
		case '/' : eat('/'); break;
		case '%' : eat('%'); break;
		default  : std::cout << "ERROR" << std::endl;
	}
}

void equality_op() {
	switch(t.id) {
		case EQUAL_TOKEN : eat(EQUAL_TOKEN); break;
		case DIFF_TOKEN  : eat(DIFF_TOKEN); break;
		default		  	 : std::cout << "ERROR" << std::endl;
	}
}

void relational_op() {
	switch(t.id) {
		case '<' 	  : eat('<'); break;
		case LE_TOKEN : eat(LE_TOKEN); break;
		case '>' 	  : eat('>'); break;
		case GE_TOKEN : eat(GE_TOKEN); break;
		default		  : std::cout << "ERROR" << std::endl;
	}
}

void conj() {
	switch(t.id) {
		case '&'	  : eat('&'); comp(); conjprime(); break;
		default		  : std::cout << "ERROR" << std::endl;
	}
}

void conjprime() {
	switch(t.id) {
		case LAMBDA_TOKEN : break;
		default	  		  : equality_op(); relational(); break;
	}
}

void comp() {
	relational(); compprime();
}

void compprime() {
	switch(t.id) {
		case LAMBDA_TOKEN : break;
		default		  	  : equality_op(); relational();
	}
}
void relational() {
	sum(); relationalprime();
}

void relationalprime() {
	switch(t.id) {
		case LAMBDA_TOKEN : break;
		default 	      : relational_op(); sum(); 
	}
}
void sum() {
	neg(); sumprime();
}

void sumprime() {
	switch(t.id) {
		case LAMBDA_TOKEN : break;
		default		  	  : add_op(); neg(); sumprime();
	}
}

/** --------- GODEIRO --------- **/

void neg() {
	switch (t.id) {
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
            std::cout << "error\n";
            break;
	}
}

void mul() {
	
}

bool literal() {
	return true;
}

bool exprlist() {
	return true;
}

bool exprlist_plus() {
	return true;
}

bool exprlist_plusprime() {
	return true;
}

bool subprograms() {
	return true;
}

bool subprogramsprime() {
	return true;
}

bool procedure() {
	return true;
}

bool function() {
	return true;
}

bool param() {
	return true;
}

bool writestmt() {
	return true;
}

bool writelnstmt() {
	return true;
}

bool readstmt() {
	return true;
}

bool readlnstmt() {
	return true;
}
