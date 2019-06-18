const child_process = require('child_process');

return function (partId, send, release) {
  const command = 'compile_one_diagram';

  return function (pin, packet) {
    switch (pin) {
      case 'diagram':
        child_process.exec(command, function(err, stdout, stderr) {
          if (err) {
            console.error(err);
            return;
          }

          send(partId, 'graph as json', stdout);
        });
        break;
    }
  };
};
