app.ports.saveFile.subscribe(function(data) {
  const filetype = 'text/plain;charset=utf-8';
  const filename = 'diagram.json';
  const output = JSON.stringify(data);
  saveAs(new Blob([output], { type: filetype }), filename);
});
