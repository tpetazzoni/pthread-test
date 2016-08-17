
CFLAGS = -fPIC

all: run-static run-shared

libfoo1.a: foo1.o
	$(AR) rcs $@ $^

libfoo2.a: foo2.o
	$(AR) rcs $@ $^

libfoo-shared1.so: foo1.o
	$(CC) -shared -o $@ -Wl,-soname,libfoo-shared1.so $^

libfoo-shared2.so: foo2.o
	$(CC) -shared -o $@ -Wl,-soname,libfoo-shared2.so $^

prog1-static: libfoo1.a libfoo2.a prog.o
	$(CC) -o $@ prog.o -L. -lfoo1 -lfoo2

prog2-static: libfoo1.a libfoo2.a prog.o
	$(CC) -o $@ prog.o -L. -lfoo2 -lfoo1

prog1-shared: libfoo-shared1.so libfoo-shared2.so
	$(CC) -o $@ prog.o -L. -lfoo-shared1 -lfoo-shared2 -Wl,-rpath,$(shell pwd)

prog2-shared: libfoo-shared1.so libfoo-shared2.so
	$(CC) -o $@ prog.o -L. -lfoo-shared2 -lfoo-shared1 -Wl,-rpath,$(shell pwd)

run-static: prog1-static prog2-static
	@echo "=== Static case ==="
	readelf -aW foo1.o | grep "FUNC.*foo"
	readelf -aW foo2.o | grep "FUNC.*foo"
	./prog1-static
	./prog2-static

run-shared: prog1-shared prog2-shared
	@echo "=== Shared case ==="
	readelf -aW libfoo-shared1.so | grep "FUNC.*foo"
	readelf -aW libfoo-shared2.so | grep "FUNC.*foo"
	./prog1-shared
	./prog2-shared

clean:
	$(RM) -f prog1* prog2* *.a *.o
