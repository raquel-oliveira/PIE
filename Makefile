parser: lex2 codegenerator bottomup clean

lex: src/pie.l
	lex src/pie.l

lex2: src/bottomup_lex.l
	lex src/bottomup_lex.l

syntax: src/pie.y
	yacc -d src/pie.y

codegenerator: src/pie_c.y
	yacc -d src/pie_c.y

bottomup: y.tab.c lex.yy.c
	g++ -std=c++14 -o bake y.tab.c lex.yy.c -ll

recursive:  src/recursive_parser.cpp src/tokens.cpp
	g++ -std=c++14 -o recursive src/recursive_parser.cpp src/tokens.cpp -ll

table: src/table_parser.cpp src/tokens.cpp
	g++ -std=c++14 -o table src/table_parser.cpp src/tokens.cpp -ll

clean:
	rm y.tab.c lex.yy.c y.tab.h
