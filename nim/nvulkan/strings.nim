#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
from ./base as vk import nil

#_______________________________________
# @section String tools
#_____________________________
type String * = vk.String
proc `$` *(s :String) :string {.borrow.}


#_______________________________________
# @section String List tools
#_____________________________
type StringList * = distinct cstringArray

proc new *(_:typedesc[StringList]; list :openArray[string]) :StringList=
  allocCstringArray(list).StringList

proc `=destroy` *(arr :StringList) :void=
  deallocCstringArray(arr.cstringArray)

