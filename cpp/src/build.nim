#:__________________________________________________________________
#  vk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
import confy

cfg.verbose = on

let libs = @["-lglfw"].toLD

var vkp = Program.new(
  src   = srcDir.glob(".cpp"),
  trg   = "vkp",
  flags = allPP & libs,
  )
vkp.build( run=on, force=on )

