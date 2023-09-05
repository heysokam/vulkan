#:__________________________________________________________________
#  vk+  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
import std/[ os,strformat ]
from confy/cfg  as cfg import nil
from confy/nims as run import nil

#_____________________________
# Package
packageName   = "vkp"
version       = "0.0.2"
author        = "sOkam"
description   = "vk+ | Vulkan C++ API"
license       = "GPL-3.0-or-later"
let gitURL    = &"https://github.com/heysokam/{packageName}"

#_____________________________
# Build Requirements
requires "nim >= 2.0.0"
requires "https://github.com/heysokam/confy#head"

#___________________
# Confy Build task
task confy, "Builds the current nim project using confy.": run.confy()

#_____________________________
# Folders
srcDir          = cfg.srcDir
binDir          = cfg.binDir
installExt      = @["nim"]
let cacheDir    = binDir/"nimcache"
let docDir      = "doc"
let testsDir    = "tests"
let examplesDir = "examples"

#_____________________________
# Binaries
bin = @["build"]

#________________________________________
# Helpers
#___________________
const vlevel = when defined(debug): 2 else: 1
const mode   = when defined(debug): "-d:debug" elif defined(release): "-d:release" elif defined(danger): "-d:danger" else: ""
let nimcr = &"nim c -r --verbosity:{vlevel} {mode} --hint:Conf:off --hint:Link:off --hint:Exec:off --nimcache:{cacheDir} --outdir:{binDir}"
  ## Compile and run, outputting to binDir
proc runFile (file, dir, args :string) :void=  exec &"{nimcr} {dir/file} {args}"
  ## Runs file from the given dir, using the nimcr command, and passing it the given args
proc runFile (file :string) :void=  file.runFile( "", "" )
  ## Runs file using the nimcr command
proc runTest (file :string) :void=  file.runFile(testsDir, "")
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder
proc runExample (file :string) :void=  file.runFile(examplesDir, "")
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder
template example (name :untyped; descr,file :static string)=
  ## Generates a task to build+run the given example
  let sname = astToStr(name)  # string name
  taskRequires sname, "SomePackage__123"  ## Doc
  task name, descr:
    runExample file


#_________________________________________________
# Tasks: Internal
#___________________
task push, "Internal:  Pushes the git repository, and orders to create a new git tag for the package, using the latest version.":
  ## Does nothing when local and remote versions are the same.
  requires "https://github.com/beef331/graffiti.git"
  exec "git push"  # Requires local auth
  exec "graffiti ./{packageName}.nimble"
#___________________
task tests, "Internal:  Builds and runs all tests in the testsDir folder.":
  requires "pretty"
  for file in testsDir.listFiles():
    if file.lastPathPart.startsWith('t'):
      try: runFile file
      except: echo &" └─ Failed to run one of the tests from  {file}"
#___________________
task docgen, "Internal:  Generates documentation using Nim's docgen tools.":
  echo &"{packageName}: Starting docgen..."
  exec &"nim doc --project --index:on --git.url:{gitURL} --outdir:{docDir}/gen src/{packageName}.nim"
  echo &"{packageName}: Done with docgen."

