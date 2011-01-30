all: lib/YAML/Tiny.pbc

%.pbc: %.pir
	parrot -o $@ $^

%.pir: %.pm
	parrot-nqp --target=pir -o $@ $^

test: lib/YAML/Tiny.pbc t/lib/Test.pbc
	prove -e parrot-nqp -r -v t/*.t

clean:
	rm -f lib/YAML/Tiny.pbc t/lib/Test.pbc

LIBDIR = `parrot_config libdir`

install:
	mkdir -p $(LIBDIR)/YAML
	cp lib/YAML/Tiny.pbc $(LIBDIR)/YAML
