BINDIR=~/bin
TEST_CASES=../../test_cases

all: dependencies

dependencies:
	cd ../js-compiler && make
	cp ./splitmeta.sh $(BINDIR)/splitmeta
	chmod a+x $(BINDIR)/splitmeta
	cp ./part_split.sh $(BINDIR)/part_split
	chmod a+x $(BINDIR)/part_split

clean:
	rm -f temp*.pro temp*.js temp*.lisp $(BINDIR)/splitmeta $(BINDIR)/part_split temp.log*.txt strings.sed

