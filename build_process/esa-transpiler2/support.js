function memoType(name) {
    let namelist = scopeGet('typememos');
    namelist.push(name);
    scopeModify('typememos',namelist);
    return "";
}

function existenceChecks() {
    let namelist = scopeGet('typememos');
    return namelist.map(n => {
	return `(stack-dsl::%ensure-existence '${n})\n`;
    }).join('');
}

