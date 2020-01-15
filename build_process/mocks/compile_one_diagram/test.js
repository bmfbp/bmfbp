const fs = require('fs');
const compile = require('../../parts/compile_one_diagram');
 
fs.readFile(`${__dirname}/facts.pro`, 'utf8', function(err, facts) {
  if (err) {
    console.error(new Error(err));
    return;
  }

  fs.readFile(`${__dirname}/strings.lisp`, 'utf8', function(err, strings) {
    if (err) {
      console.error(new Error(err));
      return;
    }

    compile.main('name', 'test-name', send);
    compile.main('facts', facts, send);
    compile.main('strings', strings, send);
  });
});

function send(pin, packet) {
  switch (pin) {
    case 'graph as json':
      console.log('output: ', packet);
      break;
  }
}
