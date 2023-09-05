#:___________________________________________________________________
#  vk++  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:___________________________________________________________________
import confy

cfg.verbose = on

var bin = Program.new(srcDir.glob(".cpp"), "vkp")
bin.build( run=on, force=on )

