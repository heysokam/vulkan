#!/bin/sh
# Project Setup
rootDir=$(pwd)
binDir=$rootDir/bin
srcDir=$rootDir/zig
shdDir=$srcDir/shd
cacheDir=$binDir/.cache/zig
Z=$binDir/.zig/zig
run() { $Z run --cache-dir $cacheDir --global-cache-dir $cacheDir $@; }

vkRoot=$rootDir/zig/lib/vulkan
vkBin=$vkRoot/zig-out
vkSpecDir=$vkBin/spec
xml=$vkSpecDir/xml/vk.xml

bindings=$vkRoot/vk.zig
generateBindings() {
  prev=$(pwd)
  cd $vkRoot
  git clone https://github.com/KhronosGroup/Vulkan-Docs $vkSpecDir &> /dev/null
  $Z build
  $vkBin/bin/vulkan-zig-generator $xml $bindings
  cd $prev
}
compileShader() {
  src="$shdDir/$1"
  trg="$shdDir/$1.spv"
  echo "Compiling shader:  $src  into  $trg"
  glslc --target-env=vulkan1.2 -o $trg $src;
}
compileShaders() {
  mkdir -p $shdDir
  compileShader tri.vert
  compileShader tri.frag
}

# Compile Options
entry="$rootDir/zig/triangle.zig"
libs="-lglfw -lvulkan"


# Order to build
clear
generateBindings                       # Generate the Vulkan Zig Bindings
compileShaders                         # Compile all shaders of the app
run -femit-bin=./bin/tri $libs $entry  # Compile the app

