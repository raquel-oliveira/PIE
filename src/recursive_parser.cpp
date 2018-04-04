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

bool listusertypes() {
	return true;
}

bool listusertypesprime() {
	return true;
}

bool usertype() {
	return true;
}

bool vars() {
	return true;
}

bool varlistlist() {
	return true;
}

bool varlistlistprime() {
	return true;
}

bool varlist() {
	return true;
}

bool idlist() {
	return true;
}

bool idlistprime() {
	return true;
}

bool idattr() {
	return true;
}

bool variable() {
	return true;
}

bool variableprime() {
	return true;
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