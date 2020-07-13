% [start request]
% [out error]
% tokenize
% strings
% parens
% spaces
% symbols
% integers
% 
% .out -> .token: tokenize | strings | parens | spaces | symbols | integers
% self.start -> tokenize.start
% self.request -> tokenize.pull
% <- tokenize.pull <- strings, parens, spaces, symbols, integers
% <- self.error <- tokenize, strings, parens, spaces, symbols, integers
% 

Part Scanner
inputs: [start request]
outputs: [out error]
parts : [
      tokenizer inputs: [start pull] outputs:[token error]
      strings inputs: [token] outputs:[request out error]
      parens: inputs: [token] outputs:[request out error]
      spaces: inputs: [token] outputs:[request out error]
      symbols: inputs: [token] outputs:[request out error]
      integers: inputs: [token] outputs:[request out error]
]

self.request -> tokenizer.pull

% pipeline
self.start -> tokenizer.start
tokenizer.token -> strings.token
strings.out -> parens.token
parens.out -> spaces.token
spaces.out -> symbols.token
symbols.out -> intgers.token
integers.out -> self.out

% request/pull
self.request, strings.request, parens.request, spaces.request, symbols.request, integers.request -> tokenize.pull

% errors
tokenizer.error, strings.error, parens.error, spaces.error, symbols.error, integers.error -> self.error

