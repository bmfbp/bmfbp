const child_process = require('child_process');
const fs = require('fs');

return function (partId, send, release) {
  return function (pin, packet) {
    switch (pin) {
      case 'temp directory':
        const dir = packet();
        fs.stat(dir, function (error, stats) {
          if (stats.isDirectory()) {
            tempDir = dir;
          } else {
            console.error(new Error('"' + dir + '" not a directory'));
          }
        });
        break;

      case 'git repo metadata':
        if (tempDir === null) {
          console.error(new Error('Temporary directory not defiend'));
          return;
        }

        const metadata = packet();
        const cmd = ['cd', tempDir, '&& git clone', metadata.repo, repoIdHash, '&& git checkout', metadata.ref].join(' ');

        child_process.exec(cmd, {}, function (error, stdout, stderr) {
          if (error) {
            console.error(error);
            return;
          }

          send(partId, 'metadata', metadata);
        });
        break;
    }
  };
};
