#ifndef __UTILS_H__
#define __UTILS_H__

#include <map>
#include <vector>
#include <string>
/**
* Struct to save the line of tokens
*/
typedef struct YYLTYPE {
    int first_line;
    int first_column;
    int last_line;
    int last_column;
} YYLTYPE;

struct Id_list {
	bool ref;
	std::string type;
};


struct Attributes {
	std::string cs = ""; //code
	std::map<std::string, std::string> sti; //inherited symbol table, key = id and value = type
	std::map<std::string, std::string> sts; //synthesized symbol table, key = id and value = type
	std::string type;
	std::vector<int> init_idx; //initial indexes of array
	std::vector<std::string> ids; //ids of idlist
	Id_list idlh; //ids herdados
	std::string afterlabel;
  std::string id_token;
};

#endif
