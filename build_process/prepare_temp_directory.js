const tmp = require('tmp');

return function (partId, send, release) {
  tmp.dir(function (error, tempDir, cleanup) {
    if (error) {
      console.error(error);
    } else {
      send(partId, 'directory', tempDir);
    }

    release();
  });

  return function (pin, packet) {
  };
};
