#ifndef YY_parse_h_included
#define YY_parse_h_included
/*#define YY_USE_CLASS 
*/
#line 1 "/usr/share/bison++/bison.h"
/* before anything */
#ifdef c_plusplus
 #ifndef __cplusplus
  #define __cplusplus
 #endif
#endif


 #line 8 "/usr/share/bison++/bison.h"

#line 16 "src/pie.y"
typedef union {
  int id;
  int row;
  int col;
  char* lexeme;
} yy_parse_stype;
#define YY_parse_STYPE yy_parse_stype
#ifndef YY_USE_CLASS
#define YYSTYPE yy_parse_stype
#endif

#line 21 "/usr/share/bison++/bison.h"
 /* %{ and %header{ and %union, during decl */
#ifndef YY_parse_COMPATIBILITY
 #ifndef YY_USE_CLASS
  #define  YY_parse_COMPATIBILITY 1
 #else
  #define  YY_parse_COMPATIBILITY 0
 #endif
#endif

#if YY_parse_COMPATIBILITY != 0
/* backward compatibility */
 #ifdef YYLTYPE
  #ifndef YY_parse_LTYPE
   #define YY_parse_LTYPE YYLTYPE
/* WARNING obsolete !!! user defined YYLTYPE not reported into generated header */
/* use %define LTYPE */
  #endif
 #endif
/*#ifdef YYSTYPE*/
  #ifndef YY_parse_STYPE
   #define YY_parse_STYPE YYSTYPE
  /* WARNING obsolete !!! user defined YYSTYPE not reported into generated header */
   /* use %define STYPE */
  #endif
/*#endif*/
 #ifdef YYDEBUG
  #ifndef YY_parse_DEBUG
   #define  YY_parse_DEBUG YYDEBUG
   /* WARNING obsolete !!! user defined YYDEBUG not reported into generated header */
   /* use %define DEBUG */
  #endif
 #endif 
 /* use goto to be compatible */
 #ifndef YY_parse_USE_GOTO
  #define YY_parse_USE_GOTO 1
 #endif
#endif

/* use no goto to be clean in C++ */
#ifndef YY_parse_USE_GOTO
 #define YY_parse_USE_GOTO 0
#endif

#ifndef YY_parse_PURE

 #line 65 "/usr/share/bison++/bison.h"

#line 65 "/usr/share/bison++/bison.h"
/* YY_parse_PURE */
#endif


 #line 68 "/usr/share/bison++/bison.h"

#line 68 "/usr/share/bison++/bison.h"
/* prefix */

#ifndef YY_parse_DEBUG

 #line 71 "/usr/share/bison++/bison.h"

#line 71 "/usr/share/bison++/bison.h"
/* YY_parse_DEBUG */
#endif

#ifndef YY_parse_LSP_NEEDED

 #line 75 "/usr/share/bison++/bison.h"

#line 75 "/usr/share/bison++/bison.h"
 /* YY_parse_LSP_NEEDED*/
#endif

/* DEFAULT LTYPE*/
#ifdef YY_parse_LSP_NEEDED
 #ifndef YY_parse_LTYPE
  #ifndef BISON_YYLTYPE_ISDECLARED
   #define BISON_YYLTYPE_ISDECLARED
typedef
  struct yyltype
    {
      int timestamp;
      int first_line;
      int first_column;
      int last_line;
      int last_column;
      char *text;
   }
  yyltype;
  #endif

  #define YY_parse_LTYPE yyltype
 #endif
#endif

/* DEFAULT STYPE*/
#ifndef YY_parse_STYPE
 #define YY_parse_STYPE int
#endif

/* DEFAULT MISCELANEOUS */
#ifndef YY_parse_PARSE
 #define YY_parse_PARSE yyparse
#endif

#ifndef YY_parse_LEX
 #define YY_parse_LEX yylex
#endif

#ifndef YY_parse_LVAL
 #define YY_parse_LVAL yylval
#endif

