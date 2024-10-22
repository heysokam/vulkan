#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
{.passL:"-lvulkan".}
import ./nvulkan/result as vk_result ; export vk_result
import ./nvulkan/allocator           ; export allocator
import ./nvulkan/version             ; export version
import ./nvulkan/strings             ; export strings
import ./nvulkan/extensions          ; export extensions
import ./nvulkan/debug               ; export debug
# import ./nvulkan/validation  ; export validation
import ./nvulkan/application         ; export application
import ./nvulkan/instance            ; export instance

#_______________________________________
# @section n*std Duplicates
#_____________________________
template vaddr *(val :auto) :untyped=
  ## @descr
  ##  Returns the `addr` of anything, through a temp val.
  ##  Useful when the objects have not been created yet.
  let temp = val; temp.addr

