#include "../include/table_parser.hpp"

int main(int argc, char *argv[]) {
	if(argc < 2) {
		std::cout << "Not enough arguments." << argc << std::endl;
		return 0;
	}
	initLexer(argv[1]);
	next_token();
	init_table();
	std::stack<int> stack;
	if(t.id != ENDOFFILE_TOKEN && t.id != ERROR_TOKEN) {
		stack.push(PROG);
		table_parser(stack);
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
		next_token();
	}
}

void error() {
	std::cout << "ERROR: Not expected symbol in line " << t.row << " column " << t.col << std::endl;
	next_token();
}

void error_recovery(std::stack<int>& stack) {
	while(!stack.empty() && stack.top() != ';') {
		stack.pop();
	}
	if(!stack.empty()) {
		stack.pop();
	}
	while(t.id != ';') {
		next_token();
	} 
}

void push_rule(int rule[], int size, std::stack<int>& stack) {
	for(int i = size-1; i >= 0; i--) {
		stack.push(rule[i]);
	}
}

void table_parser(std::stack<int>& stack) {
	while(!stack.empty()) {
		int top = stack.top();
		if(top < PROG) { //if top of stack is a terminal symbol
			eat(top);
			stack.pop();
		}
		else {
			if(table.find({top, t.id}) == table.end()) { 
				error();
				error_recovery(stack);
			}
			else {
				push_rule(table[{top, t.id}], sizeof(table[{top, t.id}]) / sizeof(int), stack);
				stack.pop();
			}
		}
	}

}