#ifndef YY_parse_LLOC
 #define YY_parse_LLOC yylloc
#endif

#ifndef YY_parse_CHAR
 #define YY_parse_CHAR yychar
#endif

#ifndef YY_parse_NERRS
 #define YY_parse_NERRS yynerrs
#endif

#ifndef YY_parse_DEBUG_FLAG
 #define YY_parse_DEBUG_FLAG yydebug
#endif

#ifndef YY_parse_ERROR
 #define YY_parse_ERROR yyerror
#endif

#ifndef YY_parse_PARSE_PARAM
 #ifndef __STDC__
  #ifndef __cplusplus
   #ifndef YY_USE_CLASS
    #define YY_parse_PARSE_PARAM
    #ifndef YY_parse_PARSE_PARAM_DEF
     #define YY_parse_PARSE_PARAM_DEF
    #endif
   #endif
  #endif
 #endif
 #ifndef YY_parse_PARSE_PARAM
  #define YY_parse_PARSE_PARAM void
 #endif
#endif

/* TOKEN C */
#ifndef YY_USE_CLASS

 #ifndef YY_parse_PURE
  #ifndef yylval
   extern YY_parse_STYPE YY_parse_LVAL;
  #else
   #if yylval != YY_parse_LVAL
    extern YY_parse_STYPE YY_parse_LVAL;
   #else
    #warning "Namespace conflict, disabling some functionality (bison++ only)"
   #endif
  #endif
 #endif


 #line 169 "/usr/share/bison++/bison.h"
#define	ID_TOKEN	258
#define	REALLITERAL_TOKEN	259
#define	STRINGLITERAL_TOKEN	260
#define	SUBRANGELITERAL_TOKEN	261
#define	CHARLITERAL_TOKEN	262
#define	INTLITERAL_TOKEN	263
#define	LABEL_TOKEN	264
#define	BOOLLITERAL_TOKEN	265
#define	PROGRAM_TOKEN	266
#define	PROC_TOKEN	267
#define	BEGIN_TOKEN	268
#define	END_TOKEN	269
#define	FUNC_TOKEN	270
#define	CONST_TOKEN	271
#define	TYPE_TOKEN	272
#define	VAR_TOKEN	273
#define	IF_TOKEN	274
#define	ELSE_TOKEN	275
#define	GOTO_TOKEN	276
#define	FOR_TOKEN	277
#define	TO_TOKEN	278
#define	DO_TOKEN	279
#define	STEP_TOKEN	280
#define	IN_TOKEN	281
#define	OF_TOKEN	282
#define	LOOP_TOKEN	283
#define	EXITWHEN_TOKEN	284
#define	CASE_TOKEN	285
#define	WRITE_TOKEN	286
#define	WRITELN_TOKEN	287
#define	READ_TOKEN	288
#define	READLN_TOKEN	289
#define	RETURN_TOKEN	290
#define	INT_TOKEN	291
#define	BOOL_TOKEN	292
#define	REAL_TOKEN	293
#define	CHAR_TOKEN	294
#define	STRING_TOKEN	295
#define	ARRAY_TOKEN	296
#define	RECORD_TOKEN	297
#define	SUBRANGE_TOKEN	298
#define	SET_TOKEN	299
#define	TRUE_TOKEN	300
#define	FALSE_TOKEN	301
#define	NIL_TOKEN	302
#define	LE_TOKEN	303
#define	GE_TOKEN	304
#define	EQUAL_TOKEN	305
#define	DIFF_TOKEN	306
#define	AND_TOKEN	307
#define	OR_TOKEN	308
#define	ATTR_TOKEN	309
#define	ACCESS_TOKEN	310
#define	ERROR_TOKEN	311
#define	RANGE_TOKEN	312
#define	REF_TOKEN	313
#define	ENDOFFILE_TOKEN	314


#line 169 "/usr/share/bison++/bison.h"
 /* #defines token */
