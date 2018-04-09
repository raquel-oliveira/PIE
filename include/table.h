#ifndef _TABLE_H_
#define _TABLE_H_

#include <unordered_map>
#include <utility>

enum NonTerminals {
    PROG = 500,
    DECL,
    CONSTS,
    LISTCONST
 };

std::unordered_map<std::pair<int, int>, int[]> table;


void initTable() {
	table[{PROG,PROGRAM_TOKEN}] = {'.', BLOCK, ';', ID_TOKEN, PROGRAM_TOKEN};
}

#endif