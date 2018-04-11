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
    USERTYPES,
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
    table[{PROGRAM, PROGRAM_TOKEN}] = {PROGRAM_TOKEN, ID_TOKEN, ';', BLOCK, '.'};
    // DECL
    table[{DECL, CONST_TOKEN}] = {CONSTS, USERTYPES, VARS, SUBPROGRAMS};
    table[{DECL, TYPE_TOKEN}] = {USERTYPES, VARS, SUBPROGRAMS};
    table[{DECL, VAR_TOKEN}] = {VARS, SUBPROGRAMS};
    table[{DECL, FUNC_TOKEN}] = {SUBPROGRAMS};
    table[{DECL, PROC_TOKEN}] = {SUBPROGRAMS};
    // CONSTS
    table[{CONSTS, CONST_TOKEN}] = {CONST_TOKEN, LISTCONST};
    table[{CONSTS, VAR_TOKEN}] = {};
    table[{CONSTS, PROC_TOKEN}] = {};
    table[{CONSTS, FUNC_TOKEN}] = {};
    table[{CONSTS, TYPE_TOKEN}] = {};
    table[{CONSTS, BEGIN_TOKEN}] = {};
    // LISTCONST
    table[{LISTCONST, ID_TOKEN}] = {CONSTDECL, LISTCONSTPRIME};
    // LISTCONSTPRIME
    table[{LISTCONSTPRIME, ID_TOKEN}] = {LISTCONSTPRIME};
    table[{LISTCONSTPRIME, VAR_TOKEN}] = {};
    table[{LISTCONSTPRIME, PROC_TOKEN}] = {};
    table[{LISTCONSTPRIME, FUNC_TOKEN}] = {};
    table[{LISTCONSTPRIME, TYPE_TOKEN}] = {};
    table[{LISTCONSTPRIME, BEGIN_TOKEN}] = {};
    // CONSTDECL
    table[{CONSTDECL, ID_TOKEN}] = {ID_TOKEN, '=', EXPR, ';'};
    // TYPES
    table[{TYPES, ID_TOKEN}] = {ID_TOKEN, TYPESPRIME};
    table[{TYPES, INT_TOKEN}] = {};
    table[{TYPES, REAL_TOKEN}] = {};
    table[{TYPES, BOOL_TOKEN}] = {};
    table[{TYPES, CHAR_TOKEN}] = {};
    table[{TYPES, STRING_TOKEN}] = {};
    table[{TYPES, ARRAY_TOKEN}] = {};
    table[{TYPES, RECORD_TOKEN}] = {};
    table[{TYPES, SET_TOKEN}] = {};
    table[{TYPES, ENUM_TOKEN}] = {};
    // TYPESPRIME
    table[{TYPESPRIME, RANGE_TOKEN}] = {RANGE_TOKEN, SUBRANGETYPE};
    table[{TYPESPRIME, ID_TOKEN}] = {};
    table[{TYPESPRIME, ';'}] = {};
    // PRIMTYPES
    table[{PRIMTYPES, INT_TOKEN}] = {INT_TOKEN, PRIMTYPESPRIME};
    table[{PRIMTYPES, REAL_TOKEN}] = {REAL_TOKEN};
    table[{PRIMTYPES, BOOL_TOKEN}] = {BOOL_TOKEN};
    table[{PRIMTYPES, CHAR_TOKEN}] = {CHAR_TOKEN, PRIMTYPESPRIME};
    table[{PRIMTYPES, STRING_TOKEN}] = {STRING_TOKEN};
    table[{PRIMTYPES, ARRAY_TOKEN}] = {ARRAYTYPE};
    table[{PRIMTYPES, RECORD_TOKEN}] = {RECORDTYPE};
    table[{PRIMTYPES, SET_TOKEN}] = {SETTYPE};
    table[{PRIMTYPES, ENUM_TOKEN}] = {ENUMTYPE};
    // PRIMTYPESPRIME
    table[{PRIMTYPESPRIME, RANGE_TOKEN}] = {RANGE_TOKEN, SUBRANGETYPE};
    table[{PRIMTYPESPRIME, ID_TOKEN}] = {};
    table[{PRIMTYPESPRIME, ';'}] = {};
    // ARRAYTYPE
    table[{ARRAYTYPE, ARRAY_TOKEN}] = {ARRAY_TOKEN, '[', SUBRANGELIST, ']', OF_TOKEN, TYPES};
    // SUBRANGELIST
    table[{SUBRANGELIST, ID_TOKEN}] = {ID_TOKEN, RANGE_TOKEN, SUBRANGETYPE, SUBRANGELISTPRIME};
    table[{SUBRANGELIST, INT_TOKEN}] = {INT_TOKEN, RANGE_TOKEN, SUBRANGETYPE, SUBRANGELISTPRIME};
    table[{SUBRANGELIST, CHAR_TOKEN}] = {CHAR_TOKEN, RANGE_TOKEN, SUBRANGETYPE, SUBRANGELISTPRIME};
    // SUBRANGELISTPRIME
    table[{SUBRANGELISTPRIME, ','}] = {',', SUBRANGELIST};
    table[{SUBRANGELISTPRIME, ']'}] = {};
    // SUBRANGETYPE
    table[{SUBRANGETYPE, ID_TOKEN}] = {ID_TOKEN};
    table[{SUBRANGETYPE, INT_TOKEN}] = {INT_TOKEN};
    table[{SUBRANGETYPE, CHAR_TOKEN}] = {CHAR_TOKEN};
    // SETTYPE
    table[{SETTYPE, SET_TOKEN}] = {SET_TOKEN, OF_TOKEN, TYPES};
    // ENUMTYPE
    table[{ENUMTYPE, '('}] = {'(', IDLIST, ')'};
    // RECORDTYPE
    table[{RECORDTYPE, RECORD_TOKEN}] = {RECORD_TOKEN, VARLISTLIST, END_TOKEN};
    // USERTYPES
    table[{USERTYPES, TYPE_TOKEN}] = {TYPE_TOKEN, LISTUSERTYPES};
    table[{USERTYPES, VAR_TOKEN}] = {};
    table[{USERTYPES, PROC_TOKEN}] = {};
    table[{USERTYPES, FUNC_TOKEN}] = {};
    table[{USERTYPES, BEGIN_TOKEN}] = {};
    // LISTUSERTYPES
    table[{LISTUSERTYPES, ID_TOKEN}] = {USERTYPE, LISTUSERTYPESPRIME};
    // LISTUSERTYPESPRIME
    table[{LISTUSERTYPESPRIME, ID_TOKEN}] = {LISTUSERTYPES};
    table[{LISTUSERTYPESPRIME, VAR_TOKEN}] = {};
    table[{LISTUSERTYPESPRIME, BEGIN_TOKEN}] = {};
    // USERTYPE
    table[{USERTYPE, ID_TOKEN}] = {ID_TOKEN, '=', TYPES, ';'};
    // VARS
    table[{VARS, VAR_TOKEN}] = {VAR_TOKEN, VARLISTLIST};
    table[{VARS, PROC_TOKEN}] = {};
    table[{VARS, FUNC_TOKEN}] = {};
    table[{VARS, BEGIN_TOKEN}] = {};
    // VARLISTLIST
    table[{VARLISTLIST, ID_TOKEN}] = {VARLIST, VARLISTLISTPRIME};
    // VARLISTLISTPRIME
    table[{VARLISTLISTPRIME, '('}] = {VARLISTLIST};
    table[{VARLISTLISTPRIME, ID_TOKEN}] = {VARLISTLIST};
    table[{VARLISTLISTPRIME, INT_TOKEN}] = {VARLISTLIST};
    table[{VARLISTLISTPRIME, REAL_TOKEN}] = {VARLISTLIST};
    table[{VARLISTLISTPRIME, BOOL_TOKEN}] = {VARLISTLIST};
    table[{VARLISTLISTPRIME, CHAR_TOKEN}] = {VARLISTLIST};
    table[{VARLISTLISTPRIME, STRING_TOKEN}] = {VARLISTLIST};
    table[{VARLISTLISTPRIME, ARRAY_TOKEN}] = {VARLISTLIST};
    table[{VARLISTLISTPRIME, SET_TOKEN}] = {VARLISTLIST};
    table[{VARLISTLISTPRIME, RECORD_TOKEN}] = {VARLISTLIST};
    table[{VARLISTLISTPRIME, ')'}] = {};
    table[{VARLISTLISTPRIME, END_TOKEN}] = {};
    table[{VARLISTLISTPRIME, BEGIN_TOKEN}] = {};
    table[{VARLISTLISTPRIME, PROC_TOKEN}] = {};
    table[{VARLISTLISTPRIME, FUNC_TOKEN}] = {};
    // VARLIST
    table[{VARLIST, '('}] = {TYPES, IDLIST, ';'};
    table[{VARLIST, ID_TOKEN}] = {TYPES, IDLIST, ';'};
    table[{VARLIST, INT_TOKEN}] = {TYPES, IDLIST, ';'};
    table[{VARLIST, REAL_TOKEN}] = {TYPES, IDLIST, ';'};
    table[{VARLIST, BOOL_TOKEN}] = {TYPES, IDLIST, ';'};
    table[{VARLIST, CHAR_TOKEN}] = {TYPES, IDLIST, ';'};
    table[{VARLIST, STRING_TOKEN}] = {TYPES, IDLIST, ';'};
    table[{VARLIST, ARRAY_TOKEN}] = {TYPES, IDLIST, ';'};
    table[{VARLIST, SET_TOKEN}] = {TYPES, IDLIST, ';'};
    table[{VARLIST, RECORD_TOKEN}] = {TYPES, IDLIST, ';'};
    // IDLIST
    table[{IDLIST, ID_TOKEN}] = {ID_TOKEN, IDATTR, IDLISTPRIME};
    // IDLISTPRIME
    table[{IDLISTPRIME, ','}] = {',', IDLIST};
    table[{IDLISTPRIME, ';'}] = {};
    table[{IDLISTPRIME, ')'}] = {};
    // IDATTR
    table[{IDATTR, '='}] = {'=', EXPR};
    table[{IDATTR, ';'}] = {};
    table[{IDATTR, '.'}] = {};
    table[{IDATTR, ')'}] = {};
    // VARIABLE
    table[{VARIABLE, '['}] = {'[', EXPRLISTPLUS, ']', VARIABLEPRIME};
    table[{VARIABLE, ACCESS_TOKEN}] = {ACCESS_TOKEN, ID_TOKEN, VARIABLEPRIME};
    // VARIABLEPRIME
    table[{VARIABLEPRIME, ACCESS_TOKEN}] = {VARIABLE};
    table[{VARIABLEPRIME, ';'}] = {};
    table[{VARIABLEPRIME, ']'}] = {};
    table[{VARIABLEPRIME, ','}] = {};
    table[{VARIABLEPRIME, ')'}] = {};
    table[{VARIABLEPRIME, '+'}] = {};
    table[{VARIABLEPRIME, '-'}] = {};
    table[{VARIABLEPRIME, '*'}] = {};
    table[{VARIABLEPRIME, '/'}] = {};
    table[{VARIABLEPRIME, '%'}] = {};
    table[{VARIABLEPRIME, '<'}] = {};
    table[{VARIABLEPRIME, '>'}] = {};
    table[{VARIABLEPRIME, OF_TOKEN}] = {};
    table[{VARIABLEPRIME, END_TOKEN}] = {};
    table[{VARIABLEPRIME, ATTR_TOKEN}] = {};
    table[{VARIABLEPRIME, ELSE_TOKEN}] = {};
    table[{VARIABLEPRIME, TO_TOKEN}] = {};
    table[{VARIABLEPRIME, STEP_TOKEN}] = {};
    table[{VARIABLEPRIME, DO_TOKEN}] = {};
    table[{VARIABLEPRIME, OR_TOKEN}] = {};
    table[{VARIABLEPRIME, EQUAL_TOKEN}] = {};
    table[{VARIABLEPRIME, DIFF_TOKEN}] = {};
    table[{VARIABLEPRIME, LE_TOKEN}] = {};
    table[{VARIABLEPRIME, GE_TOKEN}] = {};
    table[{VARIABLEPRIME, AND_TOKEN}] = {};
    // BLOCK
    table[{BLOCK, BEGIN_TOKEN}] = {BEGIN_TOKEN, STMTS, END_TOKEN};
    // STMTS
    table[{STMTS, ID_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, ';'}] = {STMT, STMTLISTPRIME};
    table[{STMTS, END_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, BEGIN_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, LABEL_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, EXITWHEN_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, RETURN_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, IF_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, LOOP_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, CASE_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, GOTO_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, FOR_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, WRITE_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, WRITELN_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, READ_TOKEN}] = {STMT, STMTLISTPRIME};
    table[{STMTS, READLN_TOKEN}] = {STMT, STMTLISTPRIME};
    // STMTLISTPRIME
    table[{STMTLISTPRIME, ';'}] = {';', STMTS};
    table[{STMTLISTPRIME, END_TOKEN}] = {};
    // STMT
    table[{STMT, LABEL_TOKEN}] = {LABEL_TOKEN, STMT};
    table[{STMT, BEGIN_TOKEN}] = {BLOCK};
    table[{STMT, WRITE_TOKEN}] = {WRITESTMT};
    table[{STMT, WRITELN_TOKEN}] = {WRITELNSTMT};
    table[{STMT, READ_TOKEN}] = {READSTMT};
    table[{STMT, READLN_TOKEN}] = {READLNSTMT};
    table[{STMT, LOOP_TOKEN}] = {LOOPBLOCK};
    table[{STMT, IF_TOKEN}] = {IFBLOCK};
    table[{STMT, FOR_TOKEN}] = {FORBLOCK};
    table[{STMT, CASE_TOKEN}] = {CASEBLOCK};
    table[{STMT, GOTO_TOKEN}] = {GOTOSTMT};
    table[{STMT, ID_TOKEN}] = {ID_TOKEN, STMTPRIME};
    table[{STMT, EXITWHEN_TOKEN}] = {EXISTSTMT};
    table[{STMT, RETURN_TOKEN}] = {READLNSTMT};
    table[{STMT, ';'}] = {};
    table[{STMT, END_TOKEN}] = {};
    table[{STMT, ELSE_TOKEN}] = {};
    // STMTPRIME
    table[{STMTPRIME, ID_TOKEN}] = {ATTRSTMT};
    table[{STMTPRIME, '('}] = {SUBPROGCALL};
    // SUBPROGCALL
    table[{SUBPROGCALL, '('}] = {'(', EXPRLIST, ')'};
    // EXISTSTMT
    table[{EXISTSTMT, EXITWHEN_TOKEN}] = {EXITWHEN_TOKEN, '(', EXPR, ')'};
    // RETURNSTMT
    table[{RETURNSTMT, RETURN_TOKEN}] = {RETURN_TOKEN, EXPR};
    // ATTRSTMT
    table[{ATTRSTMT, ID_TOKEN}] = {ID_TOKEN, ATTRSTMTPRIME};
    // ATTRSTMTPRIME
    table[{ATTRSTMTPRIME, '['}] = {VARIABLE, ATTR_TOKEN, EXPR};
    table[{ATTRSTMTPRIME, ACCESS_TOKEN}] = {VARIABLE, ATTR_TOKEN, EXPR};
    table[{ATTRSTMTPRIME, ATTR_TOKEN}] = {ATTR_TOKEN, EXPR};
    // IFBLOCK
    table[{IFBLOCK, IF_TOKEN}] = {IF_TOKEN, '(', EXPR, ')', STMT, ELSEBLOCK};
    // ELSEBLOCK
    table[{ELSEBLOCK, ';'}] = {};
    table[{ELSEBLOCK, END_TOKEN}] = {};
    table[{ELSEBLOCK, ELSE_TOKEN}] = {ELSE_TOKEN, STMT};
    // LOOPBLOCK
    table[{LOOPBLOCK, LOOP_TOKEN}] = {LOOP_TOKEN, STMT};
    // CASEBLOCK
    table[{CASEBLOCK, CASE_TOKEN}] = {CASE_TOKEN, EXPR, OF_TOKEN, CASELIST, CASEBLOCKPRIME};
    // CASEBLOCKPRIME
    table[{CASEBLOCKPRIME, END_TOKEN}] = {END_TOKEN};
    table[{CASEBLOCKPRIME, ELSE_TOKEN}] = {ELSE_TOKEN, STMT, END_TOKEN};
    // CASELIST
    table[{CASELIST, INT_TOKEN}] = {LITERALLIST, ':', STMT, ';'};
    table[{CASELIST, REAL_TOKEN}] = {LITERALLIST, ':', STMT, ';'};
    table[{CASELIST, CHAR_TOKEN}] = {LITERALLIST, ':', STMT, ';'};
    table[{CASELIST, STRING_TOKEN}] = {LITERALLIST, ':', STMT, ';'};
    table[{CASELIST, SUBRANGELITERAL_TOKEN}] = {LITERALLIST, ':', STMT, ';'};
    // LITERALLIST
    table[{LITERALLIST, INT_TOKEN}] = {LITERAL, LITERALLISTPRIME};
    table[{LITERALLIST, REAL_TOKEN}] = {LITERAL, LITERALLISTPRIME};
    table[{LITERALLIST, CHAR_TOKEN}] = {LITERAL, LITERALLISTPRIME};
    table[{LITERALLIST, STRING_TOKEN}] = {LITERAL, LITERALLISTPRIME};
    table[{LITERALLIST, SUBRANGELITERAL_TOKEN}] = {LITERAL, LITERALLISTPRIME};
    // LISTERALLISTPRIME
    table[{LISTERALLISTPRIME, ','}] = {',', LITERALLIST};
    // GOTOSTMT
    table[{GOTOSTMT, GOTO_TOKEN}] = {GOTO_TOKEN, LABEL_TOKEN};
    // FORBLOCK
    table[{FORBLOCK, FOR_TOKEN}] = {FOR_TOKEN, ID_TOKEN, FORBLOCKPRIME};
    // FORBLOCKPRIME
    table[{FORBLOCKPRIME, '['}] = {VARIABLE,  ATTR_TOKEN, EXPR, TO_TOKEN, EXPR, STEP_TOKEN, EXPR, DO_TOKEN, STMT};
    table[{FORBLOCKPRIME, ACCESS_TOKEN}] = {VARIABLE,  ATTR_TOKEN, EXPR, TO_TOKEN, EXPR, STEP_TOKEN, EXPR, DO_TOKEN, STMT};
    table[{FORBLOCKPRIME, ATTR_TOKEN}] = {ATTR_TOKEN, EXPR, TO_TOKEN, EXPR, STEP_TOKEN, EXPR, DO_TOKEN, STMT};
    // EXPR
    table[{EXPR, ID_TOKEN}] = {CONJ, DISJ};
    table[{EXPR, '('}] = {CONJ, DISJ};
    table[{EXPR, '!'}] = {CONJ, DISJ};
    table[{EXPR, INT_TOKEN] = {CONJ, DISJ};
    table[{EXPR, REAL_TOKEN}] = {CONJ, DISJ};
    table[{EXPR, CHAR_TOKEN}] = {CONJ, DISJ};
    table[{EXPR, STRING_TOKEN}] = {CONJ, DISJ};
    table[{EXPR, SUBRANGELITERAL_TOKEN}] = {CONJ, DISJ};
    // DISJ
    table[{DISJ, ';'}] = {};
    table[{DISJ, ']'}] = {};
    table[{DISJ, OF_TOKEN}] = {};
    table[{DISJ, ','}] = {};
    table[{DISJ, ')'}] = {};
    table[{DISJ, END_TOKEN}] = {};
    table[{DISJ, ELSE_TOKEN}] = {};
    table[{DISJ, TO_TOKEN}] = {};
    table[{DISJ, STEP_TOKEN}] = {};
    table[{DISJ, DO_TOKEN}] = {};
    table[{DISJ, OR_TOKEN}] = {OR_TOKEN, CONJ};
    // FINAL_TERM
    table[{FINAL_TERM, ID_TOKEN}] = {ID_TOKEN, FINAL_TERMPRIME};
    table[{FINAL_TERM, INT_TOKEN}] = {LITERAL};
    table[{FINAL_TERM, REAL_TOKEN}] = {LITERAL};
    table[{FINAL_TERM, CHAR_TOKEN}] = {LITERAL};
    table[{FINAL_TERM, STRING_TOKEN}] = {LITERAL};
    table[{FINAL_TERM, SUBRANGELITERAL_TOKEN}] = {LITERAL};
    table[{FINAL_TERM, '('}] = {'(', EXPR, ')'};
    // FINAL_TERMPRIME
    table[{FINAL_TERMPRIME, '['}] = {VARIABLE};
    table[{FINAL_TERMPRIME, ACCESS_TOKEN}] = {VARIABLE};
    table[{FINAL_TERMPRIME, ';'}] = {};
    table[{FINAL_TERMPRIME, ']'}] = {};
    table[{FINAL_TERMPRIME, OF_TOKEN}] = {};
    table[{FINAL_TERMPRIME, ','}] = {};
    table[{FINAL_TERMPRIME, ')'}] = {};
    table[{FINAL_TERMPRIME, END_TOKEN}] = {};
    table[{FINAL_TERMPRIME, ELSE_TOKEN}] = {};
    table[{FINAL_TERMPRIME, TO_TOKEN}] = {};
    table[{FINAL_TERMPRIME, STEP_TOKEN}] = {};
    table[{FINAL_TERMPRIME, DO_TOKEN}] = {};
    table[{FINAL_TERMPRIME, OR_TOKEN}] = {};
    table[{FINAL_TERMPRIME, '+'}] = {};
    table[{FINAL_TERMPRIME, '-'}] = {};
    table[{FINAL_TERMPRIME, '*'}] = {};
    table[{FINAL_TERMPRIME, '/'}] = {};
    table[{FINAL_TERMPRIME, '%'}] = {};
    table[{FINAL_TERMPRIME, EQUAL_TOKEN}] = {};
    table[{FINAL_TERMPRIME, DIFF_TOKEN}] = {};
    table[{FINAL_TERMPRIME, '<'}] = {};
    table[{FINAL_TERMPRIME, LE_TOKEN}] = {};
    table[{FINAL_TERMPRIME, '>'}] = {};
    table[{FINAL_TERMPRIME, GE_TOKEN}] = {};
    table[{FINAL_TERMPRIME, AND_TOKEN}] = {};
    table[{FINAL_TERMPRIME, '('}] = {SUBPROGCALL};
    // ADD_OP
    table[{ADD_OP, '+'}] = {'+'};
    table[{ADD_OP, '-'}] = {'-'};
    // MUL_OP
    table[{MUL_OP, '*'}] = {'*'};
    table[{MUL_OP, '/'}] = {'/'};
    table[{MUL_OP, '%'}] = {'%'};
    // EQUALITY_OP
    table[{EQUALITY_OP, EQUAL_TOKEN}] = {EQUAL_TOKEN};
    table[{EQUALITY_OP, DIFF_TOKEN}] = {DIFF_TOKEN};
    // RELATIONAL_OP
    table[{RELATIONAL_OP, '<'}] = {'<'};
    table[{RELATIONAL_OP, '>'}] = {'>'};
    table[{RELATIONAL_OP, LE_TOKEN}] = {LE_TOKEN};
    table[{RELATIONAL_OP, GE_TOKEN}] = {GE_TOKEN};
    // CONJ
    table[{CONJ, ID_TOKEN}] = {COMP, CONJPRIME};
    table[{CONJ, '('}] = {COMP, CONJPRIME};
    table[{CONJ, '!'}] = {COMP, CONJPRIME};
    table[{CONJ, INT_TOKEN}] = {COMP, CONJPRIME};
    table[{CONJ, REAL_TOKEN}] = {COMP, CONJPRIME};
    table[{CONJ, CHAR_TOKEN}] = {COMP, CONJPRIME};
    table[{CONJ, STRING_TOKEN}] = {COMP, CONJPRIME};
    table[{CONJ, SUBRANGELITERAL_TOKEN}] = {COMP, CONJPRIME};
    // CONJPRIME
    table[{CONJPRIME, ';'}] = {};
    table[{CONJPRIME, ']'}] = {};
    table[{CONJPRIME, OF_TOKEN}] = {};
    table[{CONJPRIME, ','}] = {};
    table[{CONJPRIME, ')'}] = {};
    table[{CONJPRIME, END_TOKEN}] = {};
    table[{CONJPRIME, ELSE_TOKEN}] = {};
    table[{CONJPRIME, TO_TOKEN}] = {};
    table[{CONJPRIME, STEP_TOKEN}] = {};
    table[{CONJPRIME, DO_TOKEN}] = {};
    table[{CONJPRIME, OR_TOKEN}] = {};
    table[{CONJPRIME, AND_TOKEN}] = {AND_TOKEN, COMP};
    // COMP
    table[{COMP, }] = {};
    // COMPPRIME
    table[{COMPPRIME, }] = {};
    // RELATIONAL
    table[{RELATIONAL, }] = {};
    // RELATIONALPRIME
    table[{RELATIONALPRIME, }] = {};
    // SUM
    table[{SUM, }] = {};
    // SUMPRIME
    table[{SUMPRIME, }] = {};
    // NEG
    table[{NEG, }] = {};
    // MUL
    table[{MUL, }] = {};
    // MULPRIME
    table[{MULPRIME, }] = {};
    // LITERAL
    table[{LITERAL, }] = {};
    // EXPRLIST
    table[{EXPRLIST, }] = {};
    // EXPRLISTPLUS
    table[{EXPRLISTPLUS, }] = {};
    // EXPRLISTPLUSPRIME
    table[{EXPRLISTPLUSPRIME, }] = {};
    // SUBPROGRAMS
    table[{SUBPROGRAMS, }] = {};
    // SUBPROGRAMSPRIME
    table[{SUBPROGRAMSPRIME, }] = {};
    // PROCEDURE
    table[{PROCEDURE, }] = {};
    // FUNCTION
    table[{FUNCTION, }] = {};
    // PARAM
    table[{PARAM, }] = {};
    // WRITESTMT
    table[{WRITESTMT, }] = {};
    // WRITELNSTMT
    table[{WRITELNSTMT, }] = {};
    // READSTMT
    table[{READSTMT, }] = {};
    // READLNSTMT
    table[{READLNSTMT, }] = {};
}

#endif