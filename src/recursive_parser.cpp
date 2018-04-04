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
	std::cout << t.id << " " << expected << std::endl;
	if(t.id == expected) {
		nextToken();
	}
	else {
		std::cout << "Error" << std::endl;
	}
}

bool prog() {
	switch(t.id) {
		case PROGRAM_TOKEN: eat(PROGRAM_TOKEN);
							eat(ID_TOKEN);
							eat(';');
							decl();
							block();
							eat('.');
							break;
	}
	return true;
}

bool decl() {
	switch(t.id) {
		case CONST_TOKEN: consts();
		case USERTYPE_TOKEN: usertypes();
		case VAR_TOKEN: vars();
		case SUBPROGRAM_TOKEN: subprograms();
		break;
	}
	return true;
}

void consts() {
	switch(t.id) {
		case CONST_TOKEN: eat(CONST_TOKEN);
						  listconst();
						  break;
		case VAR_TOKEN: break;
		case PROC_TOKEN: break;
		case FUNC_TOKEN: break;
		case TYPE_TOKEN: break;
		case BEGIN_TOKEN: break;
	}
}

void listconst() {
	switch(t.id) {
		case ID_TOKEN: constdecl();
					   listconstprime();
					   break;
	}
}

void listconstprime() {
	switch(t.id) {
		case ID_TOKEN: listconstprime();
					   break;
		case VAR_TOKEN: break;
		case PROC_TOKEN: break;
		case FUNC_TOKEN: break;
		case TYPE_TOKEN: break;
		case BEGIN_TOKEN: break;
	}
}

void constdecl() {
	switch(t.id) {
		case ID_TOKEN: eat(ID_TOKEN);
					   eat('=');
					   expr();
					   eat(';');
					   break;
	}
}

void types() {
	switch(t.id) {
		case ID_TOKEN: eat(ID_TOKEN);
					   typesprime();
					   break;
		case INT_TOKEN: primtypes();
		case REAL_TOKEN: primtypes();
		case BOOL_TOKEN: primtypes();
		case CHAR_TOKEN: primtypes();
		case STRING_TOKEN: primtypes();
		case ARRAY_TOKEN: primtypes();
		case RECORD_TOKEN: primtypes();
		case SET_TOKEN: primtypes();
		case ENUM_TOKEN: primtypes();
		break;
	}
}

void typesprime() {
	switch(t.id) {
		case RANGE_TOKEN: eat(RANGE_TOKEN);
						  subrangetype();
						  break;
		case ID_TOKEN: break;
		case ';': break;
	}
}

void primtypes() {
	switch(t.id) {
		case INT_TOKEN: eat(INT_TOKEN);
						primtypesprime();
						break;
		case REAL_TOKEN: eat(REAL_TOKEN);
						 break;
		case BOOL_TOKEN: eat(BOOL_TOKEN);
						 break;
		case CHAR_TOKEN: eat(CHAR_TOKEN);
						 primtypesprime();
		case STRING_TOKEN: eat(STRING_TOKEN);
						   break;
		case ARRAY_TOKEN: arraytype();
						  break;
		case RECORD_TOKEN: recordtype();
						   break;
		case SET_TOKEN: settype();
						break;
		case ENUM_TOKEN: enumtype();
						 break;
	}
}

void primtypesprime() {
	switch(t.id) {
		case RANGE_TOKEN: eat(RANGE_TOKEN);
						  subrangetype();
						  break;
		case ID_TOKEN: break;
		case ';': break;
	}
}

void arraytype() {
	switch(t.id) {
		case ARRAY_TOKEN: eat(ARRAY_TOKEN);
						  eat('[');
						  subrangelist();
						  eat(']');
						  eat(OF_TOKEN);
						  types();
						  break;
	}
}

void subrangelist() {
	switch(t.id) {
		case ID_TOKEN: eat(ID_TOKEN);
					   eat(RANGE_TOKEN);
					   subrangetype();
					   subrangelistprime();
					   break;
		case INT_TOKEN: eat(INT_TOKEN);
					    eat(RANGE_TOKEN);
					    subrangetype();
					    subrangelistprime();
						break;
		case CHAR_TOKEN: eat(CHAR_TOKEN);
					     eat(RANGE_TOKEN);
					     subrangetype();
					     subrangelistprime();
					     break;
	}
}

void subrangelistprime() {
	switch(t.id) {
		case ',': eat(',');
		          subrangelist();
		case ']': break;
	}
}

void subrangetype() {
	switch(t.id) {
		case ID_TOKEN: eat(ID_TOKEN);
					   break;
		case INT_TOKEN: eat(INT_TOKEN);
						break;
		case CHAR_TOKEN: eat(CHAR_TOKEN);
					     break;
	}
}

void settype() {
	switch(t.id) {
		case SET_TOKEN: eat(SET_TOKEN);
						eat(OF_TOKEN);
						types();
	}
}

void enumtype() {
	switch(t.id) {
		case '(': eat('(');
				  idlist();
				  eat(')');
	}
}

void recordtype() {
	switch(t.id) {
		case RECORD_TOKEN: eat(RECORD_TOKEN);
						   varlistlist();
						   eat(END_TOKEN);
	}
}

void usertypes() {
	switch(t.id) {
		case TYPE_TOKEN: eat(TYPE_TOKEN);
						 listusertypes();
		case VAR_TOKEN: break;
		case PROC_TOKEN: break;
		case FUNC_TOKEN: break;
		case BEGIN_TOKEN: break;
	}
}

void listusertypes() {
	switch(t.id) {
		case ID_TOKEN: 
			usertype();
			listusertypesprime();
			break;
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
	}
}

void varlistlist() {
	switch(t.id) {
		case ID_TOKEN: 
			varlist();
			varlistlistprime();
			break;
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
	}
}

void idlist() {
	switch(t.id) {
		case ID_TOKEN: 
			eat(ID_TOKEN);
			idattr();
			idlistprime();
			break;
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
	}
}

bool block() {
	return true;
}

bool stmts() {
	return true;
}

bool stmtsprime() {
	return true;
}

bool stmt() {
	return true;
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

bool caselist() {
	return true;
}

bool literallist() {
	return true;
}

bool listerallistprime() {
	return true;
}

bool gotostmt() {
	return true;
}

bool forblock() {
	return true;
}

bool forblockprime() {
	return true;
}

void expr() {
	switch(t.id) {
		case OR_TOKEN : disj(); break;
		case '&'	  : conj(); break;
		default		  : std::cout << "ERROR" << std::endl;
	}
}

void disj() {
	switch(t.id) {
		case OR_TOKEN	  : eat(OR_TOKEN); conj(); break;
		case LAMBDA_TOKEN : break;
		default		  	  : std::cout << "ERROR" << std::endl;
	}
}

void final_term() {
	switch(t.id) {
		case OR_TOKEN : disj(); break;

		case CHARLITERAL_TOKEN : literal(); break;
		case CHARLITERAL_TOKEN : literal(); break;
		case CHARLITERAL_TOKEN : literal(); break;
		case CHARLITERAL_TOKEN : literal(); break;
		case '(' 			   : eat('(');exprt();eat(')'); break;
		default		  		   : std::cout << "ERROR" << std::endl;
	}
}

void final_termprime() {
	switch(t.id) {
		case VAR_TOKEN 		  : variable(); break;
		case LAMBDA_TOKEN	  : break;
		case '('			  : subprogcall(); break;
		default		  		  : std::cout << "ERROR" << std::endl;
	}
}

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
