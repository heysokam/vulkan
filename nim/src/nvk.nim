#:___________________________________________________
#  nvk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________

when isMainModule:
  import nsys
  echo"hello n*vk"
  var sys = nsys.init(960,540)
  while not sys.close(): sys.update()
  sys.term()
