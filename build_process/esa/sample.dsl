% top level declaratsion
type name  % no-op - should enable type-checking at compile time
situations
classes
when
script

% bodies of scripts
let
map
exit-map
set
create
if then end if
if then else end if
loop end loop
>> expr
@script-call
method-call

type name
type name2
situation running

class fake-class
  field-a
  field-b
end class

when running fake-class
  script script1
  script install-pin(name)
  script install-xxx(name name2) >> boolean
  script install-yyy(name name2) >> fake-class
  method method1
  method minstall-pin(name)
  method minstall-xxx(name name2) >> boolean
  method minstall-yyy(name name2) >> fake-class
end when

script fake-class install-yyy(x y) >> boolean
  let xx = x in
    mapy y y = y in
    end map
    mapy y y = y in
      exit-map
    end map
  end let
  set a = x
  create b = fake-class in
  if @install-xxx(a b) then
    @self.install-pin(a)
    self.minstall(b)
  end if
  if @install-xxx(a b) then
    @self.install-pin(a)
  else
    if @install-yyy(a b) then
      self.minstall(b)
    end if
  end if
  end create
  loop
    exit-when self.method1
  end loop
  >> true
  >> false
end when
