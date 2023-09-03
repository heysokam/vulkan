#:__________________________________________________________________
#  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
#:__________________________________________________________________
import std/[ os,strformat ]
# confy dependencies
from confy/nims as run import nil
from confy/cfg  as cfg import nil

#___________________
# Package
packageName   = "cvk"
version       = "0.0.2"
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
task confy, "Runs the confy buildsystem.": run.confy()
# Extra local tasks if they exist
when fileExists("./local.nim"): include ./local

#________________________________________
# Internal Tasks
#___________________
task push, "Internal:  Pushes the git repository, and orders to create a new git tag for the package, using the latest version.":
  ## Does nothing when local and remote versions are the same.
  requires "https://github.com/beef331/graffiti.git"
  exec "git push"  # Requires local auth
  exec &"graffiti ./{packageName}.nimble"

