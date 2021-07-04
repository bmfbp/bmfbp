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

function makestacks() {
    return "*** makestacks ***";
}

// function old-makestacks() {
//     let namelist = scopeGet('typememos');
//     let a = [];
//     namelist.forEach(n => a.push (
// `
// (input-${a} :accessor input-${a} :initform (make-instance '${a})
// (output-${a} :accessor output-${a} :initform (make-instance '${a})
// `
//     ));
//     return `
// (defclass environment ()
// ((%water-mark :accessor %water-mark :initform nil)
// ${a.join('')}))`;
// }
    
