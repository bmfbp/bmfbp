// Source: https://www.html5rocks.com/en/tutorials/file/dndfiles/

function handleDragOver(evt) {
  evt.stopPropagation();
  evt.preventDefault();
  evt.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
}

function handleFileRead(evt) {
  const content = evt.target.result;
  app.ports.fileHasBeenRead.send(JSON.parse(content));
}

function handleFileSelect(evt) {
  evt.stopPropagation();
  evt.preventDefault();

  var files = evt.dataTransfer.files; // FileList object.

  // files is a FileList of File objects. List some properties.
  var output = [];
  var reader;
  for (var i = 0, f; f = files[i]; i++) {
    reader = new FileReader();
    reader.readAsText(f, 'UTF-8');
    reader.onload = handleFileRead;
  }

  fileDropZoneDiv.classList.add('no-display');
}

var fileDropZoneDiv;

app.ports.loadFile.subscribe(function() {
  if (!fileDropZoneDiv) {
    fileDropZoneDiv = document.createElement('div');
    const textDiv = document.createElement('div');
    const textNode = document.createTextNode('Drop file here');

    textDiv.appendChild(textNode);
    fileDropZoneDiv.appendChild(textDiv);
    document.body.appendChild(fileDropZoneDiv);

    fileDropZoneDiv.addEventListener('dragover', handleDragOver, false);
    fileDropZoneDiv.addEventListener('drop', handleFileSelect, false);
    fileDropZoneDiv.classList.add('full-screen');
    fileDropZoneDiv.classList.add('file-drop-zone');
  }

  fileDropZoneDiv.classList.remove('no-display');
});
