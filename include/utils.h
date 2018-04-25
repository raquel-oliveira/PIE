#ifndef __UTILS_H__
#define __UTILS_H__

/**
* Struct to save the line of tokens
*/
typedef struct YYLTYPE {
    int first_line;
    int first_column;
    int last_line;
    int last_column;
} YYLTYPE;


#endif