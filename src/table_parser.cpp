#include "../include/table_parser.hpp"

int main(int argc, char *argv[]) {
	if(argc < 2) {
		std::cout << "Not enough arguments." << argc << std::endl;
		return 0;
	}
	init_lexer(argv[1]);
	next_token();
	init_table();
	std::stack<int> stack;
	if(token.id != ENDOFFILE_TOKEN && token.id != ERROR_TOKEN) {
		stack.push(PROGRAM);
		table_parser(stack);
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
	if(token.id != ENDOFFILE_TOKEN) {
		next_token();
	}
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

void error_recovery(std::stack<int>& stack) {
	while(!stack.empty() && stack.top() != ';') {
		stack.pop();
	}
	if(!stack.empty()) {
		stack.pop();
	}
	while(token.id != ';') {
		next_token();
	} 
}

void push_rule(std::vector<int>& rule, std::stack<int>& stack) {
	for(int i = rule.size()-1; i >= 0; i--) {
		stack.push(rule[i]);
	}
}

void table_parser(std::stack<int>& stack) {
	while(!stack.empty()) {
		int top = stack.top();
		if(top < PROGRAM) { //if top of stack is a terminal symbol
			eat(top);
			stack.pop();
		}
		else {
			if(table.find({top, token.id}) == table.end()) { 
				error();
				error_recovery(stack);
			}
			else {
				stack.pop();
				push_rule(table[{top, token.id}], stack);
			}
		}
	}

}
