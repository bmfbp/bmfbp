expression.ekind = 'object'

  {object
    .name = "self"

    {fieldMap
    fieldMap}

    .object = ^
  object}
  
expression.object = pop(output-object)


{ expression
  { ekind
    'object'
  } -> .ekind
  { object
    { name
      GetName
    } -> .name
    { fieldMap
      { field
        { name
	  GetName
	} -> .name
        { parameterList
	} -> .parameterList
      } +
    {} +
    } -> .fieldMap
  } -> .object
} expression

1. 
{ expression
}

2.
{ expression
  {} -> .ekind
  {} -> .object
}

3.
{ expression
  { ekind 'object' } -> .ekind
  { object {} -> .name {} -> .fieldMap } -> .object
}

4.
{ expression
  { ekind 'object' } -> .ekind
  { object 
    { name GetName } -> .name
    { fieldMap
      {} +
      {} +
    } -> .fieldMap
  } -> .object
}

5.
{ expression
  { ekind 'object' } -> .ekind
  { object 
    { name GetName } -> .name
    { fieldMap
      { field } +
      { field } +
    } -> .fieldMap
  } -> .object
}

6.
{ expression
  { ekind 'object' } -> .ekind
  { object 
    { name GetName } -> .name
    { fieldMap
      { field   {} -> .name   {} -> .parameterList } +
      { field   {} -> .name   {} -> .parameterList } +
    } -> .fieldMap
  } -> .object
}

7.
{ expression
  { ekind 'object' } -> .ekind
  { object 
    { name GetName } -> .name
    { fieldMap
      { field   { name GetName }-> .name   { nameMap {}= } -> .parameterList } +
      { field   { name         }-> .name   { nameMap {}= } -> .parameterList } +
    } -> .fieldMap
  } -> .object
}

8.
{ expression
  { ekind 'object' } -> .ekind
  { object 
    { name GetName } -> .name
    { fieldMap
      { field   { name GetName } -> .name   { nameMap {}+ } -> .parameterList } +
      { field   { name         } -> .name   { nameMap     } -> .parameterList } +
    } -> .fieldMap
  } -> .object
}

9.
{ expression
  { ekind 'object' } -> .ekind
  { object 
    { name GetName } -> .name
    { fieldMap
      { field   { name GetName } -> .name   { nameMap { name GetName }+ } -> .parameterList } +
      { field   { name         } -> .name   { nameMap                   } -> .parameterList } +
    } -> .fieldMap
  } -> .object
}

%% add [] notation to make scope types stand out (should that be an underline?)
10.
{ [expression]
  { [ekind] 'object' } -> .ekind
  { [object] 
    { [name] GetName } -> .name
    { [fieldMap]
      { [field]   { [name] GetName } -> .name   { [nameMap] { [name] GetName }+ } -> .parameterList } +
      { [field]   { [name]         } -> .name   { [nameMap]                     } -> .parameterList } +
    } -> .fieldMap
  } -> .object
}

11. add newlines (for my readability)
{ [expression]
  { [ekind]
    'object'
  }
  -> .ekind
  { [object] 
    { [name]
      GetName
    }
    -> .name
    { [fieldMap]
      { [field]
        { [name]
	  GetName
	}
	-> .name
       { [nameMap]
         { [name]
	   GetName
	 }+
       }
       -> .parameterList
       } +
      { [field]
        { [name]
        } -> .name
	{ [nameMap]
        }
	-> .parameterList
	} +
    } 
    -> .fieldmap
  } 
  -> .object
}

12-15 replacements
{[xxx]  -> $xxx__Newscope
}       -> $xxx_Output
-> .yyy -> $yyy_SetField_yyy_from_yyy
+       -> $xxx__AppendFrom_yyy

12.
{[xxx]  -> $xxx__Newscope




