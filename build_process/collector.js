return function (partId, send, release) {
  var composites = [];
  var leaves = [];

  return function (pin, packet) {
    switch (pin) {
      case 'composite':
        composites.push(packet());
        break;

      case 'leaf':
        leaves.push(packet());
        break;

      case 'done':
        send(partId, 'intermediate code', {
          composites: composites,
          leaves: leaves
        });
        composites = [];
        leaves = [];
        break;
    }
  };
};
