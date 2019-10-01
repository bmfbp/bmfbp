const part = require('_part_');
const child_process = require('child_process');

const command = 'compile_one_diagram';

const graphAsJsonOutPin = part.outPin('graph as json');

part.inPin('diagram', () => {
  child_process.exec(command, function(err, stdout, stderr) {
    if (err) {
      console.error(err);
      return;
    }

    graphAsJsonOutPin(stdout);
  });
});
