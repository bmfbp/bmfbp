BINDIR=~/bin

all : $(BINDIR)/grash

$(BINDIR)/grash: grash.c
	mkdir -p $(BINDIR)
	$(CC) -O -o $(BINDIR)/grash grash.c

$(BINDIR)/dbgrash: grash.c
	mkdir -p $(BINDIR)
	$(CC) -O -ggdb -o $(BINDIR)/dbgrash grash.c

clean:
	rm -rf $(BINDIR)/grash.dSYM
	rm -f $(BINDIR)/grash

