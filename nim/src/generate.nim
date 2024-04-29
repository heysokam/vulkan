# @deps ndk
import nstd/paths
import nstd/strings
import confy

info "Generating Vulkan bindings ..."

#_______________________________________
# @section Configure the Buildsystem
#_____________________________
# Confy cfg
confy.cfg.nim.systemBin = off
confy.cfg.libDir        = cfg.binDir/".lib"
# Generator Cfg
let srcDir  = cfg.srcDir
let genDir  = cfg.srcDir/"gen"
let genFile = genDir/"result.nim"
let trgDir  = cfg.rootDir/"vulkan"
let trgFile = trgDir/"api.nim"


#_______________________________________
# @section Opir
#_____________________________
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
# @section Build the generator
#_____________________________
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
# @section Move the generated output
#_____________________________
cfg.srcDir = generate.srcDir
info &"Outputting the resulting bindings into:  {trgFile}"
cp genFile, trgFile
info "Done generating Vulkan bindings."

