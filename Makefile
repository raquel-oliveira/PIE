parser: lex2 syntax bottomup

lex: src/pie.l
	lex src/pie.l

lex2: src/pie3.l
	lex src/pie3.l

syntax: src/pie.y
	yacc -d src/pie.y

bottomup: y.tab.c lex.yy.c
	g++ -o pie y.tab.c lex.yy.c -ll

recursive:  src/recursive_parser.cpp src/tokens.cpp
	g++ -std=c++14 -o recursive src/recursive_parser.cpp src/tokens.cpp -ll

table: src/table_parser.cpp src/tokens.cpp
	g++ -std=c++14 -o table src/table_parser.cpp src/tokens.cpp -ll
