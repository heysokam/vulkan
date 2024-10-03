const std = @import("std");

const vkgen = @import("vulkan_zig");
const glslc = .{ "glslc", "--target-env=vulkan1.2", "-o" };

pub fn build(b: *std.Build) void {
  // CLI Options
  const syst  = b.standardTargetOptions(.{});
  const optim = b.standardOptimizeOption(.{});
  const spec  = b.option([]const u8, "override-spec", "Override the path to the Vulkan spec registry");
  // Dependencies
  const xml   = b.dependency("vulkan_headers", .{}).path("registry/vk.xml");
  const gen   = b.dependency("vulkan_zig", .{}).artifact("vulkan-zig-generator");
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

  // Vulkan Bindings Generator
  const gen_cmd = b.addRunArtifact(gen);
  if (spec) | dir | gen_cmd.addFileArg(.{ .cwd_relative= dir })
  else              gen_cmd.addFileArg(xml);
  bin.root_module.addAnonymousImport("vulkan", .{
    .root_source_file = gen_cmd.addOutputFileArg("vk.zig"),
  });

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

