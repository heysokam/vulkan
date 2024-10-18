//:___________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
// @deps std
const std     = @import("std");
const builtin = @import("builtin");
//______________________________________
// @section Operating System Aliases
//____________________________
pub const linux = builtin.os.tag == .linux;
pub const win   = builtin.os.tag == .windows;
pub const macos = builtin.os.tag.isDarwin();

//______________________________________
// @section Compile Mode Aliases
//____________________________
pub const debug = builtin.mode == std.builtin.OptimizeMode.Debug;
pub const safe  = std.debug.runtime_safety;


//______________________________________
// @section Type Aliases
//____________________________
pub const cstr = []const u8;

//______________________________________
// @section Logging
//____________________________
pub fn echo(msg :cstr) !void {
  // stdout for the output of the app, not for debugging messages.
  const stdout_file = std.io.getStdOut().writer();
  var bw = std.io.bufferedWriter(stdout_file);
  const stdout = bw.writer();
  try stdout.print("{s}\n", .{msg});
  try bw.flush();
}

