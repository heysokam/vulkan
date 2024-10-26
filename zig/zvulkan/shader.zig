//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Vulkan Shader Management
//_________________________________________|
// @deps vulkan
const c      = @import("../lib/vulkan.zig");
const vk     = @import("./types.zig");
const FlagsT = @import("./flags.zig").flags.T;

pub const Shader      = shader.T;
pub const shader      = struct {
  pub const T         = c.VkShaderModule;
  pub const Cfg       = c.VkShaderModuleCreateInfo;
  pub const create    = c.vkCreateShaderModule;
  pub const destroy   = c.vkDestroyShaderModule;
  pub const stage     = struct {
    pub const Cfg     = c.VkPipelineShaderStageCreateInfo;
    pub const Flags   = packed struct {
      vertex                  :bool = false, // 00 :: VK_SHADER_STAGE_VERTEX_BIT                  :c_int=       1;
      tesselation_control     :bool = false, // 01 :: VK_SHADER_STAGE_TESSELLATION_CONTROL_BIT    :c_int=       2;
      tesselation_evaluation  :bool = false, // 02 :: VK_SHADER_STAGE_TESSELLATION_EVALUATION_BIT :c_int=       4;
      geometry                :bool = false, // 03 :: VK_SHADER_STAGE_GEOMETRY_BIT                :c_int=       8;
      fragment                :bool = false, // 04 :: VK_SHADER_STAGE_FRAGMENT_BIT                :c_int=      16;
      compute                 :bool = false, // 05 :: VK_SHADER_STAGE_COMPUTE_BIT                 :c_int=      32;
      task                    :bool = false, // 06 :: VK_SHADER_STAGE_TASK_BIT_EXT                :c_int=      64;
      mesh                    :bool = false, // 07 :: VK_SHADER_STAGE_MESH_BIT_EXT                :c_int=     128;
      raygen                  :bool = false, // 08 :: VK_SHADER_STAGE_RAYGEN_BIT_KHR              :c_int=     256;
      hit_any                 :bool = false, // 09 :: VK_SHADER_STAGE_ANY_HIT_BIT_KHR             :c_int=     512;
      hit_closest             :bool = false, // 10 :: VK_SHADER_STAGE_CLOSEST_HIT_BIT_KHR         :c_int=    1024;
      hit_miss                :bool = false, // 11 :: VK_SHADER_STAGE_MISS_BIT_KHR                :c_int=    2048;
      hit_intersection        :bool = false, // 12 :: VK_SHADER_STAGE_INTERSECTION_BIT_KHR        :c_int=    4096;
      callable                :bool = false, // 13 :: VK_SHADER_STAGE_CALLABLE_BIT_KHR            :c_int=    8192;
      HUAWEI_subpassShading   :bool = false, // 14 :: VK_SHADER_STAGE_SUBPASS_SHADING_BIT_HUAWEI  :c_int=   16384;
      __reserved_bits_15_18 :u4=0,
      HUAWEI_clusterCulling   :bool = false, // 19 :: VK_SHADER_STAGE_CLUSTER_CULLING_BIT_HUAWEI  :c_int=  524288;
      __reserved_bits_20_31 :u12=0,
      pub usingnamespace FlagsT(@This(), vk.Flags);

      pub const graphics = shader.stage.Flags{ // NN :: VK_SHADER_STAGE_ALL_GRAPHICS: c_int = 31;
        .vertex                 = true,
        .tesselation_control    = true,
        .tesselation_evaluation = true,
        .geometry               = true,
        .fragment               = true,
        };
      pub const all = shader.stage.Flags.fromInt(2147483647); // NN :: VK_SHADER_STAGE_ALL: c_int = 2147483647;
    }; //:: vk.shader.stage.Flags
  }; //:: vk.shader.stage
}; //:: vk.shader

