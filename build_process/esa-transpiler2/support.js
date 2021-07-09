function memotype(name) {
    let namelist = scopeGet('typememos');
    namelist.add(name);
    scopeModify('typememos',namelist);
    return "";
}

function existenceChecks() {
    let namelist = scopeGet('typememos');
    let a = [];
    namelist.forEach(n => a.push (`(stack-dsl::%ensure-existence '${n})\n`));
    return a.join('');
}

function boilerplate () {
    return `(defclass %map-stack (stack-dsl::%typed-stack) ())
(defclass %bag-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self %map-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "%map"))(defmethod initialize-instance :after ((self %bag-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "%bag"))`;
}

// function makestacks() {
//     return "*** makestacks ***";
// }

function makestacks() {
    let namelist = scopeGet('typememos');
    let a = [];

    namelist.forEach(n => { a.push (`(input-${n} :accessor input-${n} :initform (make-instance '${n}))
(output-${n} :accessor output-${n} :initform (make-instance '${n}))
`); });

    return `
(defclass environment ()
((%water-mark :accessor %water-mark :initform nil)
${a.join('')}))`;
}
    
function liststacks() {
    let namelist = scopeGet('typememos');
    let a = [];

    namelist.forEach(n => { a.push (`input-${n}
output-${n}
`); });

    return `
(defparameter *stacks* '(
${a.join('')}
))`;
}

function memostacks() {
    let namelist = scopeGet('typememos');
    let a = [];

    namelist.forEach(n => { a.push (
`(stack-dsl::%stack (input-${n} self))
(stack-dsl::%stack (output-${n} self))
`); });

    return `
(defmethod %memoStacks ((self environment))
(setf (%water-mark self)
(list
${a.join('')}
)))
`;
}


function memoCheck () {
    let namelist = scopeGet('typememos');
    let a = [];
    let counter = 0;

    namelist.forEach(n => { a.push (`
(let ((in-eq (eq (nth ${counter} wm) (stack-dsl::%stack (input-${n} self))))
      (out-eq (eq (nth ${counter+1} wm) (stack-dsl::%stack (output-${n} self)))))
  (and in-eq out-eq))`);
      counter += 2;			    
			  });

return `
(defmethod %memoCheck ((self environment))
 (let ((wm (%water-mark self)))
  (let ((r (and
	   ${a.join('')})))
   (unless r (error "stack depth incorrect")))))`;
}
