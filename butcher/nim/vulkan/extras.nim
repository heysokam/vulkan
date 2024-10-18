#:_________________________________________________________
#  vulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:_________________________________________________________


template vaddr *(val :auto) :untyped=
  ## @descr Returns the `addr` of anything, through a temp val.
  ## @note Useful when the objects have not been created yet.
  let temp = val; temp.unsafeAddr
#___________________
proc `as` *[T1, T2](val :T1; typ :typedesc[T2]) :T2 {.inline.}=  cast[T2](val)
  ## @descr Casts the contents of {@arg val} to the given {@arg typ}
  ## @reason Syntax ergonomics


func makeApiVersion *(v,M,m,p :SomeInteger) :uint32 {.inline.}=  uint32 (v shl 29) or (M shl 22) or (m shl 12) or (p)
func makeVersion *(M,m,p :SomeInteger) :uint32 {.inline.}=  extras.makeApiVersion(0, M,m,p)