/* after #define tokens, before const tokens S5*/
#else
 #ifndef YY_parse_CLASS
  #define YY_parse_CLASS parse
 #endif

 #ifndef YY_parse_INHERIT
  #define YY_parse_INHERIT
 #endif

 #ifndef YY_parse_MEMBERS
  #define YY_parse_MEMBERS 
 #endif

 #ifndef YY_parse_LEX_BODY
  #define YY_parse_LEX_BODY  
 #endif

 #ifndef YY_parse_ERROR_BODY
  #define YY_parse_ERROR_BODY  
 #endif

 #ifndef YY_parse_CONSTRUCTOR_PARAM
  #define YY_parse_CONSTRUCTOR_PARAM
 #endif
 /* choose between enum and const */
 #ifndef YY_parse_USE_CONST_TOKEN
  #define YY_parse_USE_CONST_TOKEN 0
  /* yes enum is more compatible with flex,  */
  /* so by default we use it */ 
 #endif
 #if YY_parse_USE_CONST_TOKEN != 0
  #ifndef YY_parse_ENUM_TOKEN
   #define YY_parse_ENUM_TOKEN yy_parse_enum_token
  #endif
 #endif

class YY_parse_CLASS YY_parse_INHERIT
{
public: 
 #if YY_parse_USE_CONST_TOKEN != 0
  /* static const int token ... */
  
 #line 212 "/usr/share/bison++/bison.h"
static const int ID_TOKEN;
static const int REALLITERAL_TOKEN;
static const int STRINGLITERAL_TOKEN;
static const int SUBRANGELITERAL_TOKEN;
static const int CHARLITERAL_TOKEN;
static const int INTLITERAL_TOKEN;
static const int LABEL_TOKEN;
static const int BOOLLITERAL_TOKEN;
static const int PROGRAM_TOKEN;
static const int PROC_TOKEN;
static const int BEGIN_TOKEN;
static const int END_TOKEN;
static const int FUNC_TOKEN;
static const int CONST_TOKEN;
static const int TYPE_TOKEN;
static const int VAR_TOKEN;
static const int IF_TOKEN;
static const int ELSE_TOKEN;
static const int GOTO_TOKEN;
static const int FOR_TOKEN;
static const int TO_TOKEN;
static const int DO_TOKEN;
static const int STEP_TOKEN;
static const int IN_TOKEN;
static const int OF_TOKEN;
static const int LOOP_TOKEN;
static const int EXITWHEN_TOKEN;
static const int CASE_TOKEN;
static const int WRITE_TOKEN;
static const int WRITELN_TOKEN;
static const int READ_TOKEN;
static const int READLN_TOKEN;
static const int RETURN_TOKEN;
static const int INT_TOKEN;
static const int BOOL_TOKEN;
static const int REAL_TOKEN;
static const int CHAR_TOKEN;
static const int STRING_TOKEN;
static const int ARRAY_TOKEN;
static const int RECORD_TOKEN;
static const int SUBRANGE_TOKEN;
static const int SET_TOKEN;
static const int TRUE_TOKEN;
static const int FALSE_TOKEN;
static const int NIL_TOKEN;
static const int LE_TOKEN;
static const int GE_TOKEN;
static const int EQUAL_TOKEN;
static const int DIFF_TOKEN;
static const int AND_TOKEN;
static const int OR_TOKEN;
static const int ATTR_TOKEN;
static const int ACCESS_TOKEN;
static const int ERROR_TOKEN;
static const int RANGE_TOKEN;
static const int REF_TOKEN;
static const int ENDOFFILE_TOKEN;


#line 212 "/usr/share/bison++/bison.h"
 /* decl const */
 #else
  enum YY_parse_ENUM_TOKEN { YY_parse_NULL_TOKEN=0
  
