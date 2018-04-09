#ifndef _TABLE_H_
#define _TABLE_H_

#include "tokens.h"
#include <map>
#include <vector>
#include <utility>
#include <iostream>

enum NonTerminals {
    PROGRAM = 500,
    DECL,
    CONSTS,
    LISTCONST,
    LISTCONSTPRIME,
    CONSTDECL,
    TYPES,
    TYPESPRIME,
    PRIMTYPES,
    PRIMTYPESPRIME,
    ARRAYTYPE,
    SUBRANGELIST,
    SUBRANGELISTPRIME,
    SUBRANGETYPE,
    SETTYPE,
    ENUMTYPE,
    RECORDTYPE,
    USERTYPES,
    LISTUSERTYPES,
    LISTUSERTYPESPRIME,
    USERTYPE,
    VARS,
    VARLISTLIST,
    VARLISTLISTPRIME,
    VARLIST,
    IDLIST,
    IDLISTPRIME,
    IDATTR,
    VARIABLE,
    VARIABLEPRIME,
    BLOCK,
    STMTS,
    STMTLISTPRIME,
    STMT,
    STMTPRIME,
    SUBPROGCALL,
    EXISTSTMT,
    RETURNSTMT,
    ATTRSTMT,
    ATTRSTMTPRIME,
    IFBLOCK,
    ELSEBLOCK,
    LOOPBLOCK,
    CASEBLOCK,
    CASEBLOCKPRIME,
    CASELIST,
    LITERALLIST,
    LISTERALLISTPRIME,
    GOTOSTMT,
    FORBLOCK,
    FORBLOCKPRIME,
    EXPR,
    DISJ,
    FINAL_TERM,
    FINAL_TERMPRIME,
    ADD_OP,
    MUL_OP,
    EQUALITY_OP,
    RELATIONAL_OP,
    CONJ,
    CONJPRIME,
    COMP,
    COMPPRIME,
    RELATIONAL,
    RELATIONALPRIME,
    SUM,
    SUMPRIME,
    NEG,
    MUL,
    MULPRIME,
    LITERAL,
    EXPRLIST,
    EXPRLISTPLUS,
    EXPRLISTPLUSPRIME,
    SUBPROGRAMS,
    SUBPROGRAMSPRIME,
    PROCEDURE,
    FUNCTION,
    PARAM,
    WRITESTMT,
    WRITELNSTMT,
    READSTMT,
    READLNSTMT
 };

std::map<std::pair<int, int>, std::vector<int>> table;


void initTable() {
    //PROGRAM
    table[{PROGRAM,PROGRAM_TOKEN}] = {'.', BLOCK, ';', ID_TOKEN, PROGRAM_TOKEN};       
    // DECL
    // CONSTS
    // LISTCONST
    // LISTCONSTPRIME
    // CONSTDECL
    // TYPES
    // TYPESPRIME
    // PRIMTYPES
    // PRIMTYPESPRIME
    // ARRAYTYPE
    // SUBRANGELIST
    // SUBRANGELISTPRIME
    // SUBRANGETYPE
    // SETTYPE
    // ENUMTYPE
    // RECORDTYPE
    // USERTYPES
    // LISTUSERTYPES
    // LISTUSERTYPESPRIME
    // USERTYPE
    // VARS
    // VARLISTLIST
    // VARLISTLISTPRIME
    // VARLIST
    // IDLIST
    // IDLISTPRIME
    // IDATTR
    // VARIABLE
    // VARIABLEPRIME
    // BLOCK
    // STMTS
    // STMTLISTPRIME
    // STMT
    // STMTPRIME
    // SUBPROGCALL
    // EXISTSTMT
    // RETURNSTMT
    // ATTRSTMT
    // ATTRSTMTPRIME
    // IFBLOCK
    // ELSEBLOCK
    // LOOPBLOCK
    // CASEBLOCK
    // CASEBLOCKPRIME
    // CASELIST
    // LITERALLIST
    // LISTERALLISTPRIME
    // GOTOSTMT
    // FORBLOCK
    // FORBLOCKPRIME
    // EXPR
    // DISJ
    // FINAL_TERM
    // FINAL_TERMPRIME
    // ADD_OP
    // MUL_OP
    // EQUALITY_OP
    // RELATIONAL_OP
    // CONJ
    // CONJPRIME
    // COMP
    // COMPPRIME
    // RELATIONAL
    // RELATIONALPRIME
    // SUM
    // SUMPRIME
    // NEG
    // MUL
    // MULPRIME
    // LITERAL
    // EXPRLIST
    // EXPRLISTPLUS
    // EXPRLISTPLUSPRIME
    // SUBPROGRAMS
    // SUBPROGRAMSPRIME
    // PROCEDURE
    // FUNCTION
    // PARAM
    // WRITESTMT
    // WRITELNSTMT
    // READSTMT
    // READLNSTMT
}

#endif