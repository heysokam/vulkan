#:___________________________________________________
#  nvk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
import std/[ os,strformat ]
# Package
packageName   = "nvk"
version       = "0.0.1"
author        = "sOkam"
description   = "n*vk | Vulkan API for Nim"
license       = "MIT"
installExt    = @["nim"]
srcDir        = "src"
binDir        = "bin"
let cacheDir  = binDir/"cache"
bin           = @[packageName]
# Dependencies
requires "nim >= 2.0.0"
requires "https://github.com/heysokam/nsys#head"
requires "https://github.com/DanielBelmes/vulkan#head"
requires "zigcc"
