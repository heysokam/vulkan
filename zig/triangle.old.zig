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
pub const zvk = struct {
  const vk = @import("./lib/vulkan.zig");

  pub const String = [*:0]const u8;
  pub const Size   = vk.Extent2D;
  pub const SpirV  = []const u8; // [*:0]const u8;

  pub const version   = struct {
    pub const api     = struct {
      pub const v1_0  = vk.API_VERSION_1_0;
      pub const v1_1  = vk.API_VERSION_1_1;
      pub const v1_2  = vk.API_VERSION_1_2;
      pub const v1_3  = vk.API_VERSION_1_3;
    }; //:: zvk.version.api

    pub const Version = u32;
    pub const Major   = u7;
    pub const Minor   = u10;
    pub const Patch   = u12;

    pub fn new (
        M : zvk.version.Major,
        m : zvk.version.Minor,
        p : zvk.version.Patch,
      ) zvk.version.Version {
      return vk.makeApiVersion(0, M,m,p);
    } //:: zvk.version.new
  }; //:: zvk.version
  pub const Version = zvk.version.Version;

  pub const Allocator = struct {
    const vulkan = @import("./lib/vulkan.zig");

    zig  :std.mem.Allocator,
    vk   :?*const vulkan.AllocationCallbacks,

    pub fn create (A :std.mem.Allocator) Allocator {
      return Allocator{
       .zig = A,
       .vk  = null  // @maybe Allocator library ?
        };
    } //:: zvk.Allocator.create
  }; //:: zvk.Allocator

  pub const cfg = struct {
    pub const features = struct {
      /// List of 'apis' to construct base, instance and device wrappers for vulkan-zig
      pub const list :[]const vk.ApiInfo = &.{
        .{  // Add invidiual functions by manually creating an 'api'
          .base_commands     = .{ .createInstance = true, },
          .instance_commands = .{ .createDevice   = true, },
          },
        // Add entire feature sets or extensions
        vk.features.version_1_0,
        vk.extensions.khr_surface,
        vk.extensions.khr_swapchain,
      }; //:: zvk.features.list
    }; //:: zvk.features

    pub const default = struct {
      pub const version    = zvk.version.api.v1_0;
      pub const appName    = "zvk.Application";
      pub const appVers    = zvk.version.new(0, 0, 0);
      pub const engineName = "zvk.Engine";
      pub const engineVers = zvk.version.new(0, 0, 0);
    }; //:: zvk.cfg.default
  }; //:: zvk.cfg

  pub const app = struct {
    //______________________________________
    // @section Application
    //____________________________
    pub const Cfg = vk.ApplicationInfo;
    pub fn defaults (args :struct {
        appName    : zvk.String  = zvk.cfg.default.appName,
        appVers    : zvk.Version = zvk.cfg.default.appVers,
        engineName : zvk.String  = zvk.cfg.default.engineName,
        engineVers : zvk.Version = zvk.cfg.default.engineVers,
      }) app.Cfg {
      return app.Cfg{
        .p_application_name  = args.appName,
        .application_version = args.appVers,
        .p_engine_name       = args.engineName,
        .engine_version      = args.engineVers,
        .api_version         = zvk.cfg.default.version,
        }; // << VkApplicationInfo{ ... }
    } //:: zvk.app.defaults
  }; //:: zvk.app
}; //:: zvk


//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pub const zgpu = struct {
  //______________________________________
  // @section zvk Forward Exports
  //____________________________
  pub const Allocator = zvk.Allocator;
  pub const version   = zvk.version;

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
    // loader   :zvk.Loader,
    // instance :zvk.Instance,
    pub fn update (gpu :*Gpu) void {_=gpu;}
    pub fn term   (gpu :*Gpu) void {_=gpu;}

    pub fn init (_:struct {
        appName    : zvk.String  = zgpu.cfg.default.appName,
        appVers    : zvk.Version = zgpu.cfg.default.appVers,
        engineName : zvk.String  = zgpu.cfg.default.engineName,
        engineVers : zvk.Version = zgpu.cfg.default.engineVers, },
        A          : zvk.Allocator,
      ) !zgpu.Gpu {
      const result = Gpu{.A= A, .loader= undefined, .instance= undefined};
      return result;
    } //:: Gpu.init
  }; //:: Gpu
  pub const init = zgpu.Gpu.init;
}; //:: zgpu


//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//______________________________________
// @section Reference: Entry Point
//____________________________
pub fn _main () !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = zgpu.Allocator.create(arena.allocator());

  try zstd.echo("Hello z*gpu | Triangle");
  var sys = zsys.init(960,540,"Hello z*gpu | Triangle");
  var gpu = try zgpu.init(.{
    .appName    = "Hello z*gpu | Triangle",
    .appVers    = zgpu.version.new(0, 0, 1),
    .engineName = "Hello z*gpu | Triangle Engine",
    .engineVers = zgpu.version.new(0, 0, 1),
    }, A);
  while (!sys.close()) {
    sys.update();
    gpu.update();
    }
  gpu.term();
  sys.term();
} //:: _main

















