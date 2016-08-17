
all: check run

libfoo1.a: foo1.o
	$(AR) rcs $@ $^

libfoo2.a: foo2.o
	$(AR) rcs $@ $^

prog1: libfoo1.a libfoo2.a prog.o
	$(CC) -o $@ prog.o -L. -lfoo1 -lfoo2

prog2: libfoo1.a libfoo2.a prog.o
	$(CC) -o $@ prog.o -L. -lfoo2 -lfoo1

check: foo1.o foo2.o
	readelf -aW foo1.o | grep "FUNC.*foo"
	readelf -aW foo2.o | grep "FUNC.*foo"

run: prog1 prog2
	./prog1
	./prog2

clean:
	$(RM) -f prog1 prog2 *.a *.o
