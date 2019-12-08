function windowHasResized() {
  app.ports.viewPortHasResized.send([window.innerWidth, window.innerHeight]);
}

window.addEventListener('resize', windowHasResized);
window.addEventListener('load', windowHasResized);
