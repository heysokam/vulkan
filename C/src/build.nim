#:__________________________________________________________________
#  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
import std/os except `/`
import std/strformat
import std/strutils
when not defined(nimble) : import ../../../../ndk/confy/src/confy
else                     : import confy

#______________________________
# Confy custom configuration  #|
confy.cfg.prefix  = "cvk: "   #|
confy.cfg.tab     = "   : "   #|
confy.cfg.quiet   = on        #|
confy.cfg.verbose = off       #|
#_____________________________#|
let forceClean    = on
const debug = not (defined(release) or defined(danger)) or on


#_______________________________________
# Library Folders Config
#___________________
let libDir  = srcDir/"lib"
let cdkDir  = srcDir/"cdk"
let vkDir   = srcDir/"vulkan"
let elemDir = vkDir/"element"

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
  sh &"cd {glfwDir}; cmake -S . -B ./build; cd ./build; make glfw"
  copyFile( glfwRename[0], glfwRename[1] )
  log "Finished building GLFW."

#_______________________________________
# cdk and Entry Point
#___________________
let srcCore  = srcDir.glob
let srcVk    = vkDir.glob & elemDir.glob
let srcCdk   = cdkDir.glob
let cdkLibs  = @["-lvulkan"]
let cdkDebug = when debug: @["-DDEBUG"] else: @[""]
var bin = Program.new(
  src   = srcCore & srcCdk & srcVk,
  trg   = "currentExample",
  flags = allC & glfwLibs.toLD & cdkLibs.toLD & cdkDebug.toCC,
)

when isMainModule:
  glfw()
  bin.build( @["all"], run=on, force=forceClean )
