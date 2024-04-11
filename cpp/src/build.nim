#:__________________________________________________________________
#  vk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
import confy

#___________________
# Confy config
cfg.verbose = on


#___________________
# Folders
let libDir = srcDir/"lib"
let cdkDir = libDir/"cendk"
#___________________
# Source Code
let cdkSrc = @[
  cdkDir/"std.cpp",
  cdkDir/"opts.cpp",
  cdkDir/"vk.cpp",
  cdkDir/"system.cpp",
  ].toDirFile()
let vkpSrc = srcDir.glob(".cpp") & cdkSrc
#___________________
# Flags
let libs   = @["-lglfw", "-lvulkan"].toLD
#___________________
# Target
var vkp = Program.new(
  src   = vkpSrc,
  trg   = "vkp",
  flags = allPP & libs,
  )
vkp.build( run=on, force=on  )

