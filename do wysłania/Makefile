.PHONY = all clean cleanall

all: calc

calc: calc.y calc.l
	bison -o calc_y.cpp -d calc.y
	flex -o calc_l.cpp calc.l
	g++ -o calc code/MakeNum.cpp code/Operand.cpp code/Param.cpp calc_y.cpp calc_l.cpp

clean:
	rm -f *y.cpp *y.h  *y.hpp *l.cpp *l.h  *l.hpp

cleanall: clean
	rm -f calc
