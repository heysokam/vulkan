//:__________________________________________________________________
//  zvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview Cable connector to the zvk modules
//_____________________________________________________|

pub const zvk = struct {
  const std = @import("std");
  // @deps zdk
  const vk   = @import("./zvulkan.zig");
  const zstd = @import("./zstd.zig");

  //______________________________________
  // @section General Type Aliases
  //____________________________
  pub const String   = vk.String;
  pub const Size     = vk.Size;
  pub const SpirV    = vk.SpirV;
  pub const version  = vk.version;
  pub const Version  = vk.Version;
  pub const Debug    = vk.Debug;
  pub const Surface  = vk.Surface;
  pub const ok       = vk.ok;


  //______________________________________
  // @section Color Tools
  //____________________________
  pub const color= struct {
    pub const Format = vk.color.Format;
    pub const rgba = struct {
      pub fn T (comptime t :type) type {
        return struct {r :t, g :t, b :t, a :t};
      } //:: zvk.color.rgba.T
      pub const F32 = zvk.color.rgba.T(f32);
      pub const U8  = zvk.color.rgba.T(u8);
    }; //:: zvk.color.rgba
  }; //:: zvk.color


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
    pub const default = struct {
      pub const version    = zvk.version.api.v1_3;
      pub const appName    = "zvk.Application";
      pub const appVers    = zvk.version.new(0, 0, 0);
      pub const engineName = "zvk.Engine";
      pub const engineVers = zvk.version.new(0, 0, 0);
    }; //:: zvk.cfg.default

    pub const debug = struct {
      pub const flags    = vk.validation.debug.flags.Create{};  // #define Cfg_DebugFlags 0
      pub const severity = vk.validation.debug.flags.Severity{  // Cfg_DebugSeverity
        .verbose = true,  // c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT
        .warning = true,  // c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT
        .Error   = true,  // c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT
        }; //:: zvk.cfg.debug.severity
      pub const msgType = vk.validation.debug.flags.MsgType{  // Cfg_DebugMsgType
        .general     = true,  // c.VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT
        .validation  = true,  // c.VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT
        .performance = true,  // c.VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT
        }; //:: zvk.cfg.debug.msgType
    }; //:: zvk.cfg.debug

    pub const device = struct {
      pub const forceFirst = true;
      pub const extensions = &.{vk.extensions.Swapchain};
      pub const present    = vk.device.present.Mailbox;
      pub const frames     = 2;
    }; //:: zvk.cfg.device

    pub const features = struct {
      pub const list = undefined;
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
    }; //:: zvk.features

    pub const swapchain = struct {
      pub const flags    = vk.flags.Swapchain{};
      pub const alpha    = vk.flags.CompositeAlpha{.Opaque=true};
      pub const clipped  = true;
      pub const color    = struct {
        pub const format = vk.color.format.srgb.BGRA8;
        pub const space  = vk.color.space.srgb.nonLinear;
      }; //:: zvk.cfg.swapchain.color
    }; //:: zvk.cfg.swapchain

    pub const shader = struct {
      pub const EntryPoint :zvk.String= "main";
    }; //:: zvk.cfg.shader

    pub const render = struct {
      pub const depth = struct {
        pub const reversed = true;
      }; //:: zvk.cfg.render.depth
    }; //:: zvk.cfg.render

    pub const command = struct {
      pub const reset     = true;
      pub const transient = false;
      pub const protected = false;
      pub const primary   = false;
    }; //:: zvk.cfg.command
  }; //:: zvk.cfg

  //______________________________________
  // @section Validation
  //____________________________
  pub const validation = struct {
    pub const active = if (zstd.debug) true else false;
    pub const layers = if (zvk.validation.active) .{vk.validation.LayerName} else .{};
    pub fn checkSupport (A :zvk.Allocator) !void {
      if (!zvk.validation.active) return;
      // Get the layer names
      const required = try vk.validation.instance.getLayers(A.zig);
      defer A.zig.free(required);
      // Check if the requested names exist in the list available layers
      search: {
        for (required) |ext| {
          const last = std.mem.indexOfScalar(u8, &ext.layerName, 0) orelse 0;
          if (std.mem.eql(u8, ext.layerName[0..last], vk.validation.LayerName)) break :search;
        }
        return error.zvk_validation_NotSupported;
      } //:: search
    } //:: zvk.validation.checkSupport

    pub const debug = struct {
      pub const Cfg      = vk.validation.debug.Cfg;
      pub const Callback = vk.validation.debug.Callback;
      pub const setup    = vk.validation.debug.setup;

      pub fn create (
          I : zvk.Instance,
          C : *const Cfg,
          A : zvk.Allocator,
        // ) !zvk.Debug {
        ) !vk.Debug {
        // Exit early if validation is not active
        if (!zvk.validation.active) return null;
        // Get the proc address (extensions must be manually loaded)
        const createMessenger :vk.validation.debug.Fn.Create= @ptrCast(vk.instance.getProc(I.ct, "vkCreateDebugUtilsMessengerEXT"));
        if (createMessenger == null) return error.vkGetInstanceProcAddr_Failed;
        // Run and return the result
        var result :vk.Debug= undefined;
        try vk.ok(createMessenger.?(I.ct, C, A.vk, &result));
        return result;
      } //:: zvk.validation.debug.create

      pub fn destroy (
          I : zvk.Instance,
          D : zvk.Debug,
          A : zvk.Allocator,
        ) !void {
        // Exit early if there is nothing to do
        if (D == null) return;
        // Get the proc address (extensions must be manually loaded)
        const destroyMessenger :vk.validation.debug.Fn.Destroy= @ptrCast(vk.instance.getProc(I.ct, "vkDestroyDebugUtilsMessengerEXT"));
        if (destroyMessenger == null) return error.vkGetInstanceProcAddr_Failed;
        // Run the proc
        destroyMessenger.?(I.ct, D, A.vk);
      } //:: zvk.validation.debug.destroy

      pub fn callback (
          severity  : vk.validation.debug.flags.C.Severity,
          typ       : vk.validation.debug.flags.C.MsgType,
          cbdata    : vk.validation.debug.CallbackData,
          userdata  : vk.validation.debug.Data,
        ) callconv(.C) vk.Bool {
        _=severity; _=typ; _=userdata;
        std.debug.print("[vulkan] {s}\n", .{cbdata.*.pMessage});
        return vk.False;  // Always return VK_FALSE. Used to test the validation layers themselves.
        // TODO: Cases
        // severity:
        //   VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT: Diagnostic message
        //   VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT: Informational message like the creation of a resource
        //   VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT: Message about behavior that is not necessarily an error, but very likely a bug in your application
        //   VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT: Message about behavior that is invalid and may cause crashes
        // typ:
        //   VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT: Some event has happened that is unrelated to the specification or performance
        //   VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT: Something has happened that violates the specification or indicates a possible mistake
        //   VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT: Potential non-optimal use of Vulkan
        // cbdata:
        // VkDebugUtilsMessengerCallbackDataEXT contains the details of the message. Most important members:
        //   pMessage    : The debug message as a null-terminated string
        //   pObjects    : Array of Vulkan object handles related to the message
        //   objectCount : Number of objects in array
      } //:: zvk.validation.debug.callback
    }; //:: zvk.validation.debug
  }; //:: zvk.validation

  //______________________________________
  // @section Application
  //____________________________
  pub const App = struct {
    pub const Cfg = vk.App.Cfg;
    pub fn new (in :struct {
        appName    : zvk.String  = zvk.cfg.default.appName,
        appVers    : zvk.Version = zvk.cfg.default.appVers,
        engineName : zvk.String  = zvk.cfg.default.engineName,
        engineVers : zvk.Version = zvk.cfg.default.engineVers,
      }) zvk.App.Cfg {
      return zvk.App.Cfg{
        .sType              = vk.stype.app.Cfg,         // @import("std").mem.zeroes(VkStructureType),
        .pNext              = null,                     // .pNext: ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
        .pApplicationName   = in.appName.ptr,           // .pApplicationName: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
        .applicationVersion = in.appVers,               // .applicationVersion: u32 = @import("std").mem.zeroes(u32),
        .pEngineName        = in.engineName.ptr,        // .pEngineName: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
        .engineVersion      = in.engineVers,            // .engineVersion: u32 = @import("std").mem.zeroes(u32),
        .apiVersion         = zvk.cfg.default.version,  // .apiVersion: u32 = @import("std").mem.zeroes(u32),
        }; //:: zvk.App.Cfg{ ... }
    } //:: zvk.App.defaults
  }; //:: zvk.App

  //______________________________________
  // @section Surface
  //____________________________
  pub const surface = struct {
    const Format       = vk.surface.Format;
    const Capabilities = vk.surface.Capabilities;
    pub const destroy  = vk.surface.destroy;
  }; //:: zvk.surface


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
        debugCfg   : *const zvk.validation.debug.Cfg,
        A          : zvk.Allocator,
      ) !zvk.Instance {
      // Get the Extensions
      var exts = try glfw.vk.instance.getExts(A.zig);  // FIX: Remove glfw from ZVK!!
      if (zstd.macos) try exts.append(vk.extensions.Portability); // Mac support with VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME : https://vulkan-tutorial.com/en/Drawing_a_triangle/Setup/Instance
      if (zvk.validation.active) try exts.append(vk.extensions.DebugUtils);
      // try vk.extensions.instance.supported(exts); // FIX: Missing vk.extensions.instance.supported
      // Get the Validation Layers
      try zvk.validation.checkSupport(A);
      const layerCount = zvk.validation.layers.len;
      var layers = if (zvk.validation.active) zvk.validation.layers[0].ptr else null;
      // Generate the result
      var result = zvk.Instance{.ct= undefined,
        .A                         = A,
        .cfg                       = vk.instance.Cfg{
          .sType                   = vk.stype.instance.Cfg,            // sType: VkStructureType = @import("std").mem.zeroes(VkStructureType),
          .pNext                   = debugCfg,                         // pNext: ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
          .flags                   = vk.flags.InstanceCreate.toInt(.{  // flags: VkInstanceCreateFlags = @import("std").mem.zeroes(VkInstanceCreateFlags),
            .enumeratePortability  = if (zstd.macos) true else false,
            }), //:: flags
          .pApplicationInfo        = &zvk.App.new(.{
            .appName               = in.appName,
            .appVers               = in.appVers,
            .engineName            = in.engineName,
            .engineVers            = in.engineVers,
            }), //:: pApplicationInfo                                  // pApplicationInfo: [*c]const VkApplicationInfo = @import("std").mem.zeroes([*c]const VkApplicationInfo),
          .enabledLayerCount       = layerCount,                       // enabledLayerCount: u32 = @import("std").mem.zeroes(u32),
          .ppEnabledLayerNames     = &layers,                          // ppEnabledLayerNames: [*c]const [*c]const u8 = @import("std").mem.zeroes([*c]const [*c]const u8),
          .enabledExtensionCount   = @intCast(exts.items.len),         // enabledExtensionCount: u32 = @import("std").mem.zeroes(u32),
          .ppEnabledExtensionNames = exts.items.ptr,                   // ppEnabledExtensionNames: [*c]const [*c]const u8 = @import("std").mem.zeroes([*c]const [*c]const u8),
        }}; //:: zvk.Instance{ ... }
      try vk.instance.create(&result.cfg, result.A.vk, &result.ct);
      return result;
    } //:: zvk.Instance.create
    pub fn destroy (I :*zvk.Instance) void { vk.instance.destroy(I.ct, I.A.vk); }
  }; //:: zvk.Instance

  pub const Features = zvk.features.List;
  pub const features = struct {
    pub const List = struct {
      list  :Flags,
      const Flags    = std.EnumSet(zvk.Features.Flag);
      const InitVals = std.enums.EnumFieldStruct(zvk.Features.Flag, bool, false);
      pub fn create () zvk.features.List { return zvk.features.List{.list= Flags.initEmpty()}; }
      pub fn init   (L :zvk.Features.InitVals) zvk.features.List { return zvk.features.List{.list= Flags.init(L)}; }
      pub fn incl   (L :*zvk.features.List, V :zvk.Features.Flag) void { L.list.insert(V); }
      pub fn excl   (L :*zvk.features.List, V :zvk.Features.Flag) void { L.list.remove(V); }
      pub fn has    (L :*const zvk.features.List, V :zvk.Features.Flag) bool { return L.list.contains(V); }
      pub fn hasVk  (L :*const zvk.features.List, V :zvk.Features.Flag) vk.Bool { return vk.toBool(L.has(V)); }

      pub const Flag = enum {
        shader_atomics_int64_buffer,                           // v12 :: shaderBufferInt64Atomics
        shader_atomics_int64_shared,                           // v12 :: shaderSharedInt64Atomics
        shader_dynamicIndexing_UniformBufferArray,             // v10 :: shaderUniformBufferArrayDynamicIndexing
        shader_dynamicIndexing_sampledImageArray,              // v10 :: shaderSampledImageArrayDynamicIndexing
        shader_dynamicIndexing_storageBufferArray,             // v10 :: shaderStorageBufferArrayDynamicIndexing
        shader_dynamicIndexing_storageImageArray,              // v10 :: shaderStorageImageArrayDynamicIndexing
        shader_dynamicIndexing_InputAttachmentArray,           // v12 :: shaderInputAttachmentArrayDynamicIndexing
        shader_dynamicIndexing_UniformTexelBufferArray,        // v12 :: shaderUniformTexelBufferArrayDynamicIndexing
        shader_dynamicIndexing_storageTexelBufferArray,        // v12 :: shaderStorageTexelBufferArrayDynamicIndexing
        shader_nonUniformIndexing_UniformBufferArray,          // v12 :: shaderUniformBufferArrayNonUniformIndexing
        shader_nonUniformIndexing_sampledImageArray,           // v12 :: shaderSampledImageArrayNonUniformIndexing
        shader_nonUniformIndexing_storageBufferArray,          // v12 :: shaderStorageBufferArrayNonUniformIndexing
        shader_nonUniformIndexing_storageImageArray,           // v12 :: shaderStorageImageArrayNonUniformIndexing
        shader_nonUniformIndexing_InputAttachmentArray,        // v12 :: shaderInputAttachmentArrayNonUniformIndexing
        shader_nonUniformIndexing_UniformTexelBufferArray,     // v12 :: shaderUniformTexelBufferArrayNonUniformIndexing
        shader_nonUniformIndexing_storageTexelBufferArray,     // v12 :: shaderStorageTexelBufferArrayNonUniformIndexing
        shader_output_viewportIndex,                           // v12 :: shaderOutputViewportIndex
        shader_output_layer,                                   // v12 :: shaderOutputLayer
        shader_invocation_demoteToHelper,                      // v13 :: shaderDemoteToHelperInvocation
        shader_invocation_terminate,                           // v13 :: shaderTerminateInvocation
        shader_workgroup_zeroInitializeMemory,                 // v13 :: shaderZeroInitializeWorkgroupMemory
        shader_integerDotProduct,                              // v13 :: shaderIntegerDotProduct
        shader_drawParameters,                                 // v11 :: shaderDrawParameters
        shader_image_gatherExtended,                           // v10 :: shaderImageGatherExtended
        shader_storageImage_extendedFormats,                   // v10 :: shaderStorageImageExtendedFormats
        shader_storageImage_multisample,                       // v10 :: shaderStorageImageMultisample
        shader_storageImage_readWithoutFormat,                 // v10 :: shaderStorageImageReadWithoutFormat
        shader_storageImage_writeWithoutFormat,                // v10 :: shaderStorageImageWriteWithoutFormat
        shader_clipDistance,                                   // v10 :: shaderClipDistance
        shader_cullDistance,                                   // v10 :: shaderCullDistance
        shader_int8,                                           // v12 :: shaderInt8
        shader_int16,                                          // v10 :: shaderInt16
        shader_int64,                                          // v11 :: shaderInt64
        shader_float16,                                        // v12 :: shaderFloat16
        shader_float64,                                        // v10 :: shaderFloat64
        shader_resource_residency,                             // v10 :: shaderResourceResidency
        shader_resource_minLoD,                                // v10 :: shaderResourceMinLod
        shader_subgroup_extendedTypes,                         // v12 :: shaderSubgroupExtendedTypes
        shader_geometry,                                       // v10 :: geometryShader
        shader_tessellation,                                   // v10 :: tessellationShader
        shader_tessellationAndGeometry_pointSize,              // v10 :: shaderTessellationAndGeometryPointSize

        image_robustAccess,                                    // v13 :: robustImageAccess
        image_cubeArray,                                       // v10 :: imageCubeArray
        sampler_YCBCRConversion,                               // v11 :: samplerYcbcrConversion
        sampler_mirrorClampToEdge,                             // v12 ::
        sampler_filterMinmax,                                  // v12 :: samplerFilterMinmax
        sampler_anisotropy,                                    // v10 :: samplerAnisotropy
        texture_compressionASTC_HDR,                           // v13 :: textureCompressionASTC_HDR
        texture_compressionETC2,                               // v10 :: textureCompressionETC2
        texture_compressionASTC_LDR,                           // v10 :: textureCompressionASTC_LDR
        texture_compressionBC,                                 // v10 :: textureCompressionBC

        pipeline_creationCacheControl,                         // v13 :: pipelineCreationCacheControl
        pipeline_statisticsQuery,                              // v10 :: pipelineStatisticsQuery
        pipeline_vertex_storesAndAtomics,                      // v10 :: vertexPipelineStoresAndAtomics
        pipeline_fragment_storesAndAtomics,                    // v10 :: fragmentStoresAndAtomics

        compute_subgroupSizeControl,                           // v13 :: subgroupSizeControl
        compute_subgroupBroadcastDynamicId,                    // v12 :: subgroupBroadcastDynamicId
        compute_subgroupsFull,                                 // v13 :: computeFullSubgroups

        dynamicRendering,                                      // v13 :: dynamicRendering
        synchronization2,                                      // v13 :: synchronization2
        maintenance4,                                          // v13 :: maintenance4

        buffer_robustAccess,                                   // v10 :: robustBufferAccess
        buffer_uniform_inlineBlock,                            // v13 :: inlineUniformBlock
        buffer_uniform_standardLayout,                         // v12 :: uniformBufferStandardLayout
        buffer_storage_access8Bit,                             // v12 :: storageBuffer8BitAccess
        buffer_storage_access16Bit,                            // v11 :: storageBuffer16BitAccess
        buffer_storage_pushConstant8,                          // v12 :: storagePushConstant8
        buffer_storage_pushConstant16,                         // v11 :: storagePushConstant16
        buffer_storage_inputOutput16,                          // v11 :: storageInputOutput16
        buffer_uniformAndStorage_access8Bit,                   // v12 :: uniformAndStorageBuffer8BitAccess
        buffer_uniformAndStorage_access16Bit,                  // v11 :: uniformAndStorageBuffer16BitAccess
        buffer_deviceAddress,                                  // v12 :: bufferDeviceAddress
        buffer_deviceAddress_captureReplay,                    // v12 :: bufferDeviceAddressCaptureReplay
        buffer_deviceAddress_multiDevice,                      // v12 :: bufferDeviceAddressMultiDevice

        descriptor_indexing,                                   // v12 :: descriptorIndexing
        descriptor_runtimeArray,                               // v12 :: runtimeDescriptorArray
        descriptor_binding_updateAfterBind_uniformBuffer,      // v12 :: descriptorBindingUniformBufferUpdateAfterBind
        descriptor_binding_updateAfterBind_sampledImage,       // v12 :: descriptorBindingSampledImageUpdateAfterBind
        descriptor_binding_updateAfterBind_storageImage,       // v12 :: descriptorBindingStorageImageUpdateAfterBind
        descriptor_binding_updateAfterBind_storageBuffer,      // v12 :: descriptorBindingStorageBufferUpdateAfterBind
        descriptor_binding_updateAfterBind_uniformTexelBuffer, // v12 :: descriptorBindingUniformTexelBufferUpdateAfterBind
        descriptor_binding_updateAfterBind_storageTexelBuffer, // v12 :: descriptorBindingStorageTexelBufferUpdateAfterBind
        descriptor_binding_updateAfterBind_inlineUniformBlock, // v13 :: descriptorBindingInlineUniformBlockUpdateAfterBind
        descriptor_binding_updateUnusedWhilePending,           // v12 :: descriptorBindingUpdateUnusedWhilePending
        descriptor_binding_partiallyBound,                     // v12 :: descriptorBindingPartiallyBound
        descriptor_binding_variableDescriptorCount,            // v12 :: descriptorBindingVariableDescriptorCount

        framebuffer_imageless,                                 // v12 :: imagelessFramebuffer

        separateDepthStencilLayouts,                           // v12 :: separateDepthStencilLayouts
        timelineSemaphore,                                     // v12 :: timelineSemaphore

        query_hostReset,                                       // v12 :: hostQueryReset
        query_preciseOcclusion,                                // v10 :: occlusionQueryPrecise
        query_inherited,                                       // v10 :: inheritedQueries

        memory_scalarBlockLayout,                              // v12 :: scalarBlockLayout
        memory_protected,                                      // v11 :: protectedMemory
        memory_privateData,                                    // v13 :: privateData
        memory_vulkanModel,                                    // v12 :: vulkanMemoryModel
        memory_vulkanModel_deviceScope,                        // v12 :: vulkanMemoryModelDeviceScope
        memory_vulkanModel_availabilityVisibilityChains,       // v12 :: vulkanMemoryModelAvailabilityVisibilityChains

        draw_indirectCount,                                    // v12 :: drawIndirectCount
        draw_indirectFirstInstance,                            // v10 :: drawIndirectFirstInstance
        draw_multiview,                                        // v11 :: multiview
        draw_multiview_geometryShader,                         // v11 :: multiviewGeometryShader
        draw_multiview_tessellationShader,                     // v11 :: multiviewTessellationShader
        draw_multiViewport,                                    // v10 :: multiViewport
        draw_multiDrawIndirect,                                // v10 :: multiDrawIndirect
        draw_fullDrawIndexUint32,                              // v10 :: fullDrawIndexUint32
        draw_fillModeNonSolid,                                 // v10 :: fillModeNonSolid
        draw_wideLines,                                        // v10 :: wideLines
        draw_largePoints,                                      // v10 :: largePoints

        variablePointers_storageBuffer,                        // v11 :: variablePointersStorageBuffer
        variablePointers,                                      // v11 :: variablePointers
        variableMultisampleRate,                               // v10 :: variableMultisampleRate

        blend_independent,                                     // v10 :: independentBlend
        blend_dualSrc,                                         // v10 :: dualSrcBlend

        depth_clamp,                                           // v10 :: depthClamp
        depth_biasClamp,                                       // v10 :: depthBiasClamp
        depth_bounds,                                          // v10 :: depthBounds

        alphaToOne,                                            // v10 :: alphaToOne
        sampleRateShading,                                     // v10 :: sampleRateShading
        logicOp,                                               // v10 :: logicOp

        sparse_binding,                                        // v10 :: sparseBinding
        sparse_residencyBuffer,                                // v10 :: sparseResidencyBuffer
        sparse_residencyImage2D,                               // v10 :: sparseResidencyImage2D
        sparse_residencyImage3D,                               // v10 :: sparseResidencyImage3D
        sparse_residency2Samples,                              // v10 :: sparseResidency2Samples
        sparse_residency4Samples,                              // v10 :: sparseResidency4Samples
        sparse_residency8Samples,                              // v10 :: sparseResidency8Samples
        sparse_residency16Samples,                             // v10 :: sparseResidency16Samples
        sparse_residencyAliased,                               // v10 :: sparseResidencyAliased
      }; //:: zvk.features.Flag

      pub fn defaults () zvk.features.List {
        var result = zvk.features.List.create();
        // Modern Vulkan
        result.incl(.dynamicRendering);                                      // 1.3 core
        result.incl(.synchronization2);                                      // 1.3 core
        result.incl(.maintenance4);                                          // 1.3 core
        // Modern Vulkan: Bindless Resources
        result.incl(.descriptor_binding_updateAfterBind_sampledImage);       // 1.2 core. Bindless Images
        result.incl(.descriptor_binding_updateAfterBind_storageImage);       // 1.2 core. Bindless SS.Images
        result.incl(.descriptor_binding_updateAfterBind_storageBuffer);      // 1.2 core. Bindless SS.Buffers
        result.incl(.descriptor_binding_updateAfterBind_storageTexelBuffer); // 1.2 core. Bindless Texel SS.Buffers
        result.incl(.descriptor_binding_partiallyBound);                     // 1.2 core. Support binding invalid resources, as long as they are not accessed on shaders
        // HCC Requirements: Core
        result.incl(.memory_vulkanModel);                                    // 1.2 core : https://docs.vulkan.org/spec/latest/appendices/memorymodel.html#memory-model
        result.incl(.memory_vulkanModel_deviceScope);                        // 1.2 core : https://docs.vulkan.org/spec/latest/appendices/memorymodel.html#memory-model
        result.incl(.memory_scalarBlockLayout);                              // 1.2 core. For CPU interop. Allow block resources to use scalar alignment (C-like).
        result.incl(.shader_invocation_demoteToHelper);                      // 1.3 core
        // HCC Requirements: Extras
        result.incl(.pipeline_fragment_storesAndAtomics);                    // Allow write access to SSBO/Images in fragment shaders
        result.incl(.shader_nonUniformIndexing_sampledImageArray);           // Non-uniform indexing for Images
        result.incl(.shader_nonUniformIndexing_storageBufferArray);          // Non-uniform indexing for SS.Buffers
        result.incl(.shader_nonUniformIndexing_storageImageArray);           // Non-uniform indexing for SS.Images
        result.incl(.shader_nonUniformIndexing_storageTexelBufferArray);     // Non-uniform indexing for Texel SS.Buffers
        return result;
      } //:: zvk.features.List.defaults

      pub fn toVulkan (L :*const zvk.Features, A :zvk.Allocator) !zvk.features.Vulkan {
        // Allocate the objects
        var result = try zvk.features.Vulkan.create(A);
        result.v13.descriptorBindingInlineUniformBlockUpdateAfterBind = L.hasVk(.descriptor_binding_updateAfterBind_inlineUniformBlock);
        result.v13.privateData                                        = L.hasVk(.memory_privateData);
        result.v13.shaderDemoteToHelperInvocation                     = L.hasVk(.shader_invocation_demoteToHelper);
        result.v13.shaderTerminateInvocation                          = L.hasVk(.shader_invocation_terminate);
        result.v13.shaderZeroInitializeWorkgroupMemory                = L.hasVk(.shader_workgroup_zeroInitializeMemory);
        result.v13.shaderIntegerDotProduct                            = L.hasVk(.shader_integerDotProduct);
        result.v13.robustImageAccess                                  = L.hasVk(.image_robustAccess);
        result.v13.textureCompressionASTC_HDR                         = L.hasVk(.texture_compressionASTC_HDR);
        result.v13.pipelineCreationCacheControl                       = L.hasVk(.pipeline_creationCacheControl);
        result.v13.subgroupSizeControl                                = L.hasVk(.compute_subgroupSizeControl);
        result.v13.computeFullSubgroups                               = L.hasVk(.compute_subgroupsFull);
        result.v13.dynamicRendering                                   = L.hasVk(.dynamicRendering);
        result.v13.synchronization2                                   = L.hasVk(.synchronization2);
        result.v13.maintenance4                                       = L.hasVk(.maintenance4);
        result.v13.inlineUniformBlock                                 = L.hasVk(.buffer_uniform_inlineBlock);

        result.v12.shaderBufferInt64Atomics                           = L.hasVk(.shader_atomics_int64_buffer);
        result.v12.shaderSharedInt64Atomics                           = L.hasVk(.shader_atomics_int64_shared);
        result.v12.shaderInputAttachmentArrayDynamicIndexing          = L.hasVk(.shader_dynamicIndexing_InputAttachmentArray);
        result.v12.shaderUniformTexelBufferArrayDynamicIndexing       = L.hasVk(.shader_dynamicIndexing_UniformTexelBufferArray);
        result.v12.shaderStorageTexelBufferArrayDynamicIndexing       = L.hasVk(.shader_dynamicIndexing_storageTexelBufferArray);
        result.v12.shaderUniformBufferArrayNonUniformIndexing         = L.hasVk(.shader_nonUniformIndexing_UniformBufferArray);
        result.v12.shaderSampledImageArrayNonUniformIndexing          = L.hasVk(.shader_nonUniformIndexing_sampledImageArray);
        result.v12.shaderStorageBufferArrayNonUniformIndexing         = L.hasVk(.shader_nonUniformIndexing_storageBufferArray);
        result.v12.shaderStorageImageArrayNonUniformIndexing          = L.hasVk(.shader_nonUniformIndexing_storageImageArray);
        result.v12.shaderInputAttachmentArrayNonUniformIndexing       = L.hasVk(.shader_nonUniformIndexing_InputAttachmentArray);
        result.v12.shaderUniformTexelBufferArrayNonUniformIndexing    = L.hasVk(.shader_nonUniformIndexing_UniformTexelBufferArray);
        result.v12.shaderStorageTexelBufferArrayNonUniformIndexing    = L.hasVk(.shader_nonUniformIndexing_storageTexelBufferArray);
        result.v12.shaderOutputViewportIndex                          = L.hasVk(.shader_output_viewportIndex);
        result.v12.shaderOutputLayer                                  = L.hasVk(.shader_output_layer);
        result.v12.samplerMirrorClampToEdge                           = L.hasVk(.sampler_mirrorClampToEdge);
        result.v12.samplerFilterMinmax                                = L.hasVk(.sampler_filterMinmax);
        result.v12.subgroupBroadcastDynamicId                         = L.hasVk(.compute_subgroupBroadcastDynamicId);
        result.v12.drawIndirectCount                                  = L.hasVk(.draw_indirectCount);
        result.v12.shaderFloat16                                      = L.hasVk(.shader_float16);
        result.v12.shaderInt8                                         = L.hasVk(.shader_int8);
        result.v12.shaderSubgroupExtendedTypes                        = L.hasVk(.shader_subgroup_extendedTypes);
        result.v12.uniformBufferStandardLayout                        = L.hasVk(.buffer_uniform_standardLayout);
        result.v12.storageBuffer8BitAccess                            = L.hasVk(.buffer_storage_access8Bit);
        result.v12.storagePushConstant8                               = L.hasVk(.buffer_storage_pushConstant8);
        result.v12.uniformAndStorageBuffer8BitAccess                  = L.hasVk(.buffer_uniformAndStorage_access8Bit);
        result.v12.bufferDeviceAddress                                = L.hasVk(.buffer_deviceAddress);
        result.v12.bufferDeviceAddressCaptureReplay                   = L.hasVk(.buffer_deviceAddress_captureReplay);
        result.v12.bufferDeviceAddressMultiDevice                     = L.hasVk(.buffer_deviceAddress_multiDevice);
        result.v12.descriptorIndexing                                 = L.hasVk(.descriptor_indexing);
        result.v12.runtimeDescriptorArray                             = L.hasVk(.descriptor_runtimeArray);
        result.v12.descriptorBindingUniformBufferUpdateAfterBind      = L.hasVk(.descriptor_binding_updateAfterBind_uniformBuffer);
        result.v12.descriptorBindingSampledImageUpdateAfterBind       = L.hasVk(.descriptor_binding_updateAfterBind_sampledImage);
        result.v12.descriptorBindingStorageImageUpdateAfterBind       = L.hasVk(.descriptor_binding_updateAfterBind_storageImage);
        result.v12.descriptorBindingStorageBufferUpdateAfterBind      = L.hasVk(.descriptor_binding_updateAfterBind_storageBuffer);
        result.v12.descriptorBindingUniformTexelBufferUpdateAfterBind = L.hasVk(.descriptor_binding_updateAfterBind_uniformTexelBuffer);
        result.v12.descriptorBindingStorageTexelBufferUpdateAfterBind = L.hasVk(.descriptor_binding_updateAfterBind_storageTexelBuffer);
        result.v12.descriptorBindingUpdateUnusedWhilePending          = L.hasVk(.descriptor_binding_updateUnusedWhilePending);
        result.v12.descriptorBindingPartiallyBound                    = L.hasVk(.descriptor_binding_partiallyBound);
        result.v12.descriptorBindingVariableDescriptorCount           = L.hasVk(.descriptor_binding_variableDescriptorCount);
        result.v12.imagelessFramebuffer                               = L.hasVk(.framebuffer_imageless);
        result.v12.separateDepthStencilLayouts                        = L.hasVk(.separateDepthStencilLayouts);
        result.v12.timelineSemaphore                                  = L.hasVk(.timelineSemaphore);
        result.v12.hostQueryReset                                     = L.hasVk(.query_hostReset);
        result.v12.scalarBlockLayout                                  = L.hasVk(.memory_scalarBlockLayout);
        result.v12.vulkanMemoryModel                                  = L.hasVk(.memory_vulkanModel);
        result.v12.vulkanMemoryModelDeviceScope                       = L.hasVk(.memory_vulkanModel_deviceScope);
        result.v12.vulkanMemoryModelAvailabilityVisibilityChains      = L.hasVk(.memory_vulkanModel_availabilityVisibilityChains);

        result.v11.shaderDrawParameters                               = L.hasVk(.shader_drawParameters);
        result.v11.samplerYcbcrConversion                             = L.hasVk(.sampler_YCBCRConversion);
        result.v11.storageBuffer16BitAccess                           = L.hasVk(.buffer_storage_access16Bit);
        result.v11.storagePushConstant16                              = L.hasVk(.buffer_storage_pushConstant16);
        result.v11.storageInputOutput16                               = L.hasVk(.buffer_storage_inputOutput16);
        result.v11.uniformAndStorageBuffer16BitAccess                 = L.hasVk(.buffer_uniformAndStorage_access16Bit);
        result.v11.protectedMemory                                    = L.hasVk(.memory_protected);
        result.v11.multiview                                          = L.hasVk(.draw_multiview);
        result.v11.multiviewGeometryShader                            = L.hasVk(.draw_multiview_geometryShader);
        result.v11.multiviewTessellationShader                        = L.hasVk(.draw_multiview_tessellationShader);
        result.v11.variablePointersStorageBuffer                      = L.hasVk(.variablePointers_storageBuffer);
        result.v11.variablePointers                                   = L.hasVk(.variablePointers);

        result.v10.shaderUniformBufferArrayDynamicIndexing            = L.hasVk(.shader_dynamicIndexing_UniformBufferArray);
        result.v10.shaderSampledImageArrayDynamicIndexing             = L.hasVk(.shader_dynamicIndexing_sampledImageArray);
        result.v10.shaderStorageBufferArrayDynamicIndexing            = L.hasVk(.shader_dynamicIndexing_storageBufferArray);
        result.v10.shaderStorageImageArrayDynamicIndexing             = L.hasVk(.shader_dynamicIndexing_storageImageArray);
        result.v10.shaderImageGatherExtended                          = L.hasVk(.shader_image_gatherExtended);
        result.v10.shaderStorageImageExtendedFormats                  = L.hasVk(.shader_storageImage_extendedFormats);
        result.v10.shaderStorageImageMultisample                      = L.hasVk(.shader_storageImage_multisample);
        result.v10.shaderStorageImageReadWithoutFormat                = L.hasVk(.shader_storageImage_readWithoutFormat);
        result.v10.shaderStorageImageWriteWithoutFormat               = L.hasVk(.shader_storageImage_writeWithoutFormat);
        result.v10.shaderClipDistance                                 = L.hasVk(.shader_clipDistance);
        result.v10.shaderCullDistance                                 = L.hasVk(.shader_cullDistance);
        result.v10.shaderInt16                                        = L.hasVk(.shader_int16);
        result.v10.shaderInt64                                        = L.hasVk(.shader_int64);
        result.v10.shaderFloat64                                      = L.hasVk(.shader_float64);
        result.v10.shaderResourceResidency                            = L.hasVk(.shader_resource_residency);
        result.v10.shaderResourceMinLod                               = L.hasVk(.shader_resource_minLoD);
        result.v10.geometryShader                                     = L.hasVk(.shader_geometry);
        result.v10.tessellationShader                                 = L.hasVk(.shader_tessellation);
        result.v10.shaderTessellationAndGeometryPointSize             = L.hasVk(.shader_tessellationAndGeometry_pointSize);
        result.v10.imageCubeArray                                     = L.hasVk(.image_cubeArray);
        result.v10.samplerAnisotropy                                  = L.hasVk(.sampler_anisotropy);
        result.v10.textureCompressionETC2                             = L.hasVk(.texture_compressionETC2);
        result.v10.textureCompressionASTC_LDR                         = L.hasVk(.texture_compressionASTC_LDR);
        result.v10.textureCompressionBC                               = L.hasVk(.texture_compressionBC);
        result.v10.pipelineStatisticsQuery                            = L.hasVk(.pipeline_statisticsQuery);
        result.v10.vertexPipelineStoresAndAtomics                     = L.hasVk(.pipeline_vertex_storesAndAtomics);
        result.v10.fragmentStoresAndAtomics                           = L.hasVk(.pipeline_fragment_storesAndAtomics);
        result.v10.robustBufferAccess                                 = L.hasVk(.buffer_robustAccess);
        result.v10.occlusionQueryPrecise                              = L.hasVk(.query_preciseOcclusion);
        result.v10.inheritedQueries                                   = L.hasVk(.query_inherited);
        result.v10.multiViewport                                      = L.hasVk(.draw_multiViewport);
        result.v10.drawIndirectFirstInstance                          = L.hasVk(.draw_indirectFirstInstance);
        result.v10.multiDrawIndirect                                  = L.hasVk(.draw_multiDrawIndirect);
        result.v10.fullDrawIndexUint32                                = L.hasVk(.draw_fullDrawIndexUint32);
        result.v10.fillModeNonSolid                                   = L.hasVk(.draw_fillModeNonSolid);
        result.v10.wideLines                                          = L.hasVk(.draw_wideLines);
        result.v10.largePoints                                        = L.hasVk(.draw_largePoints);
        result.v10.variableMultisampleRate                            = L.hasVk(.variableMultisampleRate);
        result.v10.independentBlend                                   = L.hasVk(.blend_independent);
        result.v10.dualSrcBlend                                       = L.hasVk(.blend_dualSrc);
        result.v10.depthClamp                                         = L.hasVk(.depth_clamp);
        result.v10.depthBiasClamp                                     = L.hasVk(.depth_biasClamp);
        result.v10.depthBounds                                        = L.hasVk(.depth_bounds);
        result.v10.alphaToOne                                         = L.hasVk(.alphaToOne);
        result.v10.sampleRateShading                                  = L.hasVk(.sampleRateShading);
        result.v10.logicOp                                            = L.hasVk(.logicOp);
        result.v10.sparseBinding                                      = L.hasVk(.sparse_binding);
        result.v10.sparseResidencyBuffer                              = L.hasVk(.sparse_residencyBuffer);
        result.v10.sparseResidencyImage2D                             = L.hasVk(.sparse_residencyImage2D);
        result.v10.sparseResidencyImage3D                             = L.hasVk(.sparse_residencyImage3D);
        result.v10.sparseResidency2Samples                            = L.hasVk(.sparse_residency2Samples);
        result.v10.sparseResidency4Samples                            = L.hasVk(.sparse_residency4Samples);
        result.v10.sparseResidency8Samples                            = L.hasVk(.sparse_residency8Samples);
        result.v10.sparseResidency16Samples                           = L.hasVk(.sparse_residency16Samples);
        result.v10.sparseResidencyAliased                             = L.hasVk(.sparse_residencyAliased);
        return result;
      } //:: zvk.features.List.toVulkan
    }; //:: zvk.features.List

    pub const Vulkan = struct {
      A    : zvk.Allocator,
      root : *vk.features.Root,
      v10  : *vk.features.V10,
      v11  : *vk.features.V11,
      v12  : *vk.features.V12,
      v13  : *vk.features.V13,

      pub fn destroy (L :*zvk.features.Vulkan) void {
        L.A.zig.destroy(L.v13);
        L.A.zig.destroy(L.v12);
        L.A.zig.destroy(L.v11);
        L.A.zig.destroy(L.v10);
        L.A.zig.destroy(L.root);
        L.v10 = undefined;
      } //:: zvk.features.Vulkan.destroy

      pub fn create (A :zvk.Allocator) !zvk.features.Vulkan {
        var result  :zvk.features.Vulkan= undefined;
        result.A          = A;
        result.root       = try result.A.zig.create(vk.features.Root);
        result.v11        = try result.A.zig.create(vk.features.V11);
        result.v12        = try result.A.zig.create(vk.features.V12);
        result.v13        = try result.A.zig.create(vk.features.V13);
        // Structure Types
        result.root.sType = vk.stype.device.Features10;
        result.v11.sType  = vk.stype.device.Features11;
        result.v12.sType  = vk.stype.device.Features12;
        result.v13.sType  = vk.stype.device.Features13;
        // Create the chain
        result.v10        = &result.root.features;
        result.root.pNext = result.v11;
        result.v11.pNext  = result.v12;
        result.v12.pNext  = result.v13;
        result.v13.pNext  = null;
        return result;
      } //:: zvk.features.Vulkan.create
    }; //:: zvk.features.Vulkan
  }; //:: zvk.features

  //______________________________________
  // @section Device
  //____________________________
  pub const Device = struct {
    A         :zvk.Allocator,
    physical  :zvk.Device.Physical,
    logical   :zvk.Device.Logical,
    queue     :zvk.Device.Queue,

    pub const PresentMode = vk.device.present.Mode;

    pub fn create (
       I : zvk.Instance,
       S : zvk.Surface,
       A : zvk.Allocator,
      ) !zvk.Device {
      const feats = zvk.Features.defaults();
      const exts :[]const zvk.Device.extensions.Name= zvk.cfg.device.extensions;
      var result = zvk.Device{.A=A, .physical=undefined, .logical=undefined, .queue= undefined, };
      result.physical = try zvk.Device.Physical.create(I, S, exts, feats, A);
      result.logical  = try zvk.Device.Logical.create(result.physical, S, exts, feats, A);
      result.queue    = try zvk.Device.Queue.create(result.physical, result.logical, S, A);
      return result;
    } //:: zvk.Device.create

    pub fn destroy (D :*zvk.Device) void {
      D.physical.destroy();
      D.logical.destroy();
    }

    //______________________________________
    // @section Device: Extensions
    //____________________________
    pub const Extensions = zvk.Device.extensions.CList;
    pub const extensions = struct {
      pub const Name       = vk.String;
      pub const List       = []zvk.Device.extensions.Name;
      pub const CList      = []const zvk.Device.extensions.Name;
      pub const Properties = []vk.extensions.Properties;

      /// Returns the list of all available device extension names
      pub fn getProperties (
          D : zvk.Device.Physical,
          A : zvk.Allocator,
        ) !zvk.Device.extensions.Properties {
        // Get the list of extension properties
        var count :u32= 0;
        try vk.ok(vk.device.extensions.getProperties(D.ct, null, &count, null));
        const result = try A.zig.alloc(vk.device.extensions.Properties, count);
        try vk.ok(vk.device.extensions.getProperties(D.ct, null, &count, result.ptr));
        return result;
      } //:: zvk.Device.extensions.getProperties

      /// Returns whether or not the {@arg L} list of extension properties constains the {@arg N} extension name
      pub fn contains (
          L : zvk.Device.extensions.Properties,
          N : zvk.Device.extensions.Name,
        ) bool {
        for (L) |P| {
          const last = std.mem.indexOfScalar(u8, &P.extensionName, 0) orelse 0;
          if (std.mem.eql(u8, P.extensionName[0..last], N)) return true;
        }
        return false;
      } //:: zvk.Device.extensions.contains

      /// Returns whether or not the {@arg D} device supports all extensions in the {@arg L} list.
      pub fn supportsAll (
          D : zvk.Device.Physical,
          L : zvk.Device.Extensions,
          A : zvk.Allocator,
        ) !bool {
        const available = try zvk.Device.extensions.getProperties(D, A);
        defer A.zig.free(available);
        for (L) |ext| if (!zvk.Device.extensions.contains(available, ext)) return false;
        return true;
      } //:: zvk.Device.extensions.supportsAll
    }; //:: zvk.Device.extensions


    //______________________________________
    // @section Device: Features
    //____________________________
    pub const features = struct {
      pub fn getList (
          D : zvk.Device.Physical,
        ) vk.device.physical.Features {
        var result = vk.device.physical.Features{};
        vk.device.physical.getFeatures(D.ct, &result);
        return result;
      } //:: zvk.Device.features.getList

      pub fn supportsAll (
          D : zvk.Device.Physical,
          F : zvk.Features,
        ) bool {
        // FIX: Check that all of the desired features are supported
        _ = zvk.Device.features.getList(D); // Available
        _ = F;
      } //:: zvk.Device.features.supportsAll
    }; //:: zvk.Device.features


    //______________________________________
    // @section Device: Physical
    //____________________________
    pub const Physical = struct {
      A    :zvk.Allocator,
      ct   :vk.device.Physical,
      all  :[]const vk.Device.Physical,

      pub const SwapchainSupport = struct {
        A        :zvk.Allocator,
        caps     :vk.surface.Capabilities,
        formats  :[]vk.surface.Format,
        modes    :[]vk.device.present.Mode,

        pub fn getCapabilities (
            D : zvk.Device.Physical,
            S : zvk.Surface,
          ) !vk.surface.Capabilities {
          var result = vk.surface.Capabilities{};
          try vk.ok(vk.device.physical.surface.getCapabilities(D.ct, S, &result));
          return result;
        }

        pub fn getFormats (
            D : zvk.Device.Physical,
            S : zvk.Surface,
            A : zvk.Allocator,
          ) ![]vk.surface.Format {
          var result :[]vk.surface.Format= &.{};
          var count :u32= 0;
          try vk.ok(vk.device.physical.surface.getFormats(D.ct, S, &count, null));
          if (count > 0) {
            result = try A.zig.alloc(vk.surface.Format, count);
            try vk.ok(vk.device.physical.surface.getFormats(D.ct, S, &count, result.ptr));
          } else return error.device_NoSurfaceFormats;
          return result;
        }

        pub fn getPresentModes (
            D : zvk.Device.Physical,
            S : zvk.Surface,
            A : zvk.Allocator,
          ) ![]vk.device.present.Mode {
          var result :[]vk.device.present.Mode= &.{};
          var count :u32= 0;
          try vk.ok(vk.device.physical.surface.getPresentModes(D.ct, S, &count, null));
          if (count > 0) {
            result = try A.zig.alloc(vk.device.present.Mode, count);
            try vk.ok(vk.device.physical.surface.getPresentModes(D.ct, S, &count, result.ptr));
          } else return error.device_NoPresentModes;
          return result;
        }

        pub fn hasSwapchain (S :*const SwapchainSupport) bool {
          return S.formats.len > 0 and S.modes.len > 0;
        }

        /// Returns the Swapchain support information for the given Device+Surface
        /// Allocates memory for its formats and modes lists
        pub fn create (
            D : zvk.Device.Physical,
            S : zvk.Surface,
            A : zvk.Allocator,
          ) !SwapchainSupport {
          return zvk.Device.Physical.SwapchainSupport{
            .A       = A,
            .caps    = try SwapchainSupport.getCapabilities(D, S),    // Surface Capabilities
            .formats = try SwapchainSupport.getFormats(D, S, A),      // Surface Formats
            .modes   = try SwapchainSupport.getPresentModes(D, S, A), // Present Modes
             };
        } //:: zvk.Device.Physical.SwapchainSupport.create

        pub fn destroy (
            S : *zvk.Device.Physical.SwapchainSupport,
          ) void {
          S.caps = .{};
          S.A.zig.free(S.formats);
          S.A.zig.free(S.modes);
        } //:: zvk.Device.Physical.SwapchainSupport.destroy
      }; //:: zvk.Device.Physical.SwapchainSupport

      pub fn getProperties (
          D : zvk.Device.Physical,
        ) vk.device.physical.Properties {
        var result = vk.device.physical.Properties{};
        vk.device.physical.getProperties(D.ct, &result);
        return result;
      } //:: zvk.Device.Physical.getProperties

      /// Returns true if the {@arg D} device supports the default configuration of this library
      pub fn isSuitable (
          D : zvk.Device.Physical,
          S : zvk.Surface,
          E : zvk.Device.Extensions,
          F : zvk.Features,
          A : zvk.Allocator,
        ) !bool {
        var fam = try zvk.Device.Queue.Family.create(D, S, A);
        defer fam.destroy();
        var supp = try zvk.Device.Physical.SwapchainSupport.create(D, S, A);
        defer supp.destroy();
        const props = zvk.Device.Physical.getProperties(D);
        return props.deviceType == vk.device.physical.types.Discrete
           and fam.graphics     != null
           and fam.present      != null
           and try zvk.Device.extensions.supportsAll(D, E, A)
           and zvk.Device.features.supportsAll(D, F)
           and supp.hasSwapchain()
           ; //:: suitability checks
      } //:: zvk.Device.Physical.isSuitable

      pub fn findSuitable (
          L : []const vk.device.Physical,
          S : zvk.Surface,
          E : zvk.Device.Extensions,
          F : zvk.Features,
          A : zvk.Allocator,
        ) !vk.Device.Physical {
        // Return early: First device when configured to do so
        if (zvk.cfg.device.forceFirst) { return L[0]; }
        // Search for a suitable device
        for (L) |D| if (try zvk.Device.Physical.isSuitable(D, S, E, F, A)) return D;
        return error.device_NoSuitableGPU;
      } //:: zvk.Device.Physical.findSuitable

      pub fn getList (
          I : zvk.Instance,
          A : zvk.Allocator,
        ) ![]vk.device.Physical {
        var count :u32= 0;
        try vk.ok(vk.device.physical.getList(I.ct, &count, null));
        if (count == 0) return error.device_NoVulkanSupport;
        const result = try A.zig.alloc(vk.Device.Physical, count);
        try vk.ok(vk.device.physical.getList(I.ct, &count, result.ptr));
        return result;
      } //:: zvk.Device.Physical.getList

      pub fn create (
          I : zvk.Instance,
          S : zvk.Surface,
          E : zvk.Device.Extensions,
          F : zvk.Features,
          A : zvk.Allocator,
        ) !zvk.Device.Physical {
        var result = zvk.Device.Physical{.A= A, .ct= undefined, .all= undefined};
        result.all = try zvk.Device.Physical.getList(I, result.A);                 // Get all devices
        result.ct  = try zvk.Device.Physical.findSuitable(result.all, S, E, F, A); // Select the device that we want
        return result;
      } //:: zvk.Device.Physical.create

      pub fn destroy (
          D : *zvk.Device.Physical,
        ) void {
        D.A.zig.free(D.all);
      } //:: zvk.Device.Physical.destroy
    }; //:: zvk.Device.Physical


    //______________________________________
    // @section Device: Logical
    //____________________________
    pub const Logical = struct {
      A    :zvk.Allocator,
      ct   :vk.device.Logical,
      cfg  :vk.device.logical.Cfg,

      pub fn setup (
          queueCfgs : []const vk.device.queue.Cfg,
          exts      : []const vk.String,
          feats     : *vk.features.Root,
        ) !vk.device.logical.Cfg {
        // Specify validation layers for older implementations. Not needed in modern Vulkan.
        const layerCount :u32= zvk.validation.layers.len;
        const layers = if (zvk.validation.active) zvk.validation.layers[0].ptr else null;
        // Return the result
        return vk.device.logical.Cfg{
          .sType                   = vk.stype.device.Cfg,     // : VkStructureType = @import("std").mem.zeroes(VkStructureType),
          .pNext                   = feats,                // : ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
          .flags                   = 0,                       // : VkDeviceCreateFlags = @import("std").mem.zeroes(VkDeviceCreateFlags),
          .queueCreateInfoCount    = @intCast(queueCfgs.len), // : u32 = @import("std").mem.zeroes(u32),
          .pQueueCreateInfos       = queueCfgs.ptr,           // : [*c]const VkDeviceQueueCreateInfo = @import("std").mem.zeroes([*c]const VkDeviceQueueCreateInfo),
          .enabledLayerCount       = layerCount,              // : u32 = @import("std").mem.zeroes(u32),
          .ppEnabledLayerNames     = &layers,                 // : [*c]const [*c]const u8 = @import("std").mem.zeroes([*c]const [*c]const u8),
          .enabledExtensionCount   = @intCast(exts.len),      // : u32 = @import("std").mem.zeroes(u32),
          .ppEnabledExtensionNames = @ptrCast(exts.ptr),      // : [*c]const [*c]const u8 = @import("std").mem.zeroes([*c]const [*c]const u8),
          .pEnabledFeatures        = null,                   // : [*c]const VkPhysicalDeviceFeatures = @import("std").mem.zeroes([*c]const VkPhysicalDeviceFeatures),
          }; //:: vk.device.logical.Cfg{ ... }
      } //:: zvk.Device.Logical.setup

      pub fn create (
         D : zvk.Device.Physical,
         S : zvk.Surface,
         E : zvk.Device.Extensions,
         F : zvk.Features,
         A : zvk.Allocator,
        ) !zvk.Device.Logical {
        // Create the List of features
        var feats = try F.toVulkan(A);
        defer feats.destroy();
        // Create the Queue Family information
        var fam = try zvk.Device.Queue.Family.create(D, S, A);
        defer fam.destroy();
        // Create the config for each Queue
        const queueCfgCount :u32= if (fam.graphics == fam.present) 1 else 2;
        var queueCfgs = try A.zig.alloc(vk.device.queue.Cfg, queueCfgCount);
        defer A.zig.free(queueCfgs);
        queueCfgs[0] = try zvk.Device.Queue.setup(fam.graphics.?, 1.0);
        if (fam.graphics != fam.present) queueCfgs[1] = try zvk.Device.Queue.setup(fam.present.?, 1.0);
        // Create the Logical Device and return it
        var result :zvk.Device.Logical= zvk.Device.Logical{
          .A   = A,
          .ct  = null,
          .cfg = try zvk.Device.Logical.setup(queueCfgs, E, feats.root)
          }; //:: result
        try vk.ok(vk.device.logical.create(D.ct, &result.cfg, result.A.vk, &result.ct));
        return result;
      } //:: zvk.Device.Logical.create

      pub fn destroy (
          D : *zvk.Device.Logical,
        ) void {
        vk.device.logical.destroy(D.ct, D.A.vk);
      } //:: zvk.Device.Logical.create
    }; //:: zvk.Device.Logical


    //______________________________________
    // @section Device: Queue
    //____________________________
    pub const Queue = struct {
      A         :zvk.Allocator,
      graphics  :?Device.Queue.Entry= null,
      present   :?Device.Queue.Entry= null,

      pub fn setup (
          famID    : u32,
          priority : f32,  // Must be [0.0f .. 1.0f]
        ) !vk.device.queue.Cfg {
        // TODO: Assert priority is [0.0f .. 1.0f]
        return vk.device.queue.Cfg{
          .sType            = vk.stype.queue.Cfg, // : VkStructureType = @import("std").mem.zeroes(VkStructureType),
          .pNext            = null,               // : ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
          .flags            = 0,                  // : VkDeviceQueueCreateFlags = @import("std").mem.zeroes(VkDeviceQueueCreateFlags),
          .queueFamilyIndex = famID,              // : u32 = @import("std").mem.zeroes(u32),
          .queueCount       = 1,                  // : u32 = @import("std").mem.zeroes(u32),
          .pQueuePriorities = &priority,          // : [*c]const f32 = @import("std").mem.zeroes([*c]const f32),
          }; //:: vk.device.queue.Cfg{ ... }
      } //:: zvk.Device.Queue.setup

      pub fn create (
         P : zvk.Device.Physical,
         L : zvk.Device.Logical,
         S : zvk.Surface,
         A : zvk.Allocator,
        ) !zvk.Device.Queue {
        var fam = try zvk.Device.Queue.Family.create(P, S, A);
        defer fam.destroy();
        const result = zvk.Device.Queue{
          .A        = A,
          .graphics = zvk.Device.Queue.Entry.create(L, fam.graphics),
          .present  = zvk.Device.Queue.Entry.create(L, fam.present),
          }; //:: zvk.Device.Queue{ ... }
        return result;
      } //:: zvk.Device.Queue.create


      //______________________________________
      // @section Device Queue: Entry
      //____________________________
      pub const Entry = struct {
        id  :u32,
        ct  :vk.device.Queue,

        pub fn create (
           D  : zvk.Device.Logical,
           id : ?u32,
          ) ?zvk.Device.Queue.Entry {
          if (id == null) return null;
          var result = zvk.Device.Queue.Entry{.id= id.?, .ct= null};
          vk.device.queue.get(D.ct, result.id, 0, &result.ct);
          return result;
        } //:: zvk.Device.Queue.Entry.create
      }; //:: zvk.Device.Queue.Entry


      //______________________________________
      // @section Device Queue: Family
      //____________________________
      pub const Family = struct {
        A         :zvk.Allocator,
        props     :[]vk.device.queue.family.Properties,
        graphics  :?u32= null,
        present   :?u32= null,

        pub fn canPresent (
            D  : zvk.Device.Physical,
            S  : zvk.Surface,
            id : u32,
          ) !bool {
          var result :vk.Bool= vk.False;
          try vk.ok(vk.device.physical.surface.getSupport(D.ct, id, S, &result));
          return result == vk.True;
        } //:: zvk.Device.Queue.Family.canPresent

        pub fn getProperties (
            D : zvk.Device.Physical,
            A : zvk.Allocator,
          ) ![]vk.device.queue.family.Properties {
          var count :u32= 0;
          vk.device.queue.family.getProperties(D.ct, &count, null);
          const result = try A.zig.alloc(vk.device.queue.family.Properties, count);
          vk.device.queue.family.getProperties(D.ct, &count, result.ptr);
          return result;
        } //:: zvk.Device.Queue.Family.getProperties

        /// Returns the Queue Families of the given device.
        pub fn create (
            D : zvk.Device.Physical,
            S : zvk.Surface,
            A : zvk.Allocator,
          ) !zvk.Device.Queue.Family {
          var result = zvk.Device.Queue.Family{
            .A     = A,
            .props = try zvk.Device.Queue.Family.getProperties(D, A)
            };
          for (result.props, 0..) |prop, id| {
            if (vk.flags.Queue.fromInt(prop.queueFlags).hasAll(.{.graphics=true})) result.graphics = @intCast(id);
            if (try zvk.Device.Queue.Family.canPresent(D, S, @intCast(id))) result.present = @intCast(id);
            if (result.graphics != null and result.present != null) break; // Found both, so stop searching
          }
          return result;
        } //:: zvk.Device.Queue.Family.create

        /// Frees the Family Properties list, and sets every other value to empty
        pub fn destroy (
            F : *zvk.Device.Queue.Family,
          ) void {
          F.A.zig.free(F.props);
          F.graphics = null;
          F.present  = null;
        } //:: zvk.Device.Queue.Family.destroy
      }; //:: zvk.Device.Queue.Family
    }; //:: zvk.Device.Queue

    pub const sync = struct {
      pub fn waitIdle (D :*const Device) !void { try vk.ok(vk.sync.waitIdle(D.logical.ct)); }
    }; //:: zvk.Device.sync
    pub const waitIdle = zvk.Device.sync.waitIdle;
  }; //:: zvk.Device


  //______________________________________
  // @section Swapchain
  //____________________________
  pub const Swapchain = struct {
    A       : zvk.Allocator,
    ct      : vk.Swapchain,
    cfg     : vk.swapchain.Cfg,
    format  : vk.surface.Format,
    mode    : vk.device.present.Mode,
    size    : vk.Size,
    imgMin  : u32,
    imgs    : zvk.Swapchain.Image.List,
    sync    : zvk.Swapchain.Sync.List,


    //______________________________________
    // @section Swapchain: Image
    //____________________________
    pub const Image = struct {
      A     : zvk.Allocator,
      ct    : vk.Image,
      view  : zvk.Swapchain.Image.View,

      pub const List = []zvk.Swapchain.Image;

      //______________________________________
      // @section Swapchain Image: View
      //____________________________
      pub const View = struct {
        A    : zvk.Allocator,
        ct   : vk.image.View,
        cfg  : vk.image.view.Cfg,

        pub fn create (
            I : vk.Image,
            D : zvk.Device.Logical,
            C : zvk.color.Format,
            A : zvk.Allocator,
          ) !zvk.Swapchain.Image.View {
          var result = zvk.Swapchain.Image.View{
            .A                  = A,
            .ct                 = undefined,
            .cfg                = vk.image.view.Cfg{
              .sType            = vk.stype.image.view.Cfg,
              .pNext            = null,
              .flags            = 0,
              .image            = I,
              .viewType         = vk.image.view.types.dim2D,
              .format           = C,
              .components       = vk.color.component.Mapping{
                .r              = vk.color.component.Identity,
                .g              = vk.color.component.Identity,
                .b              = vk.color.component.Identity,
                .a              = vk.color.component.Identity
                }, //:: result.cfg.components
              .subresourceRange = vk.image.Subresource{
                .aspectMask     = vk.flags.image.Aspect.toInt(.{
                  .color        = true,
                  }), //:: result.cfg.subresourceRange.aspectMask
                .baseMipLevel   = 0,
                .levelCount     = 1,
                .baseArrayLayer = 0,
                .layerCount     = 1,
                }, //:: result.cfg.subresourceRange
              }, //:: result.cfg
            }; //:: result
          try vk.ok(vk.image.view.create(D.ct, &result.cfg, A.vk, &result.ct));
          return result;
        } //:: zvk.Swapchain.Image.View.create

        pub fn destroy (
            V : *zvk.Swapchain.Image.View,
            D : zvk.Device.Logical,
          ) void {
          vk.image.view.destroy(D.ct, V.ct, V.A.vk);
        } //:: zvk.Swapchain.Image.View.destroy
      }; //:: zvk.Swapchain.Image.View

      pub fn create (
          I : vk.Image,
          D : zvk.Device.Logical,
          C : zvk.color.Format,
          A : zvk.Allocator,
        ) !zvk.Swapchain.Image {
        return zvk.Swapchain.Image{
          .A    = A,
          .ct   = I,
          .view = try zvk.Swapchain.Image.View.create(I, D, C, A),
          };
      } //:: zvk.Swapchain.Image.create

      pub fn destroy (
          I : *zvk.Swapchain.Image,
          D : zvk.Device.Logical,
        ) void {
        I.view.destroy(D);
      } //:: zvk.Swapchain.Image.destroy
    }; //:: zvk.Swapchain.Image

    pub const select = struct {
      /// @descr Returns the preferred color format for the Swapchain Surface
      /// @note
      ///  Searches for {@link zvk.cfg.swapchain.color.*} support first.
      ///  Returns the first supported color format found otherwise.
      pub fn format (
          S : *const zvk.Device.Physical.SwapchainSupport,
        ) zvk.surface.Format {
        for (S.formats) |sc| {
          if (sc.format     == zvk.cfg.swapchain.color.format
          and sc.colorSpace == zvk.cfg.swapchain.color.space)
          { return sc; }
        }
        return S.formats[0];  // Otherwise return the first format
      } //:: zvk.Swapchain.select.format

      /// @descr Returns the preferred present mode for the Swapchain Surface
      /// @note
      ///  Searches for {@link zvk.cfg.device.present} support first.
      ///  Returns FIFO if not found. _(guaranteed to exist by spec)_
      pub fn mode (
          S : *const zvk.Device.Physical.SwapchainSupport,
        ) zvk.Device.PresentMode {
        for (S.modes) |m| if (m == zvk.cfg.device.present) return m;
        return vk.device.present.Fifo; // Default to FiFo when Mailbox is not supported
      } //:: zvk.Swapchain.select.mode

      /// @descr Returns the size of the Swapchain Surface
      pub fn size (
          S  : *const zvk.Device.Physical.SwapchainSupport,
          sz : zvk.Size,
        ) zvk.Size {
        // Exit early when the extents haven't changed
        if (S.caps.currentExtent.width < std.math.maxInt(u32)) return S.caps.currentExtent;
        // TODO: Compare measurements in pixels/units first, in case they don't match
        return vk.Size{
          .width = std.math.clamp(sz.width,
            S.caps.minImageExtent.width,
            S.caps.maxImageExtent.width, ),
          .height = std.math.clamp(sz.height,
            S.caps.minImageExtent.height,
            S.caps.maxImageExtent.height, ),
          };
      } //:: zvk.Swapchain.select.size

      /// @descr Returns the minimum number of images that the Swapchain will contain
      pub fn imgMin (
          S : *const zvk.Device.Physical.SwapchainSupport,
        ) u32 {
        return std.math.clamp(
          S.caps.minImageCount + 1,
          S.caps.minImageCount,
          S.caps.maxImageCount);
      } //:: zvk.Swapchain.select.imgMin
    }; //:: zvk.Swapchain.select

    pub const images = struct {
      pub fn getList (
          D  : zvk.Device.Logical,
          S  : vk.Swapchain,
          A  : zvk.Allocator,
        ) ![]vk.Image {
        // Get the list of all Images from the Swapchain
        var count :u32= 0;
        try vk.ok(vk.swapchain.images.getList(D.ct, S, &count, null));
        const result = try A.zig.alloc(vk.Image, count);
        try vk.ok(vk.swapchain.images.getList(D.ct, S, &count, result.ptr));
        return result;
      } //:: zvk.Swapchain.images.getList

      pub fn create (
          D : zvk.Device.Logical,
          S : vk.Swapchain,
          C : zvk.color.Format,
          A : zvk.Allocator,
        ) !zvk.Swapchain.Image.List {
        // Create the resulting images
        const list = try zvk.Swapchain.images.getList(D, S, A);
        defer A.zig.free(list);
        var result = try A.zig.alloc(zvk.Swapchain.Image, list.len);
        for (0..list.len) |id| result[id] = try zvk.Swapchain.Image.create(list[id], D, C, A);
        return result;
      } //:: zvk.Swapchain.images.create
      
      pub fn destroy(
          I : zvk.Swapchain.Image.List,
          D : zvk.Device.Logical,
          A : zvk.Allocator,
        ) void {
        for (0..I.len) |id| I[id].destroy(D);
        A.zig.free(I);
      }

      pub fn next (
          S  : *zvk.Swapchain,
          D  : zvk.Device.Logical,
          Se : zvk.sync.Semaphore,
          Fe : zvk.sync.Fence,
        ) !zvk.Swapchain.Image {
        var id :u32= 0;
        try vk.ok(vk.swapchain.images.getNext(D.ct, S.ct, 1_000_000_000, Se.ct, Fe.ct, &id));
        return S.imgs[id];
      } //:: zvk.Swapchain.images.next
    }; //:: zvk.Swapchain.images


    //______________________________________
    // @section Swapchain: Sync
    //____________________________
    pub const Sync = struct {
      semaphore : zvk.sync.Semaphore,
      fence     : zvk.sync.Fence,

      pub const List = []zvk.Swapchain.Sync;

      pub fn create (
          D : zvk.Device.Logical,
          A : zvk.Allocator,
        ) !zvk.Swapchain.Sync {
        return zvk.Swapchain.Sync{
          .fence     = try zvk.sync.Fence.create(D, .{}, A),
          .semaphore = try zvk.sync.Semaphore.create(D, A),};
      } //:: zvk.Swapchain.Image.Sync.create

      pub fn destroy (
          S : *zvk.Swapchain.Sync,
          D : zvk.Device.Logical,
        ) void {
        S.fence.destroy(D);
        S.semaphore.destroy(D);
      } //:: zvk.Swapchain.Sync.destroy
    }; //:: zvk.Swapchain.Sync

    pub const syncs = struct {
      pub fn create (
          D : zvk.Device.Logical,
          C : usize,
          A : zvk.Allocator,
        ) !zvk.Swapchain.Sync.List {
        var result = try A.zig.alloc(zvk.Swapchain.Sync, C);
        for (0..C) |id| result[id] = try zvk.Swapchain.Sync.create(D, A);
        return result;
      } //:: zvk.Swapchain.sync.create

      pub fn destroy (
          S : zvk.Swapchain.Sync.List,
          D : zvk.Device.Logical,
          A : zvk.Allocator,
        ) void {
        for (0..S.len) |id| S[id].destroy(D);
        A.zig.free(S);
      } //:: zvk.Swapchain.sync.destroy
    }; //:: zvk.Swapchain.sync


    pub fn setup (
        D      : zvk.Device,
        S      : zvk.Surface,
        imgMin : u32,
        format : zvk.surface.Format,
        caps   : zvk.surface.Capabilities,
        mode   : zvk.Device.PresentMode,
        size   : zvk.Size,
        A      : zvk.Allocator,
      ) !vk.swapchain.Cfg {
      var fam = try zvk.Device.Queue.Family.create(D.physical, S, A);
      defer fam.destroy();
      if (fam.graphics == null or fam.present == null) return error.swapchain_IncorrectGraphicsQueueFamily;
      const exclusive = fam.graphics == fam.present;
      const shareMode :vk.share.Mode= if (exclusive) vk.share.exclusive else vk.share.concurrent;
      const famCount :u32= if (exclusive) 0 else 2;
      var famIDs = try A.zig.alloc(u32, famCount);
      defer A.zig.free(famIDs);
      if (famIDs.len > 0) { famIDs[0] = fam.graphics.?; famIDs[1] = fam.present.?; }
      // Create the Cfg object and return it
      return vk.swapchain.Cfg{
        .sType                 = vk.stype.swapchain.Cfg,               // VkStructureType = @import("std").mem.zeroes(VkStructureType),
        .pNext                 = null,                                 // ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
        .flags                 = zvk.cfg.swapchain.flags.toInt(),      // VkSwapchainCreateFlagsKHR = @import("std").mem.zeroes(VkSwapchainCreateFlagsKHR),
        .surface               = S,                                    // VkSurfaceKHR = @import("std").mem.zeroes(VkSurfaceKHR),
        .minImageCount         = imgMin,                               // u32 = @import("std").mem.zeroes(u32),
        .imageFormat           = format.format,                        // VkFormat = @import("std").mem.zeroes(VkFormat),
        .imageColorSpace       = format.colorSpace,                    // VkColorSpaceKHR = @import("std").mem.zeroes(VkColorSpaceKHR),
        .imageExtent           = size,                                 // VkExtent2D = @import("std").mem.zeroes(VkExtent2D),
        .imageArrayLayers      = 1, // Always 1, unless Stereoscopic   // u32 = @import("std").mem.zeroes(u32),
        .imageUsage            = vk.flags.image.Usage.toInt(.{         // VkImageUsageFlags = @import("std").mem.zeroes(VkImageUsageFlags),
          .colorAttachment     = true,
          // TODO: transferDst
          }), //:: .imageUsage
        .imageSharingMode      = shareMode,                            // VkSharingMode = @import("std").mem.zeroes(VkSharingMode),
        .queueFamilyIndexCount = @intCast(famIDs.len),                 // u32 = @import("std").mem.zeroes(u32),
        .pQueueFamilyIndices   = famIDs.ptr,                           // [*c]const u32 = @import("std").mem.zeroes([*c]const u32),
        .preTransform          = caps.currentTransform,                // VkSurfaceTransformFlagBitsKHR = @import("std").mem.zeroes(VkSurfaceTransformFlagBitsKHR),
        .compositeAlpha        = zvk.cfg.swapchain.alpha.toInt(),      // VkCompositeAlphaFlagBitsKHR = @import("std").mem.zeroes(VkCompositeAlphaFlagBitsKHR),
        .presentMode           = mode,                                 // VkPresentModeKHR = @import("std").mem.zeroes(VkPresentModeKHR),
        .clipped               = vk.toBool(zvk.cfg.swapchain.clipped), // VkBool32 = @import("std").mem.zeroes(VkBool32),
        .oldSwapchain          = null,                                 // VkSwapchainKHR = @import("std").mem.zeroes(VkSwapchainKHR),
        };
    } //:: zvk.Swapchain.setup

    pub fn create (
        D  : zvk.Device,
        S  : zvk.Surface,
        sz : zvk.Size,
        A  : zvk.Allocator,
      ) !zvk.Swapchain {
      var supp = try zvk.Device.Physical.SwapchainSupport.create(D.physical, S, A);
      defer supp.destroy();
      // Create the Configuration
      var result = zvk.Swapchain{
        .A      = A,
        .format = zvk.Swapchain.select.format(&supp),
        .mode   = zvk.Swapchain.select.mode(&supp),
        .size   = zvk.Swapchain.select.size(&supp, sz),
        .imgMin = zvk.Swapchain.select.imgMin(&supp),
        .ct     = null,
        .cfg    = undefined,
        .imgs   = undefined,
        .sync   = undefined,
        };
      result.cfg = try zvk.Swapchain.setup(D, S,
        result.imgMin, result.format, supp.caps, result.mode, result.size,
        result.A); //:: result.cfg
      // Create the handle
      try vk.ok(vk.swapchain.create(D.logical.ct, &result.cfg, result.A.vk, &result.ct));
      // Get the list of Images and Sync objects
      result.imgs = try zvk.Swapchain.images.create(D.logical, result.ct, result.format.format, result.A);
      result.sync = try zvk.Swapchain.syncs.create(D.logical, result.imgs.len, result.A);
      return result;
    } //:: zvk.Swapchain.create

    pub fn destroy (
        S : *zvk.Swapchain,
        D : zvk.Device,
      ) void {
      zvk.Swapchain.syncs.destroy(S.sync, D.logical, S.A);
      zvk.Swapchain.images.destroy(S.imgs, D.logical, S.A);
      vk.swapchain.destroy(D.logical.ct, S.ct, S.A.vk);
    } //:: zvk.Swapchain.destroy
  }; //:: zvk.Swapchain


  //______________________________________
  // @section Shaders
  //____________________________
  pub const Shader = shader.Graphics;
  pub const shader = struct {
    pub const Kind = enum { vert, frag, comp, geom };
    //______________________________________
    // @section Shader: Graphics
    //____________________________
    pub const Graphics = struct {
      vert  :zvk.shader.Module,
      frag  :zvk.shader.Module,

      pub fn create_spv (
          D    : zvk.Device,
          vert : zvk.SpirV,
          frag : zvk.SpirV,
          A    : zvk.Allocator,
        ) !zvk.shader.Graphics {
        return zvk.shader.Graphics{
          .vert = try zvk.shader.Module.create_spv(D, zvk.shader.Kind.vert, vert, A),
          .frag = try zvk.shader.Module.create_spv(D, zvk.shader.Kind.frag, frag, A),
          };
      } //:: zvk.shader.Graphics.create

      pub fn destroy (
          S : *zvk.shader.Graphics,
          D : zvk.Device,
        ) void {
        S.vert.destroy(D);
        S.frag.destroy(D);
      } //:: zvk.shader.Graphics.destroy
    }; //:: zvk.shader.Graphics.destroy


    //______________________________________
    // @section Shader: Stage
    //____________________________
    pub const Stage = struct {
      flags  :vk.shader.stage.Flags,
      cfg    :vk.shader.stage.Cfg,
      spec   :vk.pipeline.specialization.Cfg, // https://registry.khronos.org/vulkan/specs/1.3-extensions/html/vkspec.html#pipelines-specialization-constants

      pub const CreateOptions = struct {
        name  : vk.String             = zvk.cfg.shader.EntryPoint,
        flags : vk.shader.stage.Flags = .{}
      }; //:: zvk.shader.Stage.CreateOptions

      pub fn create (
          shd : vk.shader.T,
          in  : zvk.shader.Stage.CreateOptions,
        ) !zvk.shader.Stage {
        var result :zvk.shader.Stage= undefined;
        result.flags = in.flags;
        result.spec  = vk.pipeline.specialization.Cfg{ // TODO:
          .mapEntryCount       = 0,     // u32 = @import("std").mem.zeroes(u32),
          .pMapEntries         = null,  // [*c]const VkSpecializationMapEntry = @import("std").mem.zeroes([*c]const VkSpecializationMapEntry),
          .dataSize            = 0,     // usize = @import("std").mem.zeroes(usize),
          .pData               = null,  // ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
          }; //:: result.spec
        result.cfg = vk.shader.stage.Cfg{
          .sType               = vk.stype.shader.stage.Cfg,                  // VkStructureType = @import("std").mem.zeroes(VkStructureType),
          .pNext               = null,                                       // ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
          .flags               = vk.pipeline.shader.stage.Flags.toInt(.{}),  // VkPipelineShaderStageCreateFlags = @import("std").mem.zeroes(VkPipelineShaderStageCreateFlags),
          .stage               = result.flags.toInt(),                       // VkShaderStageFlagBits = @import("std").mem.zeroes(VkShaderStageFlagBits),
          .module              = shd,                                        // VkShaderModule = @import("std").mem.zeroes(VkShaderModule),
          .pName               = in.name,                                    // [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
          .pSpecializationInfo = &result.spec,                               // [*c]const VkSpecializationInfo = @import("std").mem.zeroes([*c]const VkSpecializationInfo),
          }; //:: result.cfg
        return result;
      } //:: zvk.shader.Stage.create
    }; //:: zvk.shader.Stage


    //______________________________________
    // @section Shader Module
    //____________________________
    pub const Module = struct {
      A      :zvk.Allocator,
      ct     :vk.shader.T,
      cfg    :vk.shader.Cfg,
      code   :zvk.SpirV,
      stage  :zvk.shader.Stage,
      kind   :zvk.shader.Kind,

      pub fn create_spv (
          D   : zvk.Device,
          K   : zvk.shader.Kind,
          spv : zvk.SpirV,
          A   : zvk.Allocator,
        ) !zvk.shader.Module {
        var result :zvk.shader.Module= undefined;
        result.A    = A;
        result.code = spv;
        result.kind = K;
        result.cfg  = vk.shader.Cfg{
          .sType    = vk.stype.shader.Cfg,
          .pNext    = null,
          .flags    = vk.flags.Shader.toInt(.{}),
          .codeSize = result.code.len*@sizeOf(u32),
          .pCode    = @ptrCast(result.code.ptr),
          }; //:: result.cfg
        try vk.ok(vk.shader.create(D.logical.ct, &result.cfg, result.A.vk, &result.ct));
        result.stage = try zvk.shader.Stage.create(result.ct, .{
          .name  = zvk.cfg.shader.EntryPoint,
          .flags = switch (result.kind) {
            .comp => vk.shader.stage.Flags{.compute  = true},
            .geom => vk.shader.stage.Flags{.geometry = true},
            .vert => vk.shader.stage.Flags{.vertex   = true},
            .frag => vk.shader.stage.Flags{.fragment = true},
            }, //:: result.stage.flags
          }); //:: result.stage
        return result;
      } //:: zvk.shader.Module.create

      pub fn destroy (
          M : *zvk.shader.Module,
          D : zvk.Device,
        ) void {
        vk.shader.destroy(D.logical.ct, M.ct, M.A.vk);
      } //:: zvk.shader.Module.create
    }; //:: zvk.shader.Module
  }; //:: zvk.shader


  //______________________________________
  // @section Pipelines
  //____________________________
  pub const Framebuffer = zvk.framebuffer.T;
  pub const framebuffer = struct {
    pub const Subpass = struct {
      ref    :vk.render.subpass.Reference,
      descr  :vk.render.subpass.Description,
    }; //:: zvk.framebuffer.Subpass

    pub const Pass = struct {
      A      :zvk.Allocator,
      ct     :vk.render.pass.T,
      cfg    :vk.render.pass.Cfg,
      color  :vk.render.pass.Description,
      sub    :zvk.framebuffer.Subpass,

      pub fn create (
          D        : zvk.Device,
          C        : struct {
            format : zvk.color.Format}
        ) !zvk.framebuffer.Pass {
        var result :zvk.framebuffer.Pass= undefined;
        result.color               = vk.render.pass.Description{
          .flags                   = vk.render.pass.description.Flags.toInt(.{}),
          .format                  = C.format, // VkFormat = @import("std").mem.zeroes(VkFormat),
          .samples                 = vk.render.pass.attachment.Samples.toInt(.{
            .c01                   = true
            }), //:: result.color.samples
          .loadOp                  = @intFromEnum(vk.render.pass.attachment.LoadOp.clear),
          .storeOp                 = @intFromEnum(vk.render.pass.attachment.StoreOp.store),
          .stencilLoadOp           = @intFromEnum(vk.render.pass.attachment.LoadOp.dontCare),
          .stencilStoreOp          = @intFromEnum(vk.render.pass.attachment.StoreOp.dontCare),
          .initialLayout           = @intFromEnum(vk.image.Layout.undefined),
          .finalLayout             = @intFromEnum(vk.image.Layout.present_src),
          }; //:: result.color
        result.sub                 = undefined;
        result.sub.ref             = vk.render.subpass.Reference{
          .attachment              = 0,
          .layout                  = @intFromEnum(vk.image.Layout.color_attachment_optimal),
          }; //:: result.sub.descr
        result.sub.descr           = vk.render.subpass.Description{
          .flags                   = vk.render.subpass.description.Flags.toInt(.{}),
          .pipelineBindPoint       = @intFromEnum(vk.pipeline.BindPoint.graphics),
          .inputAttachmentCount    = 0,
          .pInputAttachments       = null,
          .colorAttachmentCount    = 1,
          .pColorAttachments       = &result.sub.ref,
          .pResolveAttachments     = 0,
          .pDepthStencilAttachment = null, // [*c]const VkAttachmentReference = @import("std").mem.zeroes([*c]const VkAttachmentReference),
          .preserveAttachmentCount = 0,
          .pPreserveAttachments    = null, // [*c]const u32 = @import("std").mem.zeroes([*c]const u32),
          }; //:: result.sub
        result.cfg                 = vk.render.pass.Cfg{
          .sType                   = vk.stype.render.pass.Cfg,
          .pNext                   = null,
          .flags                   = vk.render.pass.Flags.toInt(.{}),
          .attachmentCount         = 1,
          .pAttachments            = &result.color,
          .subpassCount            = 1,
          .pSubpasses              = &result.sub.descr,
          .dependencyCount         = 0,
          .pDependencies           = null,
          }; //:: result.cfg
        try vk.ok(vk.render.pass.create(D.logical.ct, &result.cfg, result.A.vk, &result.ct));
        return result;
      } //:: zvk.framebuffer.Pass.create

      pub fn destroy (
          P : *zvk.framebuffer.Pass,
          D : zvk.Device,
        ) void {
        vk.render.pass.destroy(D.logical.ct, P.ct, P.A.vk);
      } //:: zvk.framebuffer.Pass.create
    }; //:: zvk.framebuffer.Pass

    pub const T = struct {
      ct   :vk.framebuffer.T,
      cfg  :vk.framebuffer.Cfg,
    }; //:: zvk.framebuffer.T
  }; //:: zvk.framebuffer


  //______________________________________
  // @section Pipelines
  //____________________________
  pub const Pipeline = zvk.pipeline.Graphics;
  pub const pipeline = struct {
    //______________________________________
    // @section Pipeline: Graphics
    //____________________________
    pub const Graphics = struct {
      A         :zvk.Allocator,
      shader    :zvk.Shader,
      dynamic   :zvk.pipeline.Graphics.State,
      viewport  :zvk.pipeline.Graphics.Viewport,
      vertex    :zvk.pipeline.Graphics.Vertex,
      raster    :vk.pipeline.graphics.raster.Cfg,
      msaa      :vk.pipeline.graphics.raster.msaa.Cfg,
      blend     :zvk.pipeline.Graphics.Blend,
      shape     :zvk.pipeline.Graphics.Shape,
      pass      :zvk.framebuffer.Pass,
      ct        :vk.pipeline.graphics.T,
      cfg       :vk.pipeline.graphics.Cfg,

      pub const Shape = struct {
        A    :zvk.Allocator,
        ct   :vk.pipeline.graphics.shape.T,
        cfg  :vk.pipeline.graphics.shape.Cfg,
        pub fn create (
          D : zvk.Device,
          A : zvk.Allocator,
          ) !zvk.pipeline.Graphics.Shape {
          var result :zvk.pipeline.Graphics.Shape= undefined;
          result.A                  = A;
          result.cfg                = vk.pipeline.graphics.shape.Cfg{
            .sType                  = vk.stype.pipeline.graphics.shape.Cfg,
            .pNext                  = null,
            .flags                  = vk.pipeline.graphics.shape.Flags.toInt(.{}),
            .setLayoutCount         = 0,
            .pSetLayouts            = null, // [*c]const VkDescriptorSetLayout = @import("std").mem.zeroes([*c]const VkDescriptorSetLayout),
            .pushConstantRangeCount = 0,
            .pPushConstantRanges    = null, // [*c]const VkPushConstantRange = @import("std").mem.zeroes([*c]const VkPushConstantRange),
            }; //:: result.cfg
          try vk.ok(vk.pipeline.graphics.shape.create(D.logical.ct, &result.cfg, result.A.vk, &result.ct));
          return result;
        } //:: zvk.pipeline.Graphics.Shape.create

        pub fn destroy (
            S : *zvk.pipeline.Graphics.Shape,
            D : zvk.Device,
          ) void {
          vk.pipeline.graphics.shape.destroy(D.logical.ct, S.ct, S.A.vk);
        } //:: zvk.pipeline.Graphics.Shape.destroy
      }; //:: zvk.pipeline.Graphics.Shape

      pub const Vertex = struct {
        input  :vk.pipeline.graphics.vertex.input.Cfg,
        assem  :vk.pipeline.graphics.vertex.assembly.Cfg,
      }; //:: zvk.pipeline.Graphics.Vertex

      pub const State = struct {
        list  :[]const vk.pipeline.state.dynamic.Kind,
        cfg   :vk.pipeline.state.dynamic.Cfg,
      }; //:: zvk.pipeline.Graphics.State

      pub const Viewport = struct {
        ct       :vk.pipeline.graphics.viewport.T,
        cfg      :vk.pipeline.graphics.viewport.Cfg,
        scissor  :vk.pipeline.graphics.viewport.Scissor,
      }; //:: zvk.pipeline.Graphics.Viewport

      pub const Blend = struct {
        ct   :vk.pipeline.graphics.raster.blend.T,
        cfg  :vk.pipeline.graphics.raster.blend.Cfg,
      }; //:: zvk.pipeline.Graphics.Blend

      pub const CreateOptions = struct {
        depth_reversed  : bool = zvk.cfg.render.depth.reversed,
      }; //:: zvk.pipeline.Graphics.CreateOptions

      pub fn create_spv (
          D   : zvk.Device,
          S   : zvk.Swapchain,
          shd : struct { vert :zvk.SpirV, frag :zvk.SpirV },
          in  : zvk.pipeline.Graphics.CreateOptions,
          A   : zvk.Allocator,
        ) !zvk.pipeline.Graphics {
        var result :zvk.pipeline.Graphics= undefined;
        result.A                             = A;
        result.shader                        = try zvk.Shader.create_spv(D, shd.vert, shd.frag, A);
        result.dynamic                       = undefined;
        result.dynamic.list                  = &.{vk.pipeline.state.Dynamic.viewport, vk.pipeline.state.Dynamic.scissor};
        result.dynamic.cfg                   = vk.pipeline.state.dynamic.Cfg{
          .sType                             = vk.stype.pipeline.graphics.state.dynamic.Cfg,
          .pNext                             = null,
          .flags                             = vk.pipeline.state.dynamic.Flags.toInt(.{}),
          .dynamicStateCount                 = @intCast(result.dynamic.list.len),
          .pDynamicStates                    = @ptrCast(result.dynamic.list.ptr),
          }; //:: result.dynamic.cfg
        result.viewport                      = undefined;
        result.viewport.ct                   = vk.pipeline.graphics.viewport.T{
          .x                                 = 0.0,
          .y                                 = 0.0,
          .width                             = @floatFromInt(S.size.width),
          .height                            = @floatFromInt(S.size.height),
          .minDepth                          = if (in.depth_reversed) 1.0 else 0.0,
          .maxDepth                          = if (in.depth_reversed) 0.0 else 1.0,
          }; //:: result.viewport.ct
        result.viewport.scissor              = vk.pipeline.graphics.viewport.Scissor{
          .offset                            = .{.x= 0, .y= 0},
          .extent                            = S.size,
          }; //:: result.viewport.scissor
        result.viewport.cfg                  = vk.pipeline.graphics.viewport.Cfg{
          .sType                             = vk.stype.pipeline.graphics.viewport.Cfg,
          .pNext                             = null,
          .flags                             = vk.pipeline.graphics.viewport.Flags.toInt(.{}),
          .viewportCount                     = 1,
          .pViewports                        = &result.viewport.ct,
          .scissorCount                      = 1,
          .pScissors                         = &result.viewport.scissor,
          }; //:: result.viewport.ct
        result.vertex                        = zvk.pipeline.Graphics.Vertex{
          .input                             = vk.pipeline.graphics.vertex.input.Cfg{
            .sType                           = vk.stype.pipeline.graphics.vertex.input.Cfg,
            .pNext                           = null,
            .flags                           = vk.pipeline.graphics.vertex.input.Flags.toInt(.{}),
            .vertexBindingDescriptionCount   = 0,    // TODO:  u32 = @import("std").mem.zeroes(u32),
            .pVertexBindingDescriptions      = null, // TODO:  [*c]const VkVertexInputBindingDescription = @import("std").mem.zeroes([*c]const VkVertexInputBindingDescription),
            .vertexAttributeDescriptionCount = 0,    // TODO:  u32 = @import("std").mem.zeroes(u32),
            .pVertexAttributeDescriptions    = null, // TODO:  [*c]const VkVertexInputAttributeDescription = @import("std").mem.zeroes([*c]const VkVertexInputAttributeDescription),
            }, //:: result.vertex.input
          .assem                             = vk.pipeline.graphics.vertex.assembly.Cfg{
            .sType                           = vk.stype.pipeline.graphics.vertex.assembly.Cfg,
            .pNext                           = null,
            .flags                           = vk.pipeline.graphics.vertex.assembly.Flags.toInt(.{}),
            .topology                        = @intFromEnum(vk.pipeline.graphics.vertex.topology.Kind.triangle_list), //:: TODO:  triangle_strip
            .primitiveRestartEnable          = vk.toBool(false),
            }, //:: result.vertex.input
          }; //:: result.vertex
        result.raster                        = vk.pipeline.graphics.raster.Cfg{
          .sType                             = vk.stype.pipeline.graphics.raster.Cfg,
          .pNext                             = null,
          .flags                             = vk.pipeline.graphics.raster.Flags.toInt(.{}),
          .depthClampEnable                  = vk.toBool(false),
          .rasterizerDiscardEnable           = vk.toBool(false),
          .polygonMode                       = @intFromEnum(vk.pipeline.graphics.raster.Polygon.fill),
          .cullMode                          = vk.pipeline.graphics.raster.Cull.toInt(.{
            .back                            = false, //:: TODO: Enable
            .front                           = false,
             }), //:: result.raster.cullMode
          .frontFace                         = @intFromEnum(vk.pipeline.graphics.raster.Face.cw),
          .depthBiasEnable                   = vk.toBool(false),
          .depthBiasConstantFactor           = 0.0,
          .depthBiasClamp                    = 0.0,
          .depthBiasSlopeFactor              = 0.0,
          .lineWidth                         = 1.0,
          }; //:: result.raster
        result.msaa                          = vk.pipeline.graphics.raster.msaa.Cfg{
          .sType                             = vk.stype.pipeline.graphics.raster.msaa.Cfg,
          .pNext                             = null,
          .flags                             = vk.pipeline.graphics.raster.msaa.Flags.toInt(.{}),
          .rasterizationSamples              = vk.pipeline.graphics.raster.msaa.Samples.toInt(.{
            .c01                             = true,
            }), //:: result.msaa.rasterizationSamples
          .sampleShadingEnable               = vk.toBool(false),
          .minSampleShading                  = 1.0,
          .pSampleMask                       = null, // [*c]const VkSampleMask = @import("std").mem.zeroes([*c]const VkSampleMask),
          .alphaToCoverageEnable             = vk.toBool(false), // VkBool32 = @import("std").mem.zeroes(VkBool32),
          .alphaToOneEnable                  = vk.toBool(false), // VkBool32 = @import("std").mem.zeroes(VkBool32),
          }; //:: result.msaa
        result.blend                         = undefined;
        result.blend.ct                      = vk.pipeline.graphics.raster.blend.T{
          .blendEnable                       = vk.toBool(true),
          .srcColorBlendFactor               = @intFromEnum(vk.pipeline.graphics.raster.blend.Factor.srcAlpha),
          .dstColorBlendFactor               = @intFromEnum(vk.pipeline.graphics.raster.blend.Factor.oneMinus_srcAlpha),
          .colorBlendOp                      = @intFromEnum(vk.pipeline.graphics.raster.blend.Op.add),
          .srcAlphaBlendFactor               = @intFromEnum(vk.pipeline.graphics.raster.blend.Factor.one),
          .dstAlphaBlendFactor               = @intFromEnum(vk.pipeline.graphics.raster.blend.Factor.zero),
          .alphaBlendOp                      = @intFromEnum(vk.pipeline.graphics.raster.blend.Op.add),
          .colorWriteMask                    = vk.color.component.Flags.rgba.toInt(),
          }; //:: result.blend.ct
        result.blend.cfg                     = vk.pipeline.graphics.raster.blend.Cfg{
          .sType                             = vk.stype.pipeline.graphics.raster.blend.Cfg,
          .pNext                             = null,
          .flags                             = vk.pipeline.graphics.raster.blend.Flags.toInt(.{}),
          .logicOpEnable                     = vk.toBool(false),
          .logicOp                           = @intFromEnum(vk.pipeline.graphics.raster.LogicOp.copy),
          .attachmentCount                   = 1,
          .pAttachments                      = &result.blend.ct,
          .blendConstants                    = .{0.0, 0.0, 0.0, 0.0}, // [4]f32
          }; //:: result.blend.cfg
        result.shape                         = try zvk.pipeline.Graphics.Shape.create(D, result.A);
        result.pass                          = try zvk.framebuffer.Pass.create(D, .{.format= S.format.format});
        result.cfg                           = vk.pipeline.graphics.Cfg{
          .sType                             = vk.stype.pipeline.graphics.Cfg,
          .pNext                             = null,
          .flags                             = vk.pipeline.Flags.toInt(.{}),
          .stageCount                        = 2,
          .pStages                           = @as(*const [2]vk.shader.stage.Cfg, &.{result.shader.vert.stage.cfg, result.shader.frag.stage.cfg}),
          .pVertexInputState                 = &result.vertex.input,
          .pInputAssemblyState               = &result.vertex.assem,
          .pTessellationState                = null, // [*c]const VkPipelineTessellationStateCreateInfo = @import("std").mem.zeroes([*c]const VkPipelineTessellationStateCreateInfo),
          .pViewportState                    = &result.viewport.cfg,
          .pRasterizationState               = &result.raster,
          .pMultisampleState                 = &result.msaa,
          .pDepthStencilState                = null, // TODO:    // [*c]const VkPipelineDepthStencilStateCreateInfo = @import("std").mem.zeroes([*c]const VkPipelineDepthStencilStateCreateInfo),
          .pColorBlendState                  = &result.blend.cfg,
          .pDynamicState                     = &result.dynamic.cfg,
          .layout                            = result.shape.ct,
          .renderPass                        = result.pass.ct,
          .subpass                           = 0,
          .basePipelineHandle                = @ptrCast(vk.Null), // VkPipeline = @import("std").mem.zeroes(VkPipeline),
          .basePipelineIndex                 = -1,
          }; //:: result.cfg
        try vk.ok(vk.pipeline.graphics.create(D.logical.ct, @ptrCast(vk.Null), 1, &result.cfg, result.A.vk, &result.ct));
        return result;
      } //:: zvk.pipeline.Graphics.create_spv

      pub fn destroy (
          P : *zvk.pipeline.Graphics,
          D : zvk.Device,
        ) void {
        P.shader.destroy(D);
        P.shape.destroy(D);
        vk.pipeline.graphics.destroy(D.logical.ct, P.ct, P.A.vk);
      } //:: zvk.pipeline.Graphics.destroy
    }; //:: zvk.pipeline.Graphics


    //______________________________________
    // @section Pipeline: Compute
    //____________________________
    pub const Compute = struct {
      A       :zvk.Allocator,
      shader  :zvk.Shader,
      // TODO: ...
    }; //:: zvk.pipeline.Compute
  };


  //______________________________________
  // @section Synchronization
  //____________________________
  pub const sync = struct {
    //______________________________________
    // @section Synchronization: Fence
    //____________________________
    pub const Fence = struct {
      A    :zvk.Allocator,
      ct   :vk.sync.Fence,
      cfg  :vk.sync.fence.Cfg= .{.sType= vk.stype.sync.fence.Cfg, .pNext= null},

      pub fn create (
        D  : zvk.Device.Logical,
        in : struct {
          signaled :bool= true, },
        A  : zvk.Allocator,
        ) !zvk.sync.Fence {
        var result = zvk.sync.Fence{.A=A, .ct=undefined};
        result.cfg.flags = vk.flags.sync.Fence.toInt(.{
          .signaled = in.signaled
          }); //:: result.cfg.flags
        try vk.ok(vk.sync.fence.create(D.ct, &result.cfg, result.A.vk, &result.ct));
        return result;
      } //:: zvk.sync.Fence.create

      pub fn destroy (
          F : *zvk.sync.Fence,
          D : zvk.Device.Logical,
        ) void {
        vk.sync.fence.destroy(D.ct, F.ct, F.A.vk);
      } //:: zvk.sync.Fence.destroy
    }; //:: zvk.sync.Fence


    //______________________________________
    // @section Synchronization: Semaphore
    //____________________________
    pub const Semaphore = struct {
      A    :zvk.Allocator,
      ct   :vk.sync.Semaphore,
      cfg  :vk.sync.semaphore.Cfg= .{.sType= vk.stype.sync.semaphore.Cfg, .pNext= null, .flags= 0},

      pub fn create (
        D  : zvk.Device.Logical,
        A  : zvk.Allocator,
        ) !zvk.sync.Semaphore {
        var result = zvk.sync.Semaphore{.A=A, .ct=undefined};
        try vk.ok(vk.sync.semaphore.create(D.ct, &result.cfg, result.A.vk, &result.ct));
        return result;
      } //:: zvk.sync.Semaphore.create

      pub fn destroy (
          F : *zvk.sync.Semaphore,
          D : zvk.Device.Logical,
        ) void {
        vk.sync.semaphore.destroy(D.ct, F.ct, F.A.vk);
      } //:: zvk.sync.Semaphore.destroy
    }; //:: zvk.sync.Semaphore
  }; //:: zvk.sync


  //______________________________________
  // @section Commands
  //____________________________
  pub const CommandBatch = zvk.command.Batch;
  pub const command = struct {
    //______________________________________
    // @section Command: Pool
    //____________________________
    pub const Pool = struct {
      A    :zvk.Allocator,
      ct   :vk.command.Pool,
      cfg  :vk.command.pool.Cfg,

      pub const CreateOptions = struct {
        transient : bool  = zvk.cfg.command.transient,
        reset     : bool  = zvk.cfg.command.reset,
        protected : bool  = zvk.cfg.command.protected,
        }; //:: zvk.command.Batch.CreateOptions

      pub fn create (
          D  : zvk.Device,
          Q  : u32,
          in : zvk.command.Pool.CreateOptions,
          A  : zvk.Allocator,
        ) !zvk.command.Pool {
        var result = zvk.command.Pool{
          .A   = A,
          .ct  = undefined,
          .cfg = vk.command.pool.Cfg{
            .sType            = vk.stype.command.pool.Cfg,      // VkStructureType = @import("std").mem.zeroes(VkStructureType),
            .pNext            = null,                           // ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
            .flags            = vk.flags.command.Pool.toInt(.{  // VkCommandPoolCreateFlags = @import("std").mem.zeroes(VkCommandPoolCreateFlags),
              .transient      = in.transient,
              .reset          = in.reset,
              .protected      = in.protected,
              }), //:: result.cfg.flags
            .queueFamilyIndex = Q,                              // u32 = @import("std").mem.zeroes(u32),
            } //:: result.cfg
          }; //:: result
        try vk.ok(vk.command.pool.create(D.logical, &result.cfg, result.A.vk, &result.ct));
        return result;
      } //:: zvk.command.Pool.create

      pub fn destroy (
          P : *zvk.command.Pool,
          D : zvk.Device,
        ) void {
        vk.command.pool.destroy(D.logical, P.ct, P.A.vk);
      } //:: zvk.command.Pool.destroy
    }; //:: zvk.command.Pool


    //______________________________________
    // @section Command: Buffer
    //____________________________
    pub const Buffer = struct {
      A    :zvk.Allocator,
      ct   :[]vk.command.Buffer,
      cfg  :vk.command.buffer.Cfg,

      pub const CreateOptions = struct {
        primary : bool  = zvk.cfg.command.primary,
        count   : usize = 1,
        }; //:: zvk.command.Buffer.CreateOptions

      pub fn create (
          D  : zvk.Device,
          P  : zvk.command.Pool,
          in : zvk.command.Buffer.CreateOptions,
          A  : zvk.Allocator,
        ) !zvk.command.Buffer {
        var result = zvk.command.Buffer{
          .A                    = A,
          .cfg                  = vk.command.buffer.Cfg{
            .sType              = vk.stype.command.buffer.Cfg,      // VkStructureType = @import("std").mem.zeroes(VkStructureType),
            .pNext              = null,                             // ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
            .commandPool        = P.ct,                             // VkCommandPool = @import("std").mem.zeroes(VkCommandPool),
            .level              =                                   // VkCommandBufferLevel = @import("std").mem.zeroes(VkCommandBufferLevel),
              if (in.primary)   vk.command.buffer.level.Primary
              else              vk.command.buffer.level.Secondary,
            .commandBufferCount = @intCast(in.count),               // u32 = @import("std").mem.zeroes(u32),
            }, //:: result.cfg
          }; //:: result
        result.ct = try result.A.zig.alloc(vk.command.Buffer, in.count);
        try vk.ok(vk.command.buffer.create(D.logical, &result.cfg, result.ct.ptr));
        return result;
      } //:: zvk.command.Buffer.create

      pub fn destroy (
          B : *zvk.command.Buffer,
        ) void {
        // vk.command.buffer.destroy(D.logical, C.pool, C.buffer.len, C.buffer.ptr);  // Freed by destroying the pool
        B.A.zig.free(B.ct);
      } //:: zvk.command.Buffer.destroy
    }; //:: zvk.command.Buffer


    //______________________________________
    // @section Command: Batch
    //____________________________
    pub const Batch = struct {
      A       :zvk.Allocator,
      pool    :zvk.command.Pool,
      buffer  :zvk.command.Buffer,

      pub const CreateOptions = struct {
        transient : bool  = zvk.cfg.command.transient,
        reset     : bool  = zvk.cfg.command.reset,
        protected : bool  = zvk.cfg.command.protected,
        primary   : bool  = zvk.cfg.command.primary,
        buffers   : usize = 1,
        }; //:: zvk.command.Batch.CreateOptions

      pub fn create (
          D  : zvk.Device,
          in : zvk.command.Batch.CreateOptions,
          A  : zvk.Allocator,
        ) !zvk.command.Batch {
        // FIX: Non-Graphics Commands
        if (D.queue.graphics == null) return error.command_InvalidGraphicsQueue;
        var result = zvk.command.Batch{
          .A           = A,
          .buffer      = undefined,
          .pool        = try zvk.command.Pool.create(D, D.queue.graphics.?.id, .{
            .reset     = in.reset,
            .transient = in.transient,
            .protected = in.protected
            }, A), //:: result.pool
           }; //:: result
        // Create the Command Buffers
        result.buffer = try zvk.command.Buffer.create(D, result.pool.ct, .{
          .count   = in.buffers,
          .primary = in.primary,
          }, result.A);
        return result;
      } //:: zvk.command.Batch.create

      pub fn destroy (
          C : *zvk.command.Batch,
          D : zvk.Device,
        ) void {
        C.pool.destroy(D);
        C.buffer.destroy();
      } //:: zvk.command.Batch.destroy
    }; //:: zvk.command.Batch
  }; //:: zvk.command


  //______________________________________
  // @section Actions
  //____________________________
  pub const action = struct {
    pub const attachments = struct {
      pub const ClearOptions = struct {
        id         : u32 = 0,
        color      : zvk.color.rgba.F32 = .{.r=0.0, .g=0.0, .b=0.0, .a=0.0},
        depth      : f32 = 0.0,
        stencil    : u32 = 0,
        flags      : vk.flags.image.Aspect = vk.flags.image.Aspect.toInt(.{
          .color   = true,
          .depth   = false,
          .stencil = false,
          }), //:: zvk.action.attachments.ClearOptions.flags
        startPos   : struct { x :i32= 0, y :i32= 0 },
        size       : struct { w :u32= 0, h :u32= 0 },
      }; //:: zvk.action.attachments.ClearOptions
      pub fn clear (
           B  : vk.command.Buffer,
           in : zvk.action.attachments.ClearOptions,
        ) void {
        vk.action.attachments.clear(B, // vkCmdClearAttachments( commandBuffer: VkCommandBuffer,
          1, &vk.clear.Attachment{  //   attachmentCount: u32,  pAttachments: [*c]const VkClearAttachment,
            .aspectMask      = in.flags,
            .colorAttachment = in.id,
            .clearValue      = .{
              .color         = .{.float32= [4].{in.color.r, in.color.g, in.color.b, in.color.a}},
              .depthStencil  = .{.depth = in.depth, .stencil= in.stencil },},
            }, //:: pRects
          1, &vk.clear.Rect{  //   rectCount: u32, pRects: [*c]const VkClearRect
            .rect            = .{
              .offset        = .{.x     = in.startPos.x, .y      = in.startPos.y},
              .extent        = .{.width = in.size.w,     .height = in.size.h    },
            }, //:: pAttachments
            .baseArrayLayer  = 0,
            .layerCount      = 1,},
          );
      } //:: zvk.action.attachments.clear
    }; //:: zvk.action.attachments
  }; //:: zvk.action
}; //:: zvk

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//______________________________________
// TODO: External zvk_thing_fn API for C
const C_ = struct {
  export fn zvk_tmp_add  (a :c_int, b :c_int) c_int { return a + b; }
  export fn zvk_tmp_add2 (a :  u32, b :  u32)   u32 { return a + b; }
}; comptime { _ = &C_; } // Force exports to be analyzed
//______________________________________

