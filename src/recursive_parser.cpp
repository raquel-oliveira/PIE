#include <iostream>
#include <fstream>
#include <string>
#include "../include/tokens.h"
#include "../include/recursive_parser.hpp"

int main(int argc, char *argv[]) {
	if(argc < 2) {
		std::cout << "Not enough arguments." << std::endl;
		return 0;
	}
	initLexer(argv[1]);
	nextToken();
	if(t.id != ENDOFFILE_TOKEN && t.id != ERROR_TOKEN) {
		PROG();
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
	switch(t.token) {
		case CONSTS_TOKEN: consts();
		case USERTYPES_TOKEN: usertypes();
		case VARS_TOKEN: vars();
		case SUBPROGRAMS_TOKEN: subprograms();
		break;
	}
	return true;
}

bool consts() {
	return true;
}

bool listconst() {
	return true;
}

bool listconstprime() {
	return true;
}

bool constdecl() {
	return true;
}

bool types() {
	return true;
}

bool primtypes() {
	return true;
}

bool primtypesprime() {
	return true;
}

bool arraytype() {
	return true;
}

bool subrangelist() {
	return true;
}

bool subrangelistprime() {
	return true;
}

bool subrangetype() {
	return true;
}

bool settype() {
	return true;
}

bool enumtype() {
	return true;
}

bool recordtype() {
	return true;
}

bool usertypes() {
	return true;
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

bool stmtprime() {
	return true;
}

bool subprogcall() {
	return true;
}

bool existstmt() {
	return true;
}

bool returnstmt() {
	return true;
}

bool attrstmt() {
	return true;
}

bool attrstmtprime() {
	return true;
}

bool ifblock() {
	return true;
}

bool elseblock() {
	return true;
}

bool loopblock() {
	return true;
}

bool caseblock() {
	return true;
}

bool caseblockprime() {
	return true;
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

bool expr() {
	return true;
}

bool disj() {
	return true;
}

bool final_term() {
	return true;
}

bool final_termprime() {
	return true;
}

bool add_op() {
	return true;
}

bool mul_op() {
	return true;
}

bool equality_op() {
	return true;
}

bool relational_op() {
	return true;
}

bool conj() {
	return true;
}

bool conjprime() {
	return true;
}

bool comp() {
	return true;
}

bool compprime() {
	return true;
}

bool relational() {
	return true;
}

bool relationalprime() {
	return true;
}

bool sum() {
	return true;
}

bool sumprime() {
	return true;
}

bool neg() {
	return true;
}

bool mul() {
	return true;
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