#!/bin/sh
# Project Setup
rootDir=$(pwd)
binDir=$rootDir/bin
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

# Compile Options
entry="$rootDir/zig/triangle.zig"
libs="-lglfw -lvulkan"


# Order to build
clear
generateBindings                       # Generate the Vulkan Zig Bindings
run -femit-bin=./bin/zvk $libs $entry  # Compile the app

