const part = require('_part_');
const tmp = require('tmp');

const directoryOutPin = part.outPin('directory');

tmp.dir(function (error, tempDir, cleanup) {
  if (error) {
    console.error(error);
  } else {
    directoryOutPin(tempDir);
  }

  part.release();
});
