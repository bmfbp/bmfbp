return function (partId, send, release) {
  var tempDir = null;

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

      case 'intermediate code':
        if (tempDir === null) {
          console.error(new Error('Temporary directory not defiend'));
        }

        const intermediate = packet();
        const output = [
          kernelMinified,
          // TODO: To add `intermediate.composites` and `intermediate.leaves`
        ];

        send(partId, 'javascript source code', output.join());
        break;
    }
  };
};

const kernelMinified = 'function bmfbp(n,t){function r(n,t){return{part:n,pin:t}}function e(n,t,r){return{packet:n,from:t,pin:r}}function i(t){if(t instanceof Function)return t;if(t.hasOwnProperty("wireCount")&&t.hasOwnProperty("parts"))return function(t){const o=new Array(t.parts.length),f=new Array(t.parts.length),u=new Array(t.wireCount),a=new Array(t.parts.length),p=new Array(t.parts.length),s=[],h=t.self.inPins,l=t.self.outPins,c=new Array(t.wireCount),g=new Array(t.parts.length);var w,y,P,A,m,k,v,C,T=null,b=!1,x=null;function z(n,t,r){p[n].push(e(r,n,t))}function O(n,t){var r,e,i,o,f,p;for(r=0,e=n.length;r<e;r++){for(f=n[r],i=0,o=c[f].length;i<o;i++)T(c[f][i],t.packet),b=!0;for(i=0,o=u[f].length;i<o;i++)p=u[f][i],s.push(p.part),a[p.part].push({pin:p.pin,packet:t.packet})}}function d(n){var t;const r=p[n];for(;r.length>0;)t=r.shift(),O(g[t.from][t.pin],t);setTimeout(E,0)}function E(){for(var n,t,r;s.length>0;){for(n=s.shift(),t=a[n];t.length>0;)r=t.pop(),f[n](r.pin,r.packet);d(n)}b&&x()}for(w=0,y=c.length;w<y;w++)c[w]=[];for(w=0,y=u.length;w<y;w++)u[w]=[];for(w=0,y=o.length;w<y;w++)g[w]=t.parts[w].outPins;for(w=0,y=l.length;w<y;w++)for(P=0,A=l[w].length;P<A;P++)c[l[w][P]].push(w);for(w=0,y=t.parts.length;w<y;w++){for(v=t.parts[w],o[w]=v,a[w]=[],p[w]=[],P=0,A=v.inPins.length;P<A;P++)for(m=0,k=(C=v.inPins[P]).length;m<k;m++)u[C[m]].push(new r(w,P));initializer=i(n[v.exec]),f[w]=initializer(w,z,d)}return function(n,t,r){return T=function(r,e){t(n,r,e)},x=function(){r(n)},setTimeout(E,0),function(n,t){const r=h[n];r&&O(r,e(t)),setTimeout(E,0)}}}(t);throw new Error("Unexpected Part")}i(n[t])(0)}';
