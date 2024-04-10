//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// z*dk dependencies
const zstd = @import("./zstd.zig");
const zsys = @import("./zsys/core.zig");
const zvk  = @import("./zvk/core.zig");

pub fn main() !void {
  try zstd.echo("Hello zig.GLFW");
  var sys = zsys.init(960,540,"Hello z*Sys");
  var gpu = zvk.init();
  while (!sys.close()) {
    sys.update();
    gpu.update();
    }
  gpu.term();
  sys.term();
}

