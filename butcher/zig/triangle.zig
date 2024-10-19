//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps std
const std = @import("std");
// @deps zdk
const zstd = @import("./zstd.zig");
const zsys = @import("./zsys.zig");


//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
const shd = struct {
  const vert align(@alignOf(u32)) = @embedFile("shd_vert").*;
  const frag align(@alignOf(u32)) = @embedFile("shd_frag").*;
};
const appName = "Zig | Vulkan-All-the-Things | Triangle";
var size      = zgpu.Size{.width= 960, .height= 540};

//______________________________________
// @section Entry Point
//____________________________
pub fn main () !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = zgpu.Allocator.create(arena.allocator());

  try zstd.echo("Hello z*gpu | Triangle");
  try zstd.echo(appName);
  var sys = try zsys.init(size.width, size.height, appName);
  var gpu = try zgpu.init(.{
    .appName    = appName,
    .appVers    = zgpu.version.new(0, 0, 1),
    .engineName = "z*gpu | Triangle Engine",
    .engineVers = zgpu.version.new(0, 0, 1),
    }, A);
  while (!sys.close()) {
    sys.update();
    gpu.update();
    }
  gpu.term();
  sys.term();
} //:: main



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pub const zvk = struct {
  const vk = @import("./zvulkan.zig");

  //______________________________________
  // @section General Type Aliases
  //____________________________
  pub const String  = vk.String;
  pub const Size    = vk.Size;
  pub const SpirV   = vk.SpirV;
  pub const version = vk.version;
  pub const Version = vk.Version;

  //______________________________________
  // @section Allocator
  //____________________________
  pub const Allocator = struct {
    zig  :std.mem.Allocator,
    vk   :?*const vk.Allocator,

    pub fn create (A :std.mem.Allocator) Allocator {
      return Allocator{
       .zig = A,
       .vk  = null  // @maybe Allocator library ?
        };
    } //:: zvk.Allocator.create
  }; //:: zvk.Allocator

  //______________________________________
  // @section Configuration and Defaults
  //____________________________
  pub const cfg = struct {
    // pub const features = struct {
    //   /// List of 'apis' to construct base, instance and device wrappers for vulkan-zig
    //   pub const list :[]const vk.ApiInfo = &.{
    //     .{  // Add invidiual functions by manually creating an 'api'
    //       .base_commands     = .{ .createInstance = true, },
    //       .instance_commands = .{ .createDevice   = true, },
    //       },
    //     // Add entire feature sets or extensions
    //     vk.features.version_1_0,
    //     vk.extensions.khr_surface,
    //     vk.extensions.khr_swapchain,
    //   }; //:: zvk.features.list
    // }; //:: zvk.features

    pub const default = struct {
      pub const version    = zvk.version.api.v1_0;
      pub const appName    = "zvk.Application";
      pub const appVers    = zvk.version.new(0, 0, 0);
      pub const engineName = "zvk.Engine";
      pub const engineVers = zvk.version.new(0, 0, 0);
    }; //:: zvk.cfg.default
  }; //:: zvk.cfg

  //______________________________________
  // @section Validation
  //____________________________
  pub const validation = struct {
    pub const active = if (zstd.debug) true else false;
    pub const layers = if (zvk.validation.active) .{vk.validation.LayerName} else .{};
    pub fn checkSupport (A :zvk.Allocator) !void {_=A;
      if (!zvk.validation.active) return;
      // Get the layer names
      // Check if the requested names exist in the list available layers
      search: {
        break :search;
      }
    }

  }; //:: zvk.validation

  //______________________________________
  // @section Application
  //____________________________
  pub const App = struct {
    pub const Cfg = vk.App.Cfg;
    pub fn new (args :struct {
        appName    : zvk.String  = zvk.cfg.default.appName,
        appVers    : zvk.Version = zvk.cfg.default.appVers,
        engineName : zvk.String  = zvk.cfg.default.engineName,
        engineVers : zvk.Version = zvk.cfg.default.engineVers,
      }) zvk.App.Cfg {
      return zvk.App.Cfg{
        .sType              = vk.stype.AppInfo,         // @import("std").mem.zeroes(VkStructureType),
        .pNext              = null,                     // .pNext: ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
        .pApplicationName   = args.appName.ptr,         // .pApplicationName: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
        .applicationVersion = args.appVers,             // .applicationVersion: u32 = @import("std").mem.zeroes(u32),
        .pEngineName        = args.engineName.ptr,      // .pEngineName: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
        .engineVersion      = args.engineVers,          // .engineVersion: u32 = @import("std").mem.zeroes(u32),
        .apiVersion         = zvk.cfg.default.version,  // .apiVersion: u32 = @import("std").mem.zeroes(u32),
        }; //:: VkApplicationInfo{ ... }
    } //:: zvk.App.defaults
  }; //:: zvk.App

  //______________________________________
  // @section Instance
  //____________________________
  pub const Instance = struct {
    A    :zvk.Allocator,
    ct   :vk.instance.T,
    cfg  :vk.instance.Cfg,

    const glfw = @import("./zglfw.zig");
    pub fn create (in:struct {
        appName    : zvk.String  = zvk.cfg.default.appName,
        appVers    : zvk.Version = zvk.cfg.default.appVers,
        engineName : zvk.String  = zvk.cfg.default.engineName,
        engineVers : zvk.Version = zvk.cfg.default.engineVers, },
        A          : zvk.Allocator,
      ) !zvk.Instance {
      // Get the Extensions
      var exts = try glfw.vk.instance.getExts(A.zig);
      if (zstd.macos) try exts.append(vk.extensions.PortabilityEnumeration); // Mac support with VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME : https://vulkan-tutorial.com/en/Drawing_a_triangle/Setup/Instance
      // try vk.extensions.instance.supported(exts); // TODO: vk.extensions.instance.supported
      // Get the Validation Layers
      // Generate the result
      var result = zvk.Instance{.ct= undefined,
        .A                         = A,
        .cfg                       = vk.instance.Cfg{
          .sType                   = vk.stype.InstanceInfo,            // sType: VkStructureType = @import("std").mem.zeroes(VkStructureType),
          .pNext                   = null,                             // pNext: ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
          .flags                   = vk.flags.InstanceCreate.toInt(.{  // flags: VkInstanceCreateFlags = @import("std").mem.zeroes(VkInstanceCreateFlags),
            .enumeratePortability  = if (zstd.macos) true else false,
            }), //:: flags
          .pApplicationInfo        = &zvk.App.new(.{
            .appName               = in.appName,
            .appVers               = in.appVers,
            .engineName            = in.engineName,
            .engineVers            = in.engineVers,
            }), //:: pApplicationInfo                                  // pApplicationInfo: [*c]const VkApplicationInfo = @import("std").mem.zeroes([*c]const VkApplicationInfo),
          .enabledLayerCount       = 0,                                // enabledLayerCount: u32 = @import("std").mem.zeroes(u32),
          .ppEnabledLayerNames     = null,                             // ppEnabledLayerNames: [*c]const [*c]const u8 = @import("std").mem.zeroes([*c]const [*c]const u8),
          .enabledExtensionCount   = @intCast(exts.items.len),         // enabledExtensionCount: u32 = @import("std").mem.zeroes(u32),
          .ppEnabledExtensionNames = exts.items.ptr,                   // ppEnabledExtensionNames: [*c]const [*c]const u8 = @import("std").mem.zeroes([*c]const [*c]const u8),
        }}; //:: zvk.Instance{ ... }
      try vk.instance.create(&result.cfg, result.A.vk, &result.ct);  //:: vkCreateInstance
      return result;
    } //:: zvk.Instance.create
    pub fn destroy (I :*zvk.Instance) void { vk.instance.destroy(I.ct, I.A.vk); }
  }; //:: zvk.Instance
}; //:: zvk


