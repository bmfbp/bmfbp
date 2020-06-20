
type name
type function
type boolean
type node-class

situation building
situation building-aux
situation loading
situation initializing
situation running

class part-definition
  part-name
  part-kind
end class


when building part-definition
  method ensure-kind-defined	
  script eeee
  method m2
  script b
  script c
  script ddd
  script fff
  script ggg
  script hhh
  script iii
  script jjj
  script a
end when

script part-definition a
  x
  x.y
  x.y.z
  @x.y(d e).z(a b c)
  w.u(f g).z(h i j)
  let z = b in 
    @x.y(d e).z(a b c)
    w.u(f g).z(h i j)
  end let

  map z = b in 
    @x.y(d e).z(a b c)
    w.u(f g).z(h i j)
  end map

  set p = q

  create k = l in 
    @x.y(d e).z(a b c)
    w.u(f g).z(h i j)
  end create

  create h = *j in 
    @x.y(d e).z(a b c)
    w.u(f g).z(h i j)
  end create


  >> true
  >> false
  >> x
  
  loop
    x
    @y
    exit-when z
  end loop


  if w then
    @u
  else
    @v
  end if

  if x then
    @y
  end if

end script
