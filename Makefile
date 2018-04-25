parser: lex recursive table

lex: src/pie.l
	lex src/pie2.l

recursive:  src/recursive_parser.cpp src/tokens.cpp
	g++ -std=c++14 -o recursive src/recursive_parser.cpp src/tokens.cpp -ll

table: src/table_parser.cpp src/tokens.cpp
	g++ -std=c++14 -o table src/table_parser.cpp src/tokens.cpp -ll