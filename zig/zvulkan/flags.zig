//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @deps std
const std = @import("std");
// @deps vulkan
const c = @import("../lib/vulkan.zig");
const vk = @import("./types.zig");

pub const flags = struct { // namespace
pub fn T (comptime F :type, comptime I :type) type {
  comptime std.debug.assert(@sizeOf(F)    == @sizeOf(I)   );
  // comptime std.debug.assert(@bitSizeOf(F) == @bitSizeOf(I));
  return struct {
    pub fn toInt   (v :F      ) I    { return @bitCast(v); }
    pub fn fromInt (v :I      ) F    { return @bitCast(v); }
    pub fn with    (a :F, b :F) F    { return fromInt(toInt(a) | toInt(b)); }
    pub fn only    (a :F, b :F) F    { return fromInt(toInt(a) & toInt(b)); }
    pub fn without (a :F, b :F) F    { return fromInt(toInt(a) & ~toInt(b)); }
    pub fn hasAll  (a :F, b :F) bool { return (toInt(a) & toInt(b)) == toInt(b); }
    pub fn hasAny  (a :F, b :F) bool { return (toInt(a) & toInt(b)) != 0; }
    pub fn isEmpty (a :F      ) bool { return toInt(a) == 0; }
  };
}


pub const InstanceCreate = packed struct {
  enumeratePortability  :bool= false, // c.VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR,
  __reserved_bits_00_30 :u31=  0,
  pub usingnamespace flags.T(@This(), vk.Flags);
}; //:: vk.flags.InstanceCreate

pub const debug = struct {
  pub const Create = packed struct {
    __reserved_bits_00_31 :u32=0,
    pub usingnamespace flags.T(@This(), vk.Flags);
  }; //:: vk.flags.debug.Create

  pub const Severity = packed struct {
    verbose               :bool = false,
    __reserved_bits_01_03 :u3=0,
    info                  :bool = false,
    __reserved_bits_05_07 :u3=0,
    warning               :bool = false,
    __reserved_bits_09_11 :u3=0,
    Error                 :bool = false,
    __reserved_bits_13_31 :u19=0,
    pub usingnamespace flags.T(@This(), vk.Flags);
  }; //:: vk.flags.debug.Severity

  pub const MsgType = packed struct {
    general               :bool = false,
    validation            :bool = false,
    performance           :bool = false,
    deviceAddressBinding  :bool = false,
    __reserved_bits_04_31 :u28=0,
    pub usingnamespace flags.T(@This(), vk.Flags);
  }; //:: vk.flags.debug.MsgType
}; //:: vk.flags.debug

pub const Queue = packed struct {
  graphics              :bool = false, // 00 :: VK_QUEUE_GRAPHICS_BIT
  compute               :bool = false, // 01 :: VK_QUEUE_COMPUTE_BIT
  transfer              :bool = false, // 02 :: VK_QUEUE_TRANSFER_BIT
  sparseBinding         :bool = false, // 03 :: VK_QUEUE_SPARSE_BINDING_BIT
  protected             :bool = false, // 04 :: VK_QUEUE_PROTECTED_BIT
  videoDecode           :bool = false, // 05 :: VK_QUEUE_VIDEO_DECODE_BIT_KHR
  videoEncode           :bool = false, // 06 :: VK_QUEUE_VIDEO_ENCODE_BIT_KHR
  NV_opticalFlow        :bool = false, // 07 :: VK_QUEUE_OPTICAL_FLOW_BIT_NV
  __reserved_bits_08_31 :u24=0,
  pub usingnamespace flags.T(@This(), vk.Flags);
}; // vk.flags.Queue

pub const Swapchain = packed struct {
  splitInstanceBindRegions :bool = false, // 00 :: VK_SWAPCHAIN_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR :c_int=  1;
  protected                :bool = false, // 01 :: VK_SWAPCHAIN_CREATE_PROTECTED_BIT_KHR                   :c_int=  2;
  mutableFormat            :bool = false, // 02 :: VK_SWAPCHAIN_CREATE_MUTABLE_FORMAT_BIT_KHR              :c_int=  4;
  deferredMemoryAllocation :bool = false, // 03 :: VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_EXT  :c_int=  8;
  __reserved_bits_04_31 :u28=0,
  pub usingnamespace flags.T(@This(), vk.Flags);
}; // vk.flags.Swapchain

pub const CompositeAlpha = packed struct {
  Opaque         :bool = false, // 00 :: VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR
  preMultiplied  :bool = false, // 01 :: VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR
  postMultiplied :bool = false, // 02 :: VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR
  inherit        :bool = false, // 03 :: VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR
  __reserved_bits_04_31 :u28=0,
  pub usingnamespace flags.T(@This(), vk.Flags);
}; // vk.flags.CompositeAlpha

pub const image = struct {
  pub const Usage = packed struct {
    transferSrc                   :bool = false,  // 00 :: VK_IMAGE_USAGE_TRANSFER_SRC_BIT                          :c_int=         1;
    transferDst                   :bool = false,  // 01 :: VK_IMAGE_USAGE_TRANSFER_DST_BIT                          :c_int=         2;
    sampled                       :bool = false,  // 02 :: VK_IMAGE_USAGE_SAMPLED_BIT                               :c_int=         4;
    storage                       :bool = false,  // 03 :: VK_IMAGE_USAGE_STORAGE_BIT                               :c_int=         8;
    colorAttachment               :bool = false,  // 04 :: VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT                      :c_int=        16;
    depthStencilAttachment        :bool = false,  // 05 :: VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT              :c_int=        32;
    transientAttachment           :bool = false,  // 06 :: VK_IMAGE_USAGE_TRANSIENT_ATTACHMENT_BIT                  :c_int=        64;
    inputAttachment               :bool = false,  // 07 :: VK_IMAGE_USAGE_INPUT_ATTACHMENT_BIT                      :c_int=       128;
    fragmentShadingRateAttachment :bool = false,  // 08 :: VK_IMAGE_USAGE_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_KHR  :c_int=       256;
    fragmentDensityMap            :bool = false,  // 09 :: VK_IMAGE_USAGE_FRAGMENT_DENSITY_MAP_BIT_EXT              :c_int=       512;
    videoDecodeDst                :bool = false,  // 10 :: VK_IMAGE_USAGE_VIDEO_DECODE_DST_BIT_KHR                  :c_int=      1024;
    videoDecodeSrc                :bool = false,  // 11 :: VK_IMAGE_USAGE_VIDEO_DECODE_SRC_BIT_KHR                  :c_int=      2048;
    videoDecodeDpb                :bool = false,  // 12 :: VK_IMAGE_USAGE_VIDEO_DECODE_DPB_BIT_KHR                  :c_int=      4096;
    videoEncodeDst                :bool = false,  // 13 :: VK_IMAGE_USAGE_VIDEO_ENCODE_DST_BIT_KHR                  :c_int=      8192;
    videoEncodeSrc                :bool = false,  // 14 :: VK_IMAGE_USAGE_VIDEO_ENCODE_SRC_BIT_KHR                  :c_int=     16384;
    videoEncodeDpb                :bool = false,  // 15 :: VK_IMAGE_USAGE_VIDEO_ENCODE_DPB_BIT_KHR                  :c_int=     32768;
    __reserved_bits_16_17 :u2=0,
    HUAWEI_invocationMask         :bool = false,  // 18 :: VK_IMAGE_USAGE_INVOCATION_MASK_BIT_HUAWEI                :c_int=   262_144;
    attachmentFeedbackLoop        :bool = false,  // 19 :: VK_IMAGE_USAGE_ATTACHMENT_FEEDBACK_LOOP_BIT_EXT          :c_int=   524_288;
    QCOM_sampleWeight             :bool = false,  // 20 :: VK_IMAGE_USAGE_SAMPLE_WEIGHT_BIT_QCOM                    :c_int= 1_048_576;
    QCOM_sampleBlockMatch         :bool = false,  // 21 :: VK_IMAGE_USAGE_SAMPLE_BLOCK_MATCH_BIT_QCOM               :c_int= 2_097_152;
    hostTransfer                  :bool = false,  // 22 :: VK_IMAGE_USAGE_HOST_TRANSFER_BIT_EXT                     :c_int= 4_194_304;
    __reserved_bits_23_31 :u9=0,
    pub usingnamespace flags.T(@This(), vk.Flags);

    pub const NV_shadingRateImage = @This(){.fragmentShadingRateAttachment= true}; // VK_IMAGE_USAGE_SHADING_RATE_IMAGE_BIT_NV: c_int = 256;
  }; //:: vk.flags.image.Usage

  pub const Aspect = packed struct {
    color        :bool = false,  // 00 :: VK_IMAGE_ASPECT_COLOR_BIT              :c_int=    1;
    depth        :bool = false,  // 01 :: VK_IMAGE_ASPECT_DEPTH_BIT              :c_int=    2;
    stencil      :bool = false,  // 02 :: VK_IMAGE_ASPECT_STENCIL_BIT            :c_int=    4;
    metadata     :bool = false,  // 03 :: VK_IMAGE_ASPECT_METADATA_BIT           :c_int=    8;
    plane0       :bool = false,  // 04 :: VK_IMAGE_ASPECT_PLANE_0_BIT            :c_int=   16;
    plane1       :bool = false,  // 05 :: VK_IMAGE_ASPECT_PLANE_1_BIT            :c_int=   32;
    plane2       :bool = false,  // 06 :: VK_IMAGE_ASPECT_PLANE_2_BIT            :c_int=   64;
    memoryPlane0 :bool = false,  // 07 :: VK_IMAGE_ASPECT_MEMORY_PLANE_0_BIT_EXT :c_int=  128;
    memoryPlane1 :bool = false,  // 08 :: VK_IMAGE_ASPECT_MEMORY_PLANE_1_BIT_EXT :c_int=  256;
    memoryPlane2 :bool = false,  // 09 :: VK_IMAGE_ASPECT_MEMORY_PLANE_2_BIT_EXT :c_int=  512;
    memoryPlane3 :bool = false,  // 10 :: VK_IMAGE_ASPECT_MEMORY_PLANE_3_BIT_EXT :c_int= 1024;
    __reserved_bits_11_31 :u21=0,
    pub usingnamespace flags.T(@This(), vk.Flags);

    pub const none = @This(){};
  }; //:: vk.flags.image.Aspect
}; //:: vk.flags.image

pub const Shader = packed struct {
  __reserved_bits_00_31 :u32=0,
  pub usingnamespace flags.T(@This(), vk.Flags);
}; //:: vk.flags.image

pub const command = struct {
  pub const Pool = packed struct {
    transient  :bool= false,  // 00 :: VK_COMMAND_POOL_CREATE_TRANSIENT_BIT            = 0x00000001,
    reset      :bool= false,  // 01 :: VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT = 0x00000002,
    protected  :bool= false,  // 02 :: VK_COMMAND_POOL_CREATE_PROTECTED_BIT            = 0x00000004,
    __reserved_bits_03_31 :u29=0,
    pub usingnamespace flags.T(@This(), vk.Flags);
  }; //:: vk.flags.command.Pool
}; //:: vk.flags.command

pub const sync = struct {
  pub const Fence = packed struct {
    signaled  :bool= false,  // 00 :: VK_FENCE_CREATE_SIGNALED_BIT  :c_int=  1;
    __reserved_bits_00_30 :u31=  0,
    pub usingnamespace flags.T(@This(), vk.Flags);
  }; //:: vk.flags.sync.Fence
}; //:: vk.flags.sync

pub const Samples = packed struct {
  c01  :bool = false,  // 01 :: VK_SAMPLE_COUNT_1_BIT  :c_int=   1;
  c02  :bool = false,  // 02 :: VK_SAMPLE_COUNT_2_BIT  :c_int=   2;
  c04  :bool = false,  // 03 :: VK_SAMPLE_COUNT_4_BIT  :c_int=   4;
  c08  :bool = false,  // 04 :: VK_SAMPLE_COUNT_8_BIT  :c_int=   8;
  c16  :bool = false,  // 05 :: VK_SAMPLE_COUNT_16_BIT :c_int=  16;
  c32  :bool = false,  // 06 :: VK_SAMPLE_COUNT_32_BIT :c_int=  32;
  c64  :bool = false,  // 07 :: VK_SAMPLE_COUNT_64_BIT :c_int=  64;
  __reserved_bits_08_31 :u25=0,
  pub usingnamespace flags.T(@This(), vk.Flags);
}; //:: vk.flags.Samples

}; //:: vk.flags

