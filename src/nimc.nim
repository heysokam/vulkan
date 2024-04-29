#:____________________________________________________________________
#  vulkan |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:____________________________________________________________________
# @deps build
import ./cfg as all
# @deps ndk
import confy
import nstd/opts as cli
# @deps build
import ./types


#_______________________________________
# @section Buildsystem Control Passthrough
#_____________________________
let args = cli.getArgs()
let keyw = if args.len < 1 : "build" else: args[0]
withDir all.nim.rootDir: sh "spry "&keyw
