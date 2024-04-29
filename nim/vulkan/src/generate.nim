# @deps std
from std/strformat import `&`
# @deps ndk
import confy

info "Generating Vulkan bindings ..."

#_______________________________________
# Configure the Generator Buildsystem
confy.cfg.nim.systemBin = off
let genDir  = cfg.rootDir/"gen"
let genFile = genDir/"result.nim"
let srcDir  = cfg.srcDir
let trgFile = generate.srcDir/"vulkan.nim"

#_______________________________________
# Install Opir if it doesn't exist
import confy/builder/nim as cc
let opir = getEnv("HOME").Path/".local"/"bin"/"opir"
if not fileExists(opir):
  info &"Opir does not exist at {opir.parentDir()}"
  info "Installing Futhark and Opir ..."
  withDir libDir/"futhark": sh &"{cc.getRealNimble()} install"
  ln getEnv("HOME").Path/".nimble"/"bin"/"opir", opir
  info "Done installing Futhark and Opir."

#_______________________________________
# Build the generator
info "Generating Vulkan bindings with Futhark ..."
cfg.srcDir = genDir
build Program.new(
  src  = cfg.srcDir/"generator.nim",
  deps = Dependencies.new(
    submodule( "futhark",      "https://github.com/PMunch/futhark"      ),
    submodule( "libclang-nim", "https://github.com/PMunch/libclang-nim" ),
    submodule( "termstyle",    "https://github.com/PMunch/termstyle"    ),
    submodule( "macroutils",   "https://github.com/PMunch/macroutils"   ),
    submodule( "nimbleutils",  "https://github.com/PMunch/nimbleutils"  ),
    ), # << Dependencies.new( ... )
  args = "--maxLoopIterationsVM:100_000_000 -d:futharkRebuild -d:nodeclguards",
  ) # << Program.new( ... )
info "Done generating Vulkan bindings with Futhark."

#_______________________________________
# Move the generated output
cfg.srcDir = generate.srcDir
info &"Outputting the resulting bindings into:  {trgFile}"
cp genFile, trgFile
info "Done generating Vulkan bindings."

