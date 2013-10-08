LABNAME = cachesim

COMPILER = g++ 
COMPILER_OPTS = -c -g -Wall
LINKER = g++

OBJS = cache.o parse_input.o


$(LABNAME): cache.o parse-input.o
	$(LINKER) $(OBJS) -o $(LABNAME)

cache.o : cache.c
	$(COMPILER) $(COMPILER_OPTS) cache.c

parse-input.o :
	 $(COMPILER) $(COMPILER_OPTS) parse_input.c

clean:
	-rm -f *.o $(LABNAME)
