#:___________________________________________________
#  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
import std/[ os,strformat ]
# Folders
const thisDir = currentSourcePath().parentDir()
const srcDir  = thisDir/"src"
const binDir  = thisDir/"bin"
const zigDir  = binDir/".zig"

# Zig Compiler Setup
const cc        = zigDir/"zig"
const ZcacheDir = binDir/"zcache"
const Zflags    = "-fPIE -fcompiler-rt"
const Zcache    = &"--cache-dir {ZcacheDir} --global-cache-dir {ZcacheDir}"
type TrgKind = enum Program, SharedLib, StaticLib
proc zig *(kind: TrgKind; src,trg,flags :string) :void=
  var cmd = cc
  case kind
  of Program   : cmd &= " build-exe"
  of SharedLib : cmd &= " build-lib"
  else: discard
  exec &"{cmd} {Zflags} {flags} {Zcache} -femit-bin={trg} {src}"

# Clean
# rmDir binDir; mkdir binDir
# writeFile( binDir/".gitignore", "*\n!.gitignore" )
# Build
let src   = srcDir/"zvk.zig"
let trg   = binDir/"zvk"
let flags = "-lglfw -lc -lm"
zig Program, src, trg, flags
exec trg
