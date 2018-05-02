/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ID_TOKEN = 258,
    PROGRAM_TOKEN = 259,
    PROC_TOKEN = 260,
    BEGIN_TOKEN = 261,
    END_TOKEN = 262,
    FUNC_TOKEN = 263,
    CONST_TOKEN = 264,
    TYPE_TOKEN = 265,
    VAR_TOKEN = 266,
    IF_TOKEN = 267,
    ELSE_TOKEN = 268,
    GOTO_TOKEN = 269,
    FOR_TOKEN = 270,
    TO_TOKEN = 271,
    DO_TOKEN = 272,
    STEP_TOKEN = 273,
    IN_TOKEN = 274,
    OF_TOKEN = 275,
    LOOP_TOKEN = 276,
    EXITWHEN_TOKEN = 277,
    CASE_TOKEN = 278,
    WRITE_TOKEN = 279,
    WRITELN_TOKEN = 280,
    READ_TOKEN = 281,
    READLN_TOKEN = 282,
    RETURN_TOKEN = 283,
    INT_TOKEN = 284,
    BOOL_TOKEN = 285,
    REAL_TOKEN = 286,
    CHAR_TOKEN = 287,
    STRING_TOKEN = 288,
    ARRAY_TOKEN = 289,
    RECORD_TOKEN = 290,
    SUBRANGE_TOKEN = 291,
    SET_TOKEN = 292,
    TRUE_TOKEN = 293,
    FALSE_TOKEN = 294,
    NIL_TOKEN = 295,
    LE_TOKEN = 296,
    GE_TOKEN = 297,
    EQUAL_TOKEN = 298,
    DIFF_TOKEN = 299,
    AND_TOKEN = 300,
    OR_TOKEN = 301,
    ATTR_TOKEN = 302,
    ACCESS_TOKEN = 303,
    LABEL_TOKEN = 304,
    CHARLITERAL_TOKEN = 305,
    INTLITERAL_TOKEN = 306,
    REALLITERAL_TOKEN = 307,
    STRINGLITERAL_TOKEN = 308,
    SUBRANGELITERAL_TOKEN = 309,
    ERROR_TOKEN = 310,
    RANGE_TOKEN = 311,
    REF_TOKEN = 312,
    ENDOFFILE_TOKEN = 313
  };
#endif
/* Tokens.  */
#define ID_TOKEN 258
#define PROGRAM_TOKEN 259
#define PROC_TOKEN 260
#define BEGIN_TOKEN 261
#define END_TOKEN 262
#define FUNC_TOKEN 263
#define CONST_TOKEN 264
#define TYPE_TOKEN 265
#define VAR_TOKEN 266
#define IF_TOKEN 267
#define ELSE_TOKEN 268
#define GOTO_TOKEN 269
#define FOR_TOKEN 270
#define TO_TOKEN 271
#define DO_TOKEN 272
#define STEP_TOKEN 273
#define IN_TOKEN 274
#define OF_TOKEN 275
#define LOOP_TOKEN 276
#define EXITWHEN_TOKEN 277
#define CASE_TOKEN 278
#define WRITE_TOKEN 279
#define WRITELN_TOKEN 280
#define READ_TOKEN 281
#define READLN_TOKEN 282
#define RETURN_TOKEN 283
#define INT_TOKEN 284
#define BOOL_TOKEN 285
#define REAL_TOKEN 286
#define CHAR_TOKEN 287
#define STRING_TOKEN 288
#define ARRAY_TOKEN 289
#define RECORD_TOKEN 290
#define SUBRANGE_TOKEN 291
#define SET_TOKEN 292
#define TRUE_TOKEN 293
#define FALSE_TOKEN 294
#define NIL_TOKEN 295
#define LE_TOKEN 296
#define GE_TOKEN 297
#define EQUAL_TOKEN 298
#define DIFF_TOKEN 299
#define AND_TOKEN 300
#define OR_TOKEN 301
#define ATTR_TOKEN 302
#define ACCESS_TOKEN 303
#define LABEL_TOKEN 304
#define CHARLITERAL_TOKEN 305
#define INTLITERAL_TOKEN 306
#define REALLITERAL_TOKEN 307
#define STRINGLITERAL_TOKEN 308
#define SUBRANGELITERAL_TOKEN 309
#define ERROR_TOKEN 310
#define RANGE_TOKEN 311
#define REF_TOKEN 312
#define ENDOFFILE_TOKEN 313

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 16 "src/pie.y" /* yacc.c:1915  */

  int id;
  int row;
  int col;
  char* lexeme;

#line 177 "y.tab.h" /* yacc.c:1915  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
