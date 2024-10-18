#:___________________________________________________
#  nvk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
# Cable connector to all modules
import ./nvk/vulkan   ; export vulkan
import ./nvk/core     ; export core
import ./nvk/types    ; export types
import ./nvk/elements ; export elements
#_______________________________________


#_______________________________________
# Entry Point of the debug example
when isMainModule:
  import nsys
  import ./nvk/core as nvk
  echo"hello n*vk"
  var sys = nsys.init(960,540)
  var gpu = nvk.init()
  while not sys.close():
    sys.update()
    gpu.update()
  gpu.term()
  sys.term()
