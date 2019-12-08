app.ports.saveFile.subscribe(function(data) {
  const filetype = 'text/plain;charset=utf-8';
  const filename = 'diagram.lisp';
  saveAs(new Blob([data], { type: filetype }), filename);
});
