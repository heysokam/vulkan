#:__________________________________________________________________
#  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# Package
packageName   = "cvk"
version       = "0.0.5"
author        = "sOkam"
description   = "c*vk | Ergonomic C Vulkan API"
license       = "GPL-3.0-or-later"
srcDir        = "src"
# Dependencies
requires "nim >= 2.0.0"
requires "https://github.com/heysokam/confy#head"
# Buildsystem
task confy, "Runs the confy buildsystem.": exec "nim -d:nimble confy.nims"

#________________________________________
# Internal Tasks
#___________________
import std/strformat
task push, "Internal:  Pushes the git repository, and orders to create a new git tag for the package, using the latest version.":
  ## Does nothing when local and remote versions are the same.
  requires "https://github.com/beef331/graffiti.git"
  exec "git push"  # Requires local auth
  exec &"graffiti ./{packageName}.nimble"

