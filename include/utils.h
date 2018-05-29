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

struct Ids_info {
	bool ref;
	std::string type;
};

struct ArrayAttrs {
	std::string type;
	int pos;
	int init_idx;
};

struct RangeAttrs {
	int init_idx;
	int end_inx;
};

struct ST {
	std::map<std::string, std::string> st; //key = id and value = type
	std::vector<std::map<std::string,std::string>> struct_STs;
	std::map<std::string,int> struct_ST_idx;
	std::vector<ArrayAttrs> array_STs;
	std::map<std::string,int> array_ST_idx;
	std::vector<RangeAttrs> range_STs;
	std::map<std::string,int> range_ST_idx;
};


struct Attributes {
	std::string cs = ""; //code
	std::string type;
	std::vector<std::string> ids; //ids of idlist
	Ids_info ids_info; //ids info
	std::string afterlabel;
	ST st; //symbol table
  	std::string id_token;
};

#endif