 #line 215 "/usr/share/bison++/bison.h"
	,ID_TOKEN=258
	,REALLITERAL_TOKEN=259
	,STRINGLITERAL_TOKEN=260
	,SUBRANGELITERAL_TOKEN=261
	,CHARLITERAL_TOKEN=262
	,INTLITERAL_TOKEN=263
	,LABEL_TOKEN=264
	,BOOLLITERAL_TOKEN=265
	,PROGRAM_TOKEN=266
	,PROC_TOKEN=267
	,BEGIN_TOKEN=268
	,END_TOKEN=269
	,FUNC_TOKEN=270
	,CONST_TOKEN=271
	,TYPE_TOKEN=272
	,VAR_TOKEN=273
	,IF_TOKEN=274
	,ELSE_TOKEN=275
	,GOTO_TOKEN=276
	,FOR_TOKEN=277
	,TO_TOKEN=278
	,DO_TOKEN=279
	,STEP_TOKEN=280
	,IN_TOKEN=281
	,OF_TOKEN=282
	,LOOP_TOKEN=283
	,EXITWHEN_TOKEN=284
	,CASE_TOKEN=285
	,WRITE_TOKEN=286
	,WRITELN_TOKEN=287
	,READ_TOKEN=288
	,READLN_TOKEN=289
	,RETURN_TOKEN=290
	,INT_TOKEN=291
	,BOOL_TOKEN=292
	,REAL_TOKEN=293
	,CHAR_TOKEN=294
	,STRING_TOKEN=295
	,ARRAY_TOKEN=296
	,RECORD_TOKEN=297
	,SUBRANGE_TOKEN=298
	,SET_TOKEN=299
	,TRUE_TOKEN=300
	,FALSE_TOKEN=301
	,NIL_TOKEN=302
	,LE_TOKEN=303
	,GE_TOKEN=304
	,EQUAL_TOKEN=305
	,DIFF_TOKEN=306
	,AND_TOKEN=307
	,OR_TOKEN=308
	,ATTR_TOKEN=309
	,ACCESS_TOKEN=310
	,ERROR_TOKEN=311
	,RANGE_TOKEN=312
	,REF_TOKEN=313
	,ENDOFFILE_TOKEN=314


#line 215 "/usr/share/bison++/bison.h"
 /* enum token */
     }; /* end of enum declaration */
 #endif
public:
 int YY_parse_PARSE(YY_parse_PARSE_PARAM);
 virtual void YY_parse_ERROR(char *msg) YY_parse_ERROR_BODY;
 #ifdef YY_parse_PURE
  #ifdef YY_parse_LSP_NEEDED
   virtual int  YY_parse_LEX(YY_parse_STYPE *YY_parse_LVAL,YY_parse_LTYPE *YY_parse_LLOC) YY_parse_LEX_BODY;
  #else
   virtual int  YY_parse_LEX(YY_parse_STYPE *YY_parse_LVAL) YY_parse_LEX_BODY;
  #endif
 #else
  virtual int YY_parse_LEX() YY_parse_LEX_BODY;
  YY_parse_STYPE YY_parse_LVAL;
  #ifdef YY_parse_LSP_NEEDED
   YY_parse_LTYPE YY_parse_LLOC;
  #endif
  int YY_parse_NERRS;
  int YY_parse_CHAR;
 #endif
 #if YY_parse_DEBUG != 0
  public:
   int YY_parse_DEBUG_FLAG;	/*  nonzero means print parse trace	*/
 #endif
public:
 YY_parse_CLASS(YY_parse_CONSTRUCTOR_PARAM);
public:
 YY_parse_MEMBERS 
};
/* other declare folow */
#endif


#if YY_parse_COMPATIBILITY != 0
 /* backward compatibility */
 /* Removed due to bison problems
 /#ifndef YYSTYPE
 / #define YYSTYPE YY_parse_STYPE
 /#endif*/

 #ifndef YYLTYPE
  #define YYLTYPE YY_parse_LTYPE
 #endif
 #ifndef YYDEBUG
  #ifdef YY_parse_DEBUG 
   #define YYDEBUG YY_parse_DEBUG
  #endif
 #endif

#endif
/* END */

 #line 267 "/usr/share/bison++/bison.h"
#endif
