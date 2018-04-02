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
	if(t.token != ENDOFFILE_TOKEN && t.token != ERROR_TOKEN) {
		PROG();
	}
	if(t.token == ERROR_TOKEN) {
		std::cout << "Non recognized symbol '" << t.lexeme << "' in line " << t.row << " column " << t.col << std::endl;
	}
	return 0;
}

void eat(int expected) {
	if(t.token == expected) {
		nextToken();
	}
	else {
		std::cout << "Error" << std::endl;
	}
}

void PROG() {
	switch(t.token) {
		case PROGRAM_TOKEN: eat(PROGRAM_TOKEN);
							eat(ID_TOKEN);
							eat(';');
							DECL();
							BLOCK();
							eat('.');
							break;
	}
}

void DECL() {

}

void BLOCK() {

}