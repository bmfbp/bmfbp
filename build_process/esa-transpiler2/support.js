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
    
