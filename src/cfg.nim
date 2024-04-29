#:____________________________________________________________________
#  vulkan |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:____________________________________________________________________
# @deps ndk
from confy import `/`
# @deps build
import ./types


var C * = ProjectDirs(rootDir: confy.cfg.rootDir/"C")
C.srcDir = C.rootDir/"src"
C.binDir = C.rootDir/"bin"

var nim * = ProjectDirs(rootDir: confy.cfg.rootDir/"nim")
nim.srcDir = nim.rootDir/"src"
nim.binDir = nim.rootDir/"bin"

var zig * = ProjectDirs(rootDir: confy.cfg.rootDir/"zig")
zig.srcDir = zig.rootDir/"src"
zig.binDir = zig.rootDir/"bin"

var cpp * = ProjectDirs(rootDir: confy.cfg.rootDir/"cpp")
cpp.srcDir = cpp.rootDir/"src"
cpp.binDir = cpp.rootDir/"bin"

var rust * = ProjectDirs(rootDir: confy.cfg.rootDir/"rust")
rust.srcDir = rust.rootDir/"src"
rust.binDir = rust.rootDir/"bin"

