const child_process = require('child_process');

return function (partId, send, release) {
  const command = 'split_diagram';

  return function (pin, packet) {
    switch (pin) {
      case 'svg content':
        child_process.exec(command, function(err, stdout, stderr) {
          if (err) {
            console.error(err);
            return;
          }

          // Use output stream 0.
          send(partId, 'diagram', stdout);
          // Use output stream 1.
          send(partId, 'metadata as json array', stderr);
        });
        break;
    }
  };
};
