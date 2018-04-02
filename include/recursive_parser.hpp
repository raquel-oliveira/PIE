#ifndef _RECURSIVE_PARSER_HPP_
#define _RECURSIVE_PARSER_HPP_
#include "../lex.yy.c"

extern void nextToken();
extern void initLexer(char* arg);

void eat(int expected);
void PROG();
void DECL();
void BLOCK();

#endif