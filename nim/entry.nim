#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
import nsys

when isMainModule:
  echo "Hello nvk Entry"
  var sys = nsys.init(960,540)
  while not sys.close(): sys.update()
  sys.term()

