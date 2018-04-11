#ifndef _TABLE_PARSER_HPP_
#define _TABLE_PARSER_HPP_

#include <iostream>
#include <fstream>
#include <string>
#include <stack>
#include "table.h"
#include "tokens.h"

void eat(int expected);
void error();
void error_recovery(std::stack<int>& stack);
void push_rule(int rule[], int size, std::stack<int>& stack);
void table_parser(std::stack<int>& stack);

#endif /* _TABLE_PARSER_HPP_ */