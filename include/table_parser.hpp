#ifndef _TABLE_PARSER_H_
#define _TABLE_PARSER_H_

#include <iostream>
#include <fstream>
#include <string>
#include <stack>
#include "tokens.h"
#include "table.h"

int main(int argc, char *argv[]);
void eat(int expected);
void error();
void error_recovery(std::stack<int>& stack);
void push_rule(int rule[], int size, std::stack<int>& stack);
void table_parser(std::stack<int>& stack);


#endif