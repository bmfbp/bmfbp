#|

const path = require('path');
const fs = require('fs');
const crypto = require('crypto');

let tempDir = null;

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'temp directory':
      const dir = packet;
      fs.stat(dir, function (error, stats) {
        if (! stats.isDirectory()) {
          console.error(new Error('"' + dir + '" not a directory'));
          return;
        }

        tempDir = dir;
      });
      break;

    case 'git repo metadata':
      if (tempDir === null) {
        console.error(new Error('Temporary directory not defiend'));
        return;
      }

      const metadata = packet;
      const repoIdOnFilesystem = [metadata.repo, metadata.ref].join('-');
      const repoIdHash = crypto.createHash('sha256').update(repoIdOnFilesystem).digest('hex');
      const repoDir = path.join(tempDir, repoIdHash);

      fs.stat(repoDir, function (error, stats) {
        if (error) {
          console.error(error);
          return;
        } else if (! stats.isDirectory()) {
          console.error(new Error(repoDir + ' not a directory'));
          return;
        }

        const filePath = path.join(repoDir, metadata.dir, metadata.file);

        fs.stat(filePath, function (error, stats) {
          if (error) {
            console.error(error);
            return;
          }

          if (!stats.isFile()) {
            console.error(new Error('No file found at ' + filePath));
            return;
          }

          fs.readFile(filePath, function (error, data) {
            if (error) {
              console.error(error);
              return;
            }

            send('metadata', metadata);
            send('file content', data);
          });
        });
      });
      break;
  }
};

|#

(in-package :arrowgrams/build/cl-build)

;; part signature:
;; iterator :code '(:start :continue :done) '("get a part")
;;                ^input pins               ^output pins

(defclass iterator-part (e/part) ())

(defmethod first-time ((self iterator)
  (@set-instance-var self :state :stopped))

(defmethod react ((self iterator) (event e/event))
  (let ((pin-sym (@get-pin self e))) ;; also checks validity of input pin name
    
    (ecase (@get-instance-var self :state)

      (:stopped
       (ecase pin-sym
         (:start
          (@set-instance-var self :state :started)))
       (otherwise nil)) ;; no action (we could have used "case" instead of ecase to avoid writing this otherwise clause)

      (:started
       (ecase pin-sym
         (:continue
          (@send self "get a part" T))
         (:done
          (@set-instance-var self :state :stopped))
         (otherwise
          nil))))))