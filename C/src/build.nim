#:__________________________________________________________________
#  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
#:__________________________________________________________________
import std/os
import std/strformat
import std/strutils
import confy except `/`

#______________________________
# Confy custom configuration  #|
confy.cfg.prefix  = "cvk: "   #|
confy.cfg.tab     = "   : "   #|
confy.cfg.quiet   = off       #|
confy.cfg.verbose = off       #|
#_____________________________#|
let forceClean    = on


#_______________________________________
# Library Folders Config
#___________________
let libDir  = srcDir/"lib"
let cdkDir  = srcDir/"cdk"
let elemDir = srcDir/"element"


#_______________________________________
# glfw Static
#___________________
# Configuration
let glfwDir    = libDir/"glfw"
let glfwStatic = "libglfw3_static.a"
let glfwTrgDir = glfwDir/"build"/"src"
let glfwBin    = glfwTrgDir/glfwStatic
let glfwRename = [glfwTrgDir/"libglfw3.a", glfwBin]
let glfwLibs   = @[&"-L{glfwTrgDir}", "-lglfw3_static"]
#___________________
# Task
template glfw *() :void=
  log "Starting to build GLFW static..."
  sh "cd $1; cmake -S . -B ./build; cd ./build; make glfw" % [glfwDir]
  copyFile( glfwRename[0], glfwRename[1] )
  log "Finished building GLFW."

#_______________________________________
# Cendk and Entry Point
#___________________
let srcCore = @[ srcDir/"entry.c" ]
let srcCdk  = @[
  cdkDir/"std.c",
  cdkDir/"opts.c",
  cdkDir/"input.c",
  elemDir/"window.c",
  ] # << srcCdk
let cdkLibs = @["-lvulkan"]
var bin = Program.new(
  src   = srcCore & srcCdk,
  trg   = "currentExample",
  flags = allC & glfwLibs.toLD & cdkLibs.toLD,
)

when isMainModule:
  glfw()
  bin.build( force=forceClean )
