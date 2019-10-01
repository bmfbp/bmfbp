const tmp = require('tmp');

exports.bootstrap = (send, release) => {
  tmp.dir(function (error, tempDir, cleanup) {
    if (error) {
      console.error(error);
    } else {
      send('directory', tempDir);
    }

    release();
  });
}

exports.main = () => {}
