ELM=elm

all: clean
	mkdir -p dist
	cat lib/* > dist/lib.js
	cp src/index.html dist
	cp src/index.css dist
	$(ELM) make src/Main.elm --output=dist/app.js

clean:
	rm -rf dist/
