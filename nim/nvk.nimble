# Package
packageName   = "nvk"
version       = "0.0.0"
author        = "sOkam"
description   = "n*vk | Vulkan API for Nim"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @[packageName]
# Dependencies
requires "nim >= 2.0.0"
requires "https://github.com/heysokam/nsys#head"