//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pub const zgpu = struct {
  //______________________________________
  // @section zvk Forward Exports
  //____________________________
  pub const Allocator = zvk.Allocator;
  pub const String    = zvk.String;
  pub const Size      = zvk.Size;
  pub const SpirV     = zvk.SpirV;
  pub const version   = zvk.version;
  pub const Version   = zvk.Version;

  //______________________________________
  // @section Configuration
  //____________________________
  pub const cfg = struct {
    pub const default = struct {
      pub const appName    = "z*gpu | Application";
      pub const appVers    = zgpu.version.new(0, 0, 0);
      pub const engineName = "z*gpu | Engine";
      pub const engineVers = zgpu.version.new(0, 0, 0);
    }; //:: cfg.default
  }; //:: cfg

  //______________________________________
  // @section Core Logic
  //____________________________
  pub const Gpu = struct {
    A        :zvk.Allocator,
    instance :zvk.Instance,
    pub fn update (gpu :*Gpu) void {_=gpu;}
    pub fn term   (gpu :*Gpu) void {
      gpu.instance.destroy();
    }

    pub fn init (args:struct {
        appName    : zvk.String  = zgpu.cfg.default.appName,
        appVers    : zvk.Version = zgpu.cfg.default.appVers,
        engineName : zvk.String  = zgpu.cfg.default.engineName,
        engineVers : zvk.Version = zgpu.cfg.default.engineVers, },
        A          : zvk.Allocator,
      ) !zgpu.Gpu {
      var result = Gpu{.A= A, .instance= undefined};
      result.instance = try zvk.Instance.create(.{
        .appName    = args.appName,
        .appVers    = args.appVers,
        .engineName = args.engineName,
        .engineVers = args.engineVers,
        }, A);
      return result;
    } //:: Gpu.init
  }; //:: Gpu
  pub const init = zgpu.Gpu.init;
}; //:: zgpu




//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

