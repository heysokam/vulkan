#:_________________________________________________________
#  vulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:_________________________________________________________
# @deps ndk
import confy

cfg.nim.systemBin = off
cfg.srcDir        = cfg.rootDir
cfg.libDir        = cfg.binDir/".lib"

build Program.new(
  src  = cfg.srcDir/"nvk.nim",
  deps = Dependencies.new(
    submodule( "nglfw", "https://github.com/heysokam/nglfw" ),
    submodule( "nsys",  "https://github.com/heysokam/nsys"  ),
    submodule( "nstd",  "https://github.com/heysokam/nstd"  ),
    submodule( "vmath", "https://github.com/treeform/vmath" ),
    submodule( "nmath", "https://github.com/heysokam/nmath" ),
    ) # << Dependencies.new( ... )
  ), run=true # << Program.new( ... )
