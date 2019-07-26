BINDIR=~/bin
TEST_CASES=../../test_cases

all: dependencies

dependencies:
	cd ../js-compiler && make
	cp ./splitmeta.sh $(BINDIR)/splitmeta
	chmod a+x $(BINDIR)/splitmeta

clean:
	rm -f temp*.pro temp*.js temp*.lisp $(BINDIR)/splitmeta $(BINDIR)/compare-graph temp.log*.txt strings.sed

