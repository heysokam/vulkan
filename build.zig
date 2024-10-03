const std = @import("std");

const glslc = .{ "glslc", "--target-env=vulkan1.2", "-o" };

pub fn build(b: *std.Build) void {
  // CLI Options
  const syst  = b.standardTargetOptions(.{});
  const optim = b.standardOptimizeOption(.{});
  // Output Binary
  const bin = b.addExecutable(.{
    .name             = "tri",
    .root_source_file = b.path("zig/triangle.zig"),
    .target           = syst,
    .link_libc        = true,
    .optimize         = optim,
  });
  b.installArtifact(bin);
  bin.linkSystemLibrary("glfw");
  bin.linkSystemLibrary("vulkan");

  // Shaders
  // .. Vertex
  const vert_cmd = b.addSystemCommand(&glslc);
  const vert_spv = vert_cmd.addOutputFileArg("vert.spv");
  vert_cmd.addFileArg(b.path("shd/tri.vert"));
  bin.root_module.addAnonymousImport("shd_vert", .{.root_source_file = vert_spv});
  // .. Fragment
  const frag_cmd = b.addSystemCommand(&glslc);
  const frag_spv = frag_cmd.addOutputFileArg("frag.spv");
  frag_cmd.addFileArg(b.path("shd/tri.frag"));
  bin.root_module.addAnonymousImport("shd_frag", .{.root_source_file = frag_spv});

  // Run the result
  const run_cmd = b.addRunArtifact(bin);
  run_cmd.step.dependOn(b.getInstallStep());
  const run_step = b.step("run", "Run the triangle example");
  run_step.dependOn(&run_cmd.step);
}


