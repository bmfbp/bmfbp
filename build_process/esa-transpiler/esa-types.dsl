esaprogram = { typeDecls situations classes scripts }

typeDecls = :map typeDecl
situation = :map situation
classes = :map esaclass
scripts = :map script

typeDecl = { name typeName }
typeName = name
