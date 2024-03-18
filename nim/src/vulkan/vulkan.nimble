#:_________________________________________________________
#  vulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:_________________________________________________________
# Package
packageName   = "vulkan"
version       = "0.0.0"
author        = "sOkam"
description   = "Vulkan Bindings for Nim"
license       = "LGPL-3.0-or-later"
installExt    = @["nim"]
skipFiles     = @["build.nim"]
srcDir        = "src"
binDir        = "bin"
# Dependencies
requires "nim >= 2.0.0"
