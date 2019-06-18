const part = require('_part_');
const child_process = require('child_process');
const fs = require('fs');

const metaDataOutPin = part.outPin('metadata');

part.inPin('temp directory', (packet) => {
  const dir = packet();
  fs.stat(dir, function (error, stats) {
    if (stats.isDirectory()) {
      tempDir = dir;
    } else {
      console.error(new Error('"' + dir + '" not a directory'));
    }
  });
});

part.inPin('git repo metadata', (packet) => {
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

    metaDataOutPin(metadata);
  });
});
