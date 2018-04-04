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
	if(t.token != ENDOFFILE_TOKEN && t.token != ERROR_TOKEN) {
		prog();
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

void subprogcall() {
	switch(t.id){
		case '(':
			eat('(');
			exprlist();
			eat(')');
		default:
			std::cout << "error\n";
			break;
	}
}

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
