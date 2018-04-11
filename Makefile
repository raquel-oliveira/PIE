parser: lex recursive

lex: src/pie.l
	lex src/pie.l

recursive:  src/recursive_parser.cpp src/tokens.cpp
	g++ -std=c++14 -o pie src/recursive_parser.cpp src/tokens.cpp -ll

table: src/table_parser.cpp src/tokens.cpp
	g++ -std=c++14 -o pie src/table_parser.cpp src/tokens.cpp -ll