//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
const TODO = struct {
  // @deps External
  const glfw = @import("./lib/glfw.zig");
  const vk = @import("./lib/vulkan.zig");
  const Allocator = std.mem.Allocator;


  //.............................................................................................................................................................
  const required_device_extensions = [_][*:0]const u8{vk.extensions.khr_swapchain.name};
  /// Pass a list of 'apis' to construct base, instance and device wrappers for vulkan-zig
  const apis: []const vk.ApiInfo = &.{
    .{ // Either add invidiual functions by manually creating an 'api'
      .base_commands   = .{.createInstance = true},
      .instance_commands = .{.createDevice = true},
      },
    // Or add entire feature sets or extensions
    vk.features.version_1_0,
    vk.extensions.khr_surface,
    vk.extensions.khr_swapchain,
    };

  /// Pass the `apis` to the wrappers to create dispatch tables.
  const BaseDispatch     = vk.BaseWrapper(apis);
  const InstanceDispatch = vk.InstanceWrapper(apis);
  const DeviceDispatch   = vk.DeviceWrapper(apis);

  // Create some proxying wrappers, which also have the respective handles
  const Instance = vk.InstanceProxy(apis);
  const Device   = vk.DeviceProxy(apis);

  pub const GraphicsContext = struct {
    pub const CommandBuffer = vk.CommandBufferProxy(apis);

    allocator      : Allocator,
    vkb            : BaseDispatch,
    instance       : Instance,
    surface        : vk.SurfaceKHR,
    pdev           : vk.PhysicalDevice,
    props          : vk.PhysicalDeviceProperties,
    mem_props      : vk.PhysicalDeviceMemoryProperties,
    dev            : Device,
    graphics_queue : Queue,
    present_queue  : Queue,

    pub fn init (
        appName   : [*:0]const u8,
        window    : ?*glfw.Window,
        allocator : Allocator,
      ) !GraphicsContext {
      var self: GraphicsContext = undefined;
      self.allocator = allocator;
      self.vkb = try BaseDispatch.load(glfw.vk.instance.getProc);

      var glfw_exts_count: u32 = 0;
      const glfw_exts = glfw.vk.instance.getExts(&glfw_exts_count);

      const app_info = vk.ApplicationInfo{
        .p_application_name = appName,
        .application_version = vk.makeApiVersion(0, 0, 0, 0),
        .p_engine_name = appName,
        .engine_version = vk.makeApiVersion(0, 0, 0, 0),
        .api_version = vk.API_VERSION_1_2,
        };

      const inst = try self.vkb.createInstance(&.{
        .p_application_info         = &app_info,
        .enabled_extension_count    = glfw_exts_count,
        .pp_enabled_extension_names = @ptrCast(glfw_exts),
        }, null);

      const vki = try allocator.create(InstanceDispatch);
      errdefer allocator.destroy(vki);
      vki.* = try InstanceDispatch.load(inst, self.vkb.dispatch.vkGetInstanceProcAddr);
      self.instance = Instance.init(inst, vki);
      errdefer self.instance.destroyInstance(null);

      self.surface = try createSurface(self.instance, window);
      errdefer self.instance.destroySurfaceKHR(self.surface, null);

      const candidate = try pickPhysicalDevice(self.instance, allocator, self.surface);
      self.pdev = candidate.pdev;
      self.props = candidate.props;

      const dev = try initializeCandidate(self.instance, candidate);

      const vkd = try allocator.create(DeviceDispatch);
      errdefer allocator.destroy(vkd);
      vkd.* = try DeviceDispatch.load(dev, self.instance.wrapper.dispatch.vkGetDeviceProcAddr);
      self.dev = Device.init(dev, vkd);
      errdefer self.dev.destroyDevice(null);

      self.graphics_queue = Queue.init(self.dev, candidate.queues.graphics_family);
      self.present_queue = Queue.init(self.dev, candidate.queues.present_family);

      self.mem_props = self.instance.getPhysicalDeviceMemoryProperties(self.pdev);

      return self;
    } //:: GraphicsContext.init

    pub fn deinit (self: GraphicsContext) void {
      self.dev.destroyDevice(null);
      self.instance.destroySurfaceKHR(self.surface, null);
      self.instance.destroyInstance(null);

      // Don't forget to free the tables to prevent a memory leak.
      self.allocator.destroy(self.dev.wrapper);
      self.allocator.destroy(self.instance.wrapper);
    } //:: GraphicsContext.deinit

    pub fn deviceName (self: *const GraphicsContext) []const u8 {
      return std.mem.sliceTo(&self.props.device_name, 0);
    } //:: GraphicsContext.deviceName

    pub fn findMemoryTypeIndex (
        self             : GraphicsContext,
        memory_type_bits : u32,
        flags            : vk.MemoryPropertyFlags
      ) !u32 {
      for (self.mem_props.memory_types[0..self.mem_props.memory_type_count], 0..) |mem_type, i| {
        if (memory_type_bits & (@as(u32, 1) << @truncate(i)) != 0 and mem_type.property_flags.contains(flags)) {
          return @truncate(i);
        }
      }

      return error.NoSuitableMemoryType;
    } //:: GraphicsContext.findMemoryTypeIndex

    pub fn allocate (
        self         : GraphicsContext,
        requirements : vk.MemoryRequirements,
        flags        : vk.MemoryPropertyFlags
      ) !vk.DeviceMemory {
      return try self.dev.allocateMemory(&.{
        .allocation_size = requirements.size,
        .memory_type_index = try self.findMemoryTypeIndex(requirements.memory_type_bits, flags),
      }, null);
    } //:: GraphicsContext.allocate
  }; //:: GraphicsContext

  pub const Queue = struct {
    handle: vk.Queue,
    family: u32,

    fn init (device: Device, family: u32) Queue {
      return .{
        .handle = device.getDeviceQueue(family, 0),
        .family = family,
        };
    } //:: Queue.init
  }; //:: Queue

  fn createSurface (
      I   : Instance,
      win : ?*glfw.Window
    ) !vk.SurfaceKHR {
    var result :vk.SurfaceKHR= undefined;
    if (glfw.vk.surface.create(I.handle, win, null, &result) != .success) return error.SurfaceInitFailed;
    return result;
  }

  fn initializeCandidate (I: Instance, candidate: DeviceCandidate) !vk.Device {
    const priority = [_]f32{1};
    const qci = [_]vk.DeviceQueueCreateInfo{
      .{.queue_family_index = candidate.queues.graphics_family,
        .queue_count        = 1,
        .p_queue_priorities = &priority,
        },
      .{.queue_family_index = candidate.queues.present_family,
        .queue_count        = 1,
        .p_queue_priorities = &priority,
        },
      };

    const queue_count: u32 = if (candidate.queues.graphics_family == candidate.queues.present_family) 1 else 2;

    return try I.createDevice(candidate.pdev, &.{
      .queue_create_info_count = queue_count,
      .p_queue_create_infos = &qci,
      .enabled_extension_count = required_device_extensions.len,
      .pp_enabled_extension_names = @ptrCast(&required_device_extensions),
      }, null);
  } //:: initializeCandidate

  const DeviceCandidate = struct {
    pdev   : vk.PhysicalDevice,
    props  : vk.PhysicalDeviceProperties,
    queues : QueueAllocation,
  }; //:: DeviceCandidate

  const QueueAllocation = struct {
    graphics_family : u32,
    present_family  : u32,
  }; //:: QueueAllocation

  fn pickPhysicalDevice (
      I : Instance,
      A : Allocator,
      S : vk.SurfaceKHR,
    ) !DeviceCandidate {
    const pdevs = try I.enumeratePhysicalDevicesAlloc(A);
    defer A.free(pdevs);

    for (pdevs) |pdev| {
      if (try checkSuitable(I, pdev, A, S)) |candidate| {
        return candidate;
      }
    }

    return error.NoSuitableDevice;
  } //:: pickPhysicalDevice

  fn checkSuitable (
      I : Instance,
      D : vk.PhysicalDevice,
      A : Allocator,
      S : vk.SurfaceKHR,
    ) !?DeviceCandidate {
    if (!try checkExtensionSupport(I, D, A)) return null;
    if (!try checkSurfaceSupport(I, D, S)) return null;

    if (try allocateQueues(I, D, A, S)) |allocation| {
      const props = I.getPhysicalDeviceProperties(D);
      return DeviceCandidate{
        .pdev = D,
        .props = props,
        .queues = allocation,
    };
    }

    return null;
  } //:: checkSuitable

  fn allocateQueues (
      I : Instance,
      D : vk.PhysicalDevice,
      A : Allocator,
      S : vk.SurfaceKHR
    ) !?QueueAllocation {
    const families = try I.getPhysicalDeviceQueueFamilyPropertiesAlloc(D, A);
    defer A.free(families);

    var graphics_family: ?u32 = null;
    var present_family: ?u32 = null;

    for (families, 0..) |properties, i| {
      const family: u32 = @intCast(i);

      if (graphics_family == null and properties.queue_flags.graphics_bit) {
        graphics_family = family;
      }

      if (present_family == null and (try I.getPhysicalDeviceSurfaceSupportKHR(D, family, S)) == vk.TRUE) {
        present_family = family;
      }
    }

    if (graphics_family != null and present_family != null) {
      return QueueAllocation{
        .graphics_family = graphics_family.?,
        .present_family = present_family.?,
        };
    }

    return null;
  } //:: allocateQueues

  fn checkSurfaceSupport (
      I : Instance,
      D : vk.PhysicalDevice,
      S : vk.SurfaceKHR
    ) !bool {
    var format_count: u32 = undefined;
    _ = try I.getPhysicalDeviceSurfaceFormatsKHR(D, S, &format_count, null);

    var present_mode_count: u32 = undefined;
    _ = try I.getPhysicalDeviceSurfacePresentModesKHR(D, S, &present_mode_count, null);

    return format_count > 0 and present_mode_count > 0;
  } //:: checkSurfaceSupport

  fn checkExtensionSupport (
      I : Instance,
      D : vk.PhysicalDevice,
      A : Allocator,
    ) !bool {
    const propsv = try I.enumerateDeviceExtensionPropertiesAlloc(D, null, A);
    defer A.free(propsv);

    for (required_device_extensions) |ext| {
      for (propsv) |props| {
        if (std.mem.eql(u8, std.mem.span(ext), std.mem.sliceTo(&props.extension_name, 0))) {
          break;
        }
      } else {
        return false;
      }
    }
    return true;
  } //:: checkExtensionSupport


  //.............................................................................................................................................................

  pub const Swapchain = struct {
    pub const PresentState = enum {
      optimal, suboptimal,
    }; //:: Swapchain.PresentState

    gc                  : *const GraphicsContext,
    allocator           : Allocator,

    surface_format      : vk.SurfaceFormatKHR,
    present_mode        : vk.PresentModeKHR,
    extent              : vk.Extent2D,
    handle              : vk.SwapchainKHR,

    swap_images         : []SwapImage,
    image_index         : u32,
    next_image_acquired : vk.Semaphore,

    pub fn initRecycle (
        gc   : *const GraphicsContext,
        A    : std.mem.Allocator,
        size : zvk.Size,
        old  : vk.SwapchainKHR
      ) !Swapchain {
      const caps = try gc.instance.getPhysicalDeviceSurfaceCapabilitiesKHR(gc.pdev, gc.surface);
      const actual_extent = findActualExtent(caps, size);
      if (actual_extent.width == 0 or actual_extent.height == 0) {
        return error.InvalidSurfaceDimensions;
      }

      const surface_format = try findSurfaceFormat(gc, A);
      const present_mode = try findPresentMode(gc, A);

      var image_count = caps.min_image_count + 1;
      if (caps.max_image_count > 0) image_count = @min(image_count, caps.max_image_count);

      const qfi = [_]u32{ gc.graphics_queue.family, gc.present_queue.family };
      const sharing_mode :vk.SharingMode=
        if (gc.graphics_queue.family != gc.present_queue.family) .concurrent
        else .exclusive;

      const handle = try gc.dev.createSwapchainKHR(&.{
        .surface                  = gc.surface,
        .min_image_count          = image_count,
        .image_format             = surface_format.format,
        .image_color_space        = surface_format.color_space,
        .image_extent             = actual_extent,
        .image_array_layers       = 1,
        .image_usage              = .{ .color_attachment_bit = true, .transfer_dst_bit = true },
        .image_sharing_mode       = sharing_mode,
        .queue_family_index_count = qfi.len,
        .p_queue_family_indices   = &qfi,
        .pre_transform            = caps.current_transform,
        .composite_alpha          = .{ .opaque_bit_khr = true },
        .present_mode             = present_mode,
        .clipped                  = vk.TRUE,
        .old_swapchain            = old,
        }, null);
      errdefer gc.dev.destroySwapchainKHR(handle, null);

      if (old != .null_handle) {
        // Apparently, the old swapchain handle still needs to be destroyed after recreating.
        gc.dev.destroySwapchainKHR(old, null);
      }

      const swap_images = try initSwapchainImages(gc, handle, surface_format.format, A);
      errdefer {
        for (swap_images) |si| si.deinit(gc);
        A.free(swap_images);
      }

      var next_image_acquired = try gc.dev.createSemaphore(&.{}, null);
      errdefer gc.dev.destroySemaphore(next_image_acquired, null);

      const result = try gc.dev.acquireNextImageKHR(handle, std.math.maxInt(u64), next_image_acquired, .null_handle);
      if (result.result != .success) {
        return error.ImageAcquireFailed;
      }

      std.mem.swap(vk.Semaphore, &swap_images[result.image_index].image_acquired, &next_image_acquired);
      return Swapchain{
        .gc                  = gc,
        .allocator           = A,
        .surface_format      = surface_format,
        .present_mode        = present_mode,
        .extent              = actual_extent,
        .handle              = handle,
        .swap_images         = swap_images,
        .image_index         = result.image_index,
        .next_image_acquired = next_image_acquired,
        };
    } //:: Swapchain.initRecycle

    pub fn init (
        gc        : *const GraphicsContext,
        allocator : Allocator,
        extent    : zvk.Size,
      ) !Swapchain {
      return try initRecycle(gc, allocator, extent, .null_handle);
    } //:: Swapchain.init


    fn deinitExceptSwapchain (S: Swapchain) void {
      for (S.swap_images) |si| si.deinit(S.gc);
      S.allocator.free(S.swap_images);
      S.gc.dev.destroySemaphore(S.next_image_acquired, null);
    } //:: Swapchain.deinitExceptSwapchain

    pub fn waitForAllFences (S: Swapchain) !void {
      for (S.swap_images) |si| si.waitForFence(S.gc) catch {};
    } //:: Swapchain.waitForAllFence

    pub fn deinit (S: Swapchain) void {
      S.deinitExceptSwapchain();
      S.gc.dev.destroySwapchainKHR(S.handle, null);
    } //:: Swapchain.deinit

    pub fn recreate (
        S    : *Swapchain,
        size : zvk.Size
      ) !void {
      S.deinitExceptSwapchain();
      S.* = try initRecycle(S.gc, S.allocator, size, S.handle);
    } //:: Swapchain.recreate

    pub fn currentImage (S: Swapchain) vk.Image { return S.swap_images[S.image_index].image; }
    pub fn currentSwapImage (S: Swapchain) *const SwapImage { return &S.swap_images[S.image_index]; }

    pub fn present (S: *Swapchain, cmdbuf: vk.CommandBuffer) !PresentState {
      // Simple method:
      // 1) Acquire next image
      // 2) Wait for and reset fence of the acquired image
      // 3) Submit command buffer with fence of acquired image,
      //    dependendent on the semaphore signalled by the first step.
      // 4) Present current frame, dependent on semaphore signalled by previous step
      // Problem: This way we can't reference the current image while rendering.
      // Better method: Shuffle the steps around such that acquire next image is the last step,
      // leaving the swapchain in a state with the current image.
      // 1) Wait for and reset fence of current image
      // 2) Submit command buffer, signalling fence of current image and dependent on
      //    the semaphore signalled by step 4.
      // 3) Present current frame, dependent on semaphore signalled by the submit
      // 4) Acquire next image, signalling its semaphore
      // One problem that arises is that we can't know beforehand which semaphore to signal,
      // so we keep an extra auxilery semaphore that is swapped around

      // Step 1: Make sure the current frame has finished rendering
      const current = S.currentSwapImage();
      try current.waitForFence(S.gc);
      try S.gc.dev.resetFences(1, @ptrCast(&current.frame_fence));

      // Step 2: Submit the command buffer
      const wait_stage = [_]vk.PipelineStageFlags{.{ .top_of_pipe_bit = true }};
      try S.gc.dev.queueSubmit(S.gc.graphics_queue.handle, 1, &[_]vk.SubmitInfo{.{
        .wait_semaphore_count   = 1,
        .p_wait_semaphores      = @ptrCast(&current.image_acquired),
        .p_wait_dst_stage_mask  = &wait_stage,
        .command_buffer_count   = 1,
        .p_command_buffers      = @ptrCast(&cmdbuf),
        .signal_semaphore_count = 1,
        .p_signal_semaphores    = @ptrCast(&current.render_finished),
        }}, current.frame_fence);

      // Step 3: Present the current frame
      _ = try S.gc.dev.queuePresentKHR(S.gc.present_queue.handle, &.{
        .wait_semaphore_count = 1,
        .p_wait_semaphores    = @ptrCast(&current.render_finished),
        .swapchain_count      = 1,
        .p_swapchains         = @ptrCast(&S.handle),
        .p_image_indices      = @ptrCast(&S.image_index),
        });

      // Step 4: Acquire next frame
      const result = try S.gc.dev.acquireNextImageKHR(
        S.handle,
        std.math.maxInt(u64),
        S.next_image_acquired,
        .null_handle,
        );

      std.mem.swap(vk.Semaphore, &S.swap_images[result.image_index].image_acquired, &S.next_image_acquired);
      S.image_index = result.image_index;

      return switch (result.result) {
        .success        => .optimal,
        .suboptimal_khr => .suboptimal,
        else => unreachable,
        };
    } //:: Swapchain.present
  }; //:: Swapchain

  const SwapImage = struct {
    image           : vk.Image,
    view            : vk.ImageView,
    image_acquired  : vk.Semaphore,
    render_finished : vk.Semaphore,
    frame_fence     : vk.Fence,

    fn init (
        gc     : *const GraphicsContext,
        image  : vk.Image,
        format : vk.Format
      ) !SwapImage {
      const view = try gc.dev.createImageView(&.{
        .image              = image,
        .view_type          = .@"2d",
        .format             = format,
        .components         = .{ .r= .identity, .g= .identity, .b= .identity, .a= .identity },
        .subresource_range  = .{
          .aspect_mask      = .{ .color_bit= true },
          .base_mip_level   = 0,
          .level_count      = 1,
          .base_array_layer = 0,
          .layer_count      = 1,
          },},
        null);
      errdefer gc.dev.destroyImageView(view, null);

      const image_acquired = try gc.dev.createSemaphore(&.{}, null);
      errdefer gc.dev.destroySemaphore(image_acquired, null);

      const render_finished = try gc.dev.createSemaphore(&.{}, null);
      errdefer gc.dev.destroySemaphore(render_finished, null);

      const frame_fence = try gc.dev.createFence(&.{ .flags = .{ .signaled_bit = true } }, null);
      errdefer gc.dev.destroyFence(frame_fence, null);

      return SwapImage{
        .image           = image,
        .view            = view,
        .image_acquired  = image_acquired,
        .render_finished = render_finished,
        .frame_fence     = frame_fence,
        };
    } //:: SwapImage.init

    fn deinit (S: SwapImage, gc: *const GraphicsContext) void {
      S.waitForFence(gc) catch return;
      gc.dev.destroyImageView(S.view, null);
      gc.dev.destroySemaphore(S.image_acquired, null);
      gc.dev.destroySemaphore(S.render_finished, null);
      gc.dev.destroyFence(S.frame_fence, null);
    } //:: SwapImage.deinit

    fn waitForFence (S: SwapImage, gc: *const GraphicsContext) !void {
      _ = try gc.dev.waitForFences(1, @ptrCast(&S.frame_fence), vk.TRUE, std.math.maxInt(u64));
    } //:: SwapImage.waitForFence
  }; //:: SwapImage

  fn initSwapchainImages (
      gc        : *const GraphicsContext,
      swapchain : vk.SwapchainKHR,
      format    : vk.Format,
      allocator : Allocator
    ) ![]SwapImage {
    const images = try gc.dev.getSwapchainImagesAllocKHR(swapchain, allocator);
    defer allocator.free(images);

    const swap_images = try allocator.alloc(SwapImage, images.len);
    errdefer allocator.free(swap_images);

    var i: usize = 0;
    errdefer for (swap_images[0..i]) |si| si.deinit(gc);

    for (images) |image| {
      swap_images[i] = try SwapImage.init(gc, image, format);
      i += 1;
    }

    return swap_images;
  } //:: initSwapchainImages

  fn findSurfaceFormat (gc: *const GraphicsContext, allocator: Allocator) !vk.SurfaceFormatKHR {
    const preferred = vk.SurfaceFormatKHR{
      .format      = .b8g8r8a8_srgb,
      .color_space = .srgb_nonlinear_khr,
      };

    const surface_formats = try gc.instance.getPhysicalDeviceSurfaceFormatsAllocKHR(gc.pdev, gc.surface, allocator);
    defer allocator.free(surface_formats);

    for (surface_formats) |sfmt| {
      if (std.meta.eql(sfmt, preferred)) return preferred;
    }

    return surface_formats[0]; // There must always be at least one supported surface format
  } //:: findSurfaceFormat

  fn findPresentMode (gc: *const GraphicsContext, allocator: Allocator) !vk.PresentModeKHR {
    const present_modes = try gc.instance.getPhysicalDeviceSurfacePresentModesAllocKHR(gc.pdev, gc.surface, allocator);
    defer allocator.free(present_modes);
    const preferred = [_]vk.PresentModeKHR{ .mailbox_khr, .immediate_khr };
    for (preferred) |mode| {
      if (std.mem.indexOfScalar(vk.PresentModeKHR, present_modes, mode) != null) return mode;
    }
    return .fifo_khr;
  } //:: findPresentMode

  fn findActualExtent (
      caps   : vk.SurfaceCapabilitiesKHR,
      extent : zvk.Size,
    ) vk.Extent2D {
    return
      if (caps.current_extent.width != 0xFFFF_FFFF) caps.current_extent
      else .{
        .width  = std.math.clamp(extent.width,  caps.min_image_extent.width,  caps.max_image_extent.width),
        .height = std.math.clamp(extent.height, caps.min_image_extent.height, caps.max_image_extent.height), };
  } //:: findActualExtent


  //.............................................................................................................................................................

  const Vertex = struct {
    pos   : [2]f32,
    color : [3]f32,

    const binding_description = vk.VertexInputBindingDescription{
      .binding    = 0,
      .stride     = @sizeOf(Vertex),
      .input_rate = .vertex,
      }; //:: Vertex.binding_description

    const attribute_description = [_]vk.VertexInputAttributeDescription{
      .{.binding  = 0,
        .location = 0,
        .format   = .r32g32_sfloat,
        .offset   = @offsetOf(Vertex, "pos"),
        },
      .{.binding  = 0,
        .location = 1,
        .format   = .r32g32b32_sfloat,
        .offset   = @offsetOf(Vertex, "color"),
        },
      }; //:: Vertex.attribute_description
  }; //:: Vertex

  const vertices = [_]Vertex{
    .{ .pos= .{    0, -0.5 }, .color= .{ 1, 0, 0 } },
    .{ .pos= .{  0.5,  0.5 }, .color= .{ 0, 1, 0 } },
    .{ .pos= .{ -0.5,  0.5 }, .color= .{ 0, 0, 1 } },
    };

  pub fn main (
      appName : zvk.String,
      size    : *zvk.Size,
      sys     : *zsys.System,
      vert    : zvk.SpirV,
      frag    : zvk.SpirV,
      A       : std.mem.Allocator,
    ) !void {

    const gc = try GraphicsContext.init(appName, sys.win.ct, A);
    defer gc.deinit();

    std.log.debug("Using device: {s}", .{gc.deviceName()});

    var swapchain = try Swapchain.init(&gc, A, size.*);
    defer swapchain.deinit();

    const pipeline_layout = try gc.dev.createPipelineLayout(&.{
      .flags = .{},
      .set_layout_count = 0,
      .p_set_layouts = undefined,
      .push_constant_range_count = 0,
      .p_push_constant_ranges = undefined,
    }, null);
    defer gc.dev.destroyPipelineLayout(pipeline_layout, null);

    const render_pass = try createRenderPass(&gc, swapchain);
    defer gc.dev.destroyRenderPass(render_pass, null);

    const pipeline = try createPipeline(&gc, pipeline_layout, render_pass, vert, frag);
    defer gc.dev.destroyPipeline(pipeline, null);

    var framebuffers = try createFramebuffers(&gc, A, render_pass, swapchain);
    defer destroyFramebuffers(&gc, A, framebuffers);

    const pool = try gc.dev.createCommandPool(&.{
      .queue_family_index = gc.graphics_queue.family,
    }, null);
    defer gc.dev.destroyCommandPool(pool, null);

    const buffer = try gc.dev.createBuffer(&.{
      .size         = @sizeOf(@TypeOf(vertices)),
      .usage        = .{ .transfer_dst_bit = true, .vertex_buffer_bit = true },
      .sharing_mode = .exclusive,
      }, null);
    defer gc.dev.destroyBuffer(buffer, null);
    const mem_reqs = gc.dev.getBufferMemoryRequirements(buffer);
    const memory   = try gc.allocate(mem_reqs, .{ .device_local_bit = true });
    defer gc.dev.freeMemory(memory, null);
    try gc.dev.bindBufferMemory(buffer, memory, 0);

    try uploadVertices(&gc, pool, buffer);

    var cmdbufs = try createCommandBuffers(
      &gc,
      pool,
      A,
      buffer,
      swapchain.extent,
      render_pass,
      pipeline,
      framebuffers,
    );
    defer destroyCommandBuffers(&gc, pool, A, cmdbufs);

    while (sys.close()) {
      var w :c_int= undefined;
      var h :c_int= undefined;
      glfw.framebuffer.size(sys.win.ct, &w, &h);

      // Don't present or resize swapchain while the window is minimized
      if (w == 0 or h == 0) {
        glfw.sync();
        continue;
      }

      const cmdbuf = cmdbufs[swapchain.image_index];

      const state = swapchain.present(cmdbuf) catch |err| switch (err) {
        error.OutOfDateKHR => Swapchain.PresentState.suboptimal,
        else => |narrow| return narrow,
    };

      if (state == .suboptimal or size.width != @as(u32, @intCast(w)) or size.height != @as(u32, @intCast(h))) {
        size.width = @intCast(w);
        size.height = @intCast(h);
        try swapchain.recreate(size.*);

        destroyFramebuffers(&gc, A, framebuffers);
        framebuffers = try createFramebuffers(&gc, A, render_pass, swapchain);

        destroyCommandBuffers(&gc, pool, A, cmdbufs);
        cmdbufs = try createCommandBuffers(
          &gc,
          pool,
          A,
          buffer,
          swapchain.extent,
          render_pass,
          pipeline,
          framebuffers,
        );
      }

      glfw.sync();
    }

    try swapchain.waitForAllFences();
    try gc.dev.deviceWaitIdle();
  } //:: TODO.main

  fn uploadVertices (
      gc     : *const GraphicsContext,
      pool   : vk.CommandPool,
      buffer : vk.Buffer
    ) !void {
    const staging_buffer = try gc.dev.createBuffer(&.{
      .size         = @sizeOf(@TypeOf(vertices)),
      .usage        = .{ .transfer_src_bit = true },
      .sharing_mode = .exclusive,
      }, null);
    defer gc.dev.destroyBuffer(staging_buffer, null);
    const mem_reqs = gc.dev.getBufferMemoryRequirements(staging_buffer);
    const staging_memory = try gc.allocate(mem_reqs, .{ .host_visible_bit = true, .host_coherent_bit = true });
    defer gc.dev.freeMemory(staging_memory, null);
    try gc.dev.bindBufferMemory(staging_buffer, staging_memory, 0);

    {
      const data = try gc.dev.mapMemory(staging_memory, 0, vk.WHOLE_SIZE, .{});
      defer gc.dev.unmapMemory(staging_memory);

      const gpu_vertices: [*]Vertex = @ptrCast(@alignCast(data));
      @memcpy(gpu_vertices, vertices[0..]);
    }

    try copyBuffer(gc, pool, buffer, staging_buffer, @sizeOf(@TypeOf(vertices)));
  } //:: uploadVertices

  fn copyBuffer (
      gc   : *const GraphicsContext,
      pool : vk.CommandPool,
      dst  : vk.Buffer,
      src  : vk.Buffer,
      size : vk.DeviceSize
    ) !void {
    var cmdbuf_handle: vk.CommandBuffer = undefined;
    try gc.dev.allocateCommandBuffers(&.{
      .command_pool = pool,
      .level = .primary,
      .command_buffer_count = 1,
      }, @ptrCast(&cmdbuf_handle));
    defer gc.dev.freeCommandBuffers(pool, 1, @ptrCast(&cmdbuf_handle));

    const cmdbuf = GraphicsContext.CommandBuffer.init(cmdbuf_handle, gc.dev.wrapper);

    try cmdbuf.beginCommandBuffer(&.{
      .flags = .{ .one_time_submit_bit = true },
      });

    const region = vk.BufferCopy{
      .src_offset = 0,
      .dst_offset = 0,
      .size = size,
      };
    cmdbuf.copyBuffer(src, dst, 1, @ptrCast(&region));

    try cmdbuf.endCommandBuffer();

    const si = vk.SubmitInfo{
      .command_buffer_count = 1,
      .p_command_buffers = (&cmdbuf.handle)[0..1],
      .p_wait_dst_stage_mask = undefined,
      };
    try gc.dev.queueSubmit(gc.graphics_queue.handle, 1, @ptrCast(&si), .null_handle);
    try gc.dev.queueWaitIdle(gc.graphics_queue.handle);
  } //:: copyBuffer

  fn createCommandBuffers(
      gc           : *const GraphicsContext,
      pool         : vk.CommandPool,
      allocator    : Allocator,
      buffer       : vk.Buffer,
      extent       : vk.Extent2D,
      render_pass  : vk.RenderPass,
      pipeline     : vk.Pipeline,
      framebuffers : []vk.Framebuffer,
    ) ![]vk.CommandBuffer {
    const cmdbufs = try allocator.alloc(vk.CommandBuffer, framebuffers.len);
    errdefer allocator.free(cmdbufs);

    try gc.dev.allocateCommandBuffers(&.{
      .command_pool         = pool,
      .level                = .primary,
      .command_buffer_count = @intCast(cmdbufs.len),
      }, cmdbufs.ptr);
    errdefer gc.dev.freeCommandBuffers(pool, @intCast(cmdbufs.len), cmdbufs.ptr);

    const clear = vk.ClearValue{.color= .{.float_32= .{ 0, 0, 0, 1 }}};

    const viewport = vk.Viewport{
      .x = 0,
      .y = 0,
      .width = @floatFromInt(extent.width),
      .height = @floatFromInt(extent.height),
      .min_depth = 0,
      .max_depth = 1,
      };

    const scissor = vk.Rect2D{
      .offset = .{ .x = 0, .y = 0 },
      .extent = extent,
      };

    for (cmdbufs, framebuffers) |cmdbuf, framebuffer| {
      try gc.dev.beginCommandBuffer(cmdbuf, &.{});

      gc.dev.cmdSetViewport(cmdbuf, 0, 1, @ptrCast(&viewport));
      gc.dev.cmdSetScissor(cmdbuf, 0, 1, @ptrCast(&scissor));

      // This needs to be a separate definition - see https://github.com/ziglang/zig/issues/7627.
      const render_area = vk.Rect2D{
        .offset = .{ .x = 0, .y = 0 },
        .extent = extent,
    };

      gc.dev.cmdBeginRenderPass(cmdbuf, &.{
        .render_pass = render_pass,
        .framebuffer = framebuffer,
        .render_area = render_area,
        .clear_value_count = 1,
        .p_clear_values = @ptrCast(&clear),
      }, .@"inline");

      gc.dev.cmdBindPipeline(cmdbuf, .graphics, pipeline);
      const offset = [_]vk.DeviceSize{0};
      gc.dev.cmdBindVertexBuffers(cmdbuf, 0, 1, @ptrCast(&buffer), &offset);
      gc.dev.cmdDraw(cmdbuf, vertices.len, 1, 0, 0);

      gc.dev.cmdEndRenderPass(cmdbuf);
      try gc.dev.endCommandBuffer(cmdbuf);
    }

    return cmdbufs;
  } //:: createCommandBuffers

  fn destroyCommandBuffers (
      gc        : *const GraphicsContext,
      pool      : vk.CommandPool,
      allocator : Allocator,
      cmdbufs   : []vk.CommandBuffer
    ) void {
    gc.dev.freeCommandBuffers(pool, @truncate(cmdbufs.len), cmdbufs.ptr);
    allocator.free(cmdbufs);
  } //:: destroyCommandBuffers

  fn createFramebuffers (
      gc          : *const GraphicsContext,
      allocator   : Allocator,
      render_pass : vk.RenderPass,
      swapchain   : Swapchain
    ) ![]vk.Framebuffer {
    const framebuffers = try allocator.alloc(vk.Framebuffer, swapchain.swap_images.len);
    errdefer allocator.free(framebuffers);

    var i: usize = 0;
    errdefer for (framebuffers[0..i]) |fb| gc.dev.destroyFramebuffer(fb, null);

    for (framebuffers) |*fb| {
      fb.* = try gc.dev.createFramebuffer(&.{
        .render_pass = render_pass,
        .attachment_count = 1,
        .p_attachments = @ptrCast(&swapchain.swap_images[i].view),
        .width = swapchain.extent.width,
        .height = swapchain.extent.height,
        .layers = 1,
      }, null);
      i += 1;
    }

    return framebuffers;
  } //:: createFramebuffers

  fn destroyFramebuffers (
      gc           : *const GraphicsContext,
      allocator    : Allocator,
      framebuffers : []const vk.Framebuffer
    ) void {
    for (framebuffers) |fb| gc.dev.destroyFramebuffer(fb, null);
    allocator.free(framebuffers);
  } //:: destroyFramebuffers

  fn createRenderPass (gc: *const GraphicsContext, swapchain: Swapchain) !vk.RenderPass {
    const color_attachment = vk.AttachmentDescription{
      .format = swapchain.surface_format.format,
      .samples = .{ .@"1_bit" = true },
      .load_op = .clear,
      .store_op = .store,
      .stencil_load_op = .dont_care,
      .stencil_store_op = .dont_care,
      .initial_layout = .undefined,
      .final_layout = .present_src_khr,
       };

    const color_attachment_ref = vk.AttachmentReference{
      .attachment = 0,
      .layout = .color_attachment_optimal,
       };

    const subpass = vk.SubpassDescription{
      .pipeline_bind_point = .graphics,
      .color_attachment_count = 1,
      .p_color_attachments = @ptrCast(&color_attachment_ref),
       };

    return try gc.dev.createRenderPass(&.{
      .attachment_count = 1,
      .p_attachments = @ptrCast(&color_attachment),
      .subpass_count = 1,
      .p_subpasses = @ptrCast(&subpass),
      }, null);
  } //:: createRenderPass

  fn createPipeline (
    gc          : *const GraphicsContext,
    layout      : vk.PipelineLayout,
    render_pass : vk.RenderPass,
    vert        : zvk.SpirV,
    frag        : zvk.SpirV,
  ) !vk.Pipeline {
    const vs = try gc.dev.createShaderModule(&vk.ShaderModuleCreateInfo{
      .code_size = vert.len,
      .p_code    = @ptrCast(&vert),
      }, null);
    defer gc.dev.destroyShaderModule(vs, null);

    const fs = try gc.dev.createShaderModule(&vk.ShaderModuleCreateInfo{
      .code_size = frag.len,
      .p_code    = @ptrCast(&frag),
      }, null);
    defer gc.dev.destroyShaderModule(fs, null);

    const pssci = [_]vk.PipelineShaderStageCreateInfo{
      .{.stage  = .{.vertex_bit= true },
        .module = vs,
        .p_name = "main",
        },
      .{.stage  = .{.fragment_bit= true },
        .module = fs,
        .p_name = "main",
        },
      };

    const pvisci = vk.PipelineVertexInputStateCreateInfo{
      .vertex_binding_description_count   = 1,
      .p_vertex_binding_descriptions      = @ptrCast(&Vertex.binding_description),
      .vertex_attribute_description_count = Vertex.attribute_description.len,
      .p_vertex_attribute_descriptions    = &Vertex.attribute_description,
      };

    const piasci = vk.PipelineInputAssemblyStateCreateInfo{
      .topology                 = .triangle_list,
      .primitive_restart_enable = vk.FALSE,
  };

    const pvsci = vk.PipelineViewportStateCreateInfo{
      .viewport_count = 1,
      .p_viewports    = undefined, // set in createCommandBuffers with cmdSetViewport
      .scissor_count  = 1,
      .p_scissors     = undefined, // set in createCommandBuffers with cmdSetScissor
      };

    const prsci = vk.PipelineRasterizationStateCreateInfo{
      .depth_clamp_enable         = vk.FALSE,
      .rasterizer_discard_enable  = vk.FALSE,
      .polygon_mode               = .fill,
      .cull_mode                  = .{ .back_bit = true },
      .front_face                 = .clockwise,
      .depth_bias_enable          = vk.FALSE,
      .depth_bias_constant_factor = 0,
      .depth_bias_clamp           = 0,
      .depth_bias_slope_factor    = 0,
      .line_width                 = 1,
      };

    const pmsci = vk.PipelineMultisampleStateCreateInfo{
      .rasterization_samples    = .{ .@"1_bit" = true },
      .sample_shading_enable    = vk.FALSE,
      .min_sample_shading       = 1,
      .alpha_to_coverage_enable = vk.FALSE,
      .alpha_to_one_enable      = vk.FALSE,
      };

    const pcbas = vk.PipelineColorBlendAttachmentState{
      .blend_enable           = vk.FALSE,
      .src_color_blend_factor = .one,
      .dst_color_blend_factor = .zero,
      .color_blend_op         = .add,
      .src_alpha_blend_factor = .one,
      .dst_alpha_blend_factor = .zero,
      .alpha_blend_op         = .add,
      .color_write_mask       = .{ .r_bit = true, .g_bit = true, .b_bit = true, .a_bit = true },
      };

    const pcbsci = vk.PipelineColorBlendStateCreateInfo{
      .logic_op_enable  = vk.FALSE,
      .logic_op         = .copy,
      .attachment_count = 1,
      .p_attachments    = @ptrCast(&pcbas),
      .blend_constants  = [_]f32{ 0, 0, 0, 0 },
      };

    const dynstate = [_]vk.DynamicState{ .viewport, .scissor };
    const pdsci = vk.PipelineDynamicStateCreateInfo{
      .flags               = .{},
      .dynamic_state_count = dynstate.len,
      .p_dynamic_states    = &dynstate,
      };

    const gpci = vk.GraphicsPipelineCreateInfo{
      .flags                  = .{},
      .stage_count            = 2,
      .p_stages               = &pssci,
      .p_vertex_input_state   = &pvisci,
      .p_input_assembly_state = &piasci,
      .p_tessellation_state   = null,
      .p_viewport_state       = &pvsci,
      .p_rasterization_state  = &prsci,
      .p_multisample_state    = &pmsci,
      .p_depth_stencil_state  = null,
      .p_color_blend_state    = &pcbsci,
      .p_dynamic_state        = &pdsci,
      .layout                 = layout,
      .render_pass            = render_pass,
      .subpass                = 0,
      .base_pipeline_handle   = .null_handle,
      .base_pipeline_index    = -1,
      };

    var pipeline: vk.Pipeline = undefined;
    _ = try gc.dev.createGraphicsPipelines(
      .null_handle,
      1,
      @ptrCast(&gpci),
      null,
      @ptrCast(&pipeline),
      );
    return pipeline;
  } //:: createPipeline
};

//______________________________________
// @section Entry Point
//____________________________
pub fn main () !void {
  // const glfw = @import("./lib/glfw.zig");
  // const vk   = @import("./lib/vulkan.zig");

  const shd = struct {
    const vert align(@alignOf(u32)) = @embedFile("shd_vert").*;
    const frag align(@alignOf(u32)) = @embedFile("shd_frag").*;
  };
  const appName = "Zig | Vulkan-All-the-Things | Triangle";
  var size = zvk.Size{.width= 960, .height= 540};

  try zstd.echo("Hello zig.vulkan.Triangle");
  try zstd.echo(appName);

  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  // const A = zgpu.Allocator.create(arena.allocator());

  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  defer _ = gpa.deinit();
  const A = gpa.allocator();

  var sys = try zsys.init(size.width, size.height, appName);
  defer sys.term();





  try TODO.main(
    appName, &size, &sys,
    &shd.vert, &shd.frag,
    A);
}

const C = struct {
  export fn tmp_add  (a :c_int, b :c_int) c_int { return a + b; }
  export fn tmp_add2 (a :  u32, b :  u32)   u32 { return a + b; }
}; comptime { _ = &C; } // Force exports to be analyzed

