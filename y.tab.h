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
    REALLITERAL_TOKEN = 259,
    STRINGLITERAL_TOKEN = 260,
    SUBRANGELITERAL_TOKEN = 261,
    CHARLITERAL_TOKEN = 262,
    INTLITERAL_TOKEN = 263,
    LABEL_TOKEN = 264,
    BOOLLITERAL_TOKEN = 265,
    PROGRAM_TOKEN = 266,
    PROC_TOKEN = 267,
    BEGIN_TOKEN = 268,
    END_TOKEN = 269,
    FUNC_TOKEN = 270,
    CONST_TOKEN = 271,
    TYPE_TOKEN = 272,
    VAR_TOKEN = 273,
    IF_TOKEN = 274,
    ELSE_TOKEN = 275,
    GOTO_TOKEN = 276,
    FOR_TOKEN = 277,
    TO_TOKEN = 278,
    DO_TOKEN = 279,
    STEP_TOKEN = 280,
    IN_TOKEN = 281,
    OF_TOKEN = 282,
    LOOP_TOKEN = 283,
    EXITWHEN_TOKEN = 284,
    CASE_TOKEN = 285,
    WRITE_TOKEN = 286,
    WRITELN_TOKEN = 287,
    READ_TOKEN = 288,
    READLN_TOKEN = 289,
    RETURN_TOKEN = 290,
    INT_TOKEN = 291,
    BOOL_TOKEN = 292,
    REAL_TOKEN = 293,
    CHAR_TOKEN = 294,
    STRING_TOKEN = 295,
    ARRAY_TOKEN = 296,
    RECORD_TOKEN = 297,
    SUBRANGE_TOKEN = 298,
    SET_TOKEN = 299,
    TRUE_TOKEN = 300,
    FALSE_TOKEN = 301,
    NIL_TOKEN = 302,
    LE_TOKEN = 303,
    GE_TOKEN = 304,
    EQUAL_TOKEN = 305,
    DIFF_TOKEN = 306,
    AND_TOKEN = 307,
    OR_TOKEN = 308,
    ATTR_TOKEN = 309,
    ACCESS_TOKEN = 310,
    ERROR_TOKEN = 311,
    RANGE_TOKEN = 312,
    REF_TOKEN = 313,
    ENDOFFILE_TOKEN = 314
  };
#endif
/* Tokens.  */
#define ID_TOKEN 258
#define REALLITERAL_TOKEN 259
#define STRINGLITERAL_TOKEN 260
#define SUBRANGELITERAL_TOKEN 261
#define CHARLITERAL_TOKEN 262
#define INTLITERAL_TOKEN 263
#define LABEL_TOKEN 264
#define BOOLLITERAL_TOKEN 265
#define PROGRAM_TOKEN 266
#define PROC_TOKEN 267
#define BEGIN_TOKEN 268
#define END_TOKEN 269
#define FUNC_TOKEN 270
#define CONST_TOKEN 271
#define TYPE_TOKEN 272
#define VAR_TOKEN 273
#define IF_TOKEN 274
#define ELSE_TOKEN 275
#define GOTO_TOKEN 276
#define FOR_TOKEN 277
#define TO_TOKEN 278
#define DO_TOKEN 279
#define STEP_TOKEN 280
#define IN_TOKEN 281
#define OF_TOKEN 282
#define LOOP_TOKEN 283
#define EXITWHEN_TOKEN 284
#define CASE_TOKEN 285
#define WRITE_TOKEN 286
#define WRITELN_TOKEN 287
#define READ_TOKEN 288
#define READLN_TOKEN 289
#define RETURN_TOKEN 290
#define INT_TOKEN 291
#define BOOL_TOKEN 292
#define REAL_TOKEN 293
#define CHAR_TOKEN 294
#define STRING_TOKEN 295
#define ARRAY_TOKEN 296
#define RECORD_TOKEN 297
#define SUBRANGE_TOKEN 298
#define SET_TOKEN 299
#define TRUE_TOKEN 300
#define FALSE_TOKEN 301
#define NIL_TOKEN 302
#define LE_TOKEN 303
#define GE_TOKEN 304
#define EQUAL_TOKEN 305
#define DIFF_TOKEN 306
#define AND_TOKEN 307
#define OR_TOKEN 308
#define ATTR_TOKEN 309
#define ACCESS_TOKEN 310
#define ERROR_TOKEN 311
#define RANGE_TOKEN 312
#define REF_TOKEN 313
#define ENDOFFILE_TOKEN 314

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 16 "src/pie.y" /* yacc.c:1915  */

  int id;
  int row;
  int col;
  char* lexeme;

#line 179 "y.tab.h" /* yacc.c:1915  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
