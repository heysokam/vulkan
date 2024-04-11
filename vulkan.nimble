#:_________________________________________________________
#  vulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:_________________________________________________________
# Package Information
packageName   = "vulkan"
version       = "0.0.0"
author        = "Ivan Mar (sOkam!)"
description   = "Vulkan All-the-Things"
license       = "LGPL-3.0-or-later"

# Nim Project Setup
installExt    = @["nim"]
srcDir        = "nim"
binDir        = "bin"
# Nim Requirements
requires "nim >= 2.0.0"
requires "https://github.com/heysokam/nsys#head"
