const child_process = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { sep } = require('path');

// This is assumed to be on PATH.
const program = 'jsbmfbp3';

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'in':
      compile(packet, send);
      break;
    default:
      console.error(new Error('Unknown pin name provided: ' + pin));
  }
};

async function writeTempFile(filePath, content) {
  return new Promise((resolve, reject) => {
    fs.writeFile(filePath, content, (err) => {
      if (err) {
        console.error(new Error(err));
        reject();
        return;
      }

      resolve(filePath);
    });
  });
}

function compile(arrowgram, send) {
  compile2(arrowgram, send).catch(err => {
    if (err) {
      console.error(new Error(err));
      return;
    }
  });
}

async function compile2(arrowgram, send) {
  await fs.mkdtemp(`${os.tmpdir()}${sep}`, async (err, dir) => {
    if (err) {
      console.error(new Error(err));
      return;
    }

    const arrowgramPath = await writeTempFile(path.join(dir, "arrowgram"), JSON.stringify(arrowgram));
    const command = [program, arrowgramPath].join(' ');

    console.log('compiling one arrowgram', command);
    child_process.exec(command, function(err, stdout, stderr) {
      console.error(new Error(stderr));
      if (err) {
        console.error(new Error(err));
        return;
      }

      send('out', JSON.parse(stdout), true);
    });
  });

  // Clean up
  params = {};
}
