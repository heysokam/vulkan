#:__________________________________________________________________
#  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
#:__________________________________________________________________
# confy dependencies
from confy/nims as run import nil
from confy/cfg  as cfg import nil

#___________________
# Package
packageName   = "cvk"
version       = "0.0.0"
author        = "sOkam"
description   = "c*vk | Ergonomic C Vulkan API"
license       = "GPL-3.0-or-later"

#___________________
# Dependencies
requires "nim >= 2.0.0"
requires "https://github.com/heysokam/confy#head"

#___________________
# Folders
srcDir          = cfg.srcDir
binDir          = cfg.binDir
let docDir      = cfg.docDir
let examplesDir = "examples"


#___________________
# Buildsystem
before confy: echo packageName,": Building ",description," | v",version
after  confy: echo packageName,": Done building."
task   confy, "Runs the confy buildsystem.": run.confy()
# Extra local tasks if they exist
when fileExists("./local.nim"): include ./local
