#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps C Vulkan
{.pragma: vulkan, header:"vulkan/vulkan.h".}

#_______________________________________
# @section String
#_____________________________
type CStringImpl {.importc: "const char*".} = cstring
type String * = distinct CStringImpl
  ## @descr True Cstring Implementation. Maps to a `const char*` in codegen

#_______________________________________
# @section General Types
#_____________________________
type Instance  *{.importc:"VkInstance", vulkan.}= ptr object

#_______________________________________
# @section Fn Request
#_____________________________
type VoidFn *{.importc:"PFN_vkVoidFunction", vulkan.}= proc () :void {.cdecl.}
proc getProc *(
    instance : Instance;
    pName    : String;
  ) :VoidFn {.importc:"vkGetInstanceProcAddr", vulkan.}

