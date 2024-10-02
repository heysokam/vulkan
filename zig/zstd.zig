//:___________________________________________________________________
//  zstd  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:___________________________________________________________________
// @deps std
const std  = @import("std");

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

