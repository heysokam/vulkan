//:______________________________________________________________________
//  zvulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// @deps vulkan
const c = @import("../lib/vulkan.zig");

pub const stype              = struct {
  pub const app              = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_APPLICATION_INFO;
  }; //:: vk.stype.app
  pub const instance         = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
  }; //:: vk.stype.instance
  pub const debug            = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
  }; //:: vk.stype.debug
  pub const queue            = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
  }; //:: vk.stype.queue
  pub const swapchain        = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
  }; //:: vk.stype.swapchain
  pub const image            = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
    pub const view           = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
    }; //:: vk.stype.image.view
  }; //:: vk.stype.image
  pub const device           = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
    pub const Features10     = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2;
    pub const Features11     = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_1_FEATURES;
    pub const Features12     = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_2_FEATURES;
    pub const Features13     = c.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_3_FEATURES;
  }; //:: vk.stype.device
  pub const shader           = struct {
    pub const Cfg            = c.VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
    pub const stage          = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
    }; //:: vk.stype.shader.stage
  }; //:: vk.stype.shader
  pub const pipeline         = struct {
    pub const graphics       = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
      pub const state        = struct {
        pub const dynamic    = struct {
          pub const Cfg      = c.VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO;
        }; //:: vk.stype.pipeline.graphics.dynamic
      }; //:: vk.stype.pipeline.graphics.dynamic
      pub const vertex       = struct {
        pub const input      = struct {
          pub const Cfg      = c.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
        }; //:: vk.stype.pipeline.graphics.vertex.input
        pub const assembly   = struct {
          pub const Cfg      = c.VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
        }; //:: vk.stype.pipeline.graphics.vertex.assembly
      }; //:: vk.stype.pipeline.graphics.vertex
      pub const viewport     = struct {
        pub const Cfg        = c.VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
      }; //:: vk.stype.pipeline.graphics.viewport
      pub const raster       = struct {
        pub const Cfg        = c.VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
        pub const msaa       = struct {
          pub const Cfg      = c.VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
        }; //:: vk.stype.pipeline.graphics.raster.msaa
        pub const blend      = struct {
          pub const Cfg      = c.VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
        }; //:: vk.stype.pipeline.graphics.raster.blend
      }; //:: vk.stype.pipeline.graphics.raster
      pub const shape      = struct {
        pub const Cfg      = c.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
      }; //:: vk.stype.pipeline.graphics.raster.shape
    }; //:: vk.stype.pipeline.graphics
    pub const compute        = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_CREATE_INFO;
    }; //:: vk.stype.pipeline.compute
  }; //:: vk.stype.shader
  pub const render           = struct {
    pub const pass           = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
    }; //:: vk.stype.render.pass
  }; //:: vk.stype.render
  pub const command          = struct {
    pub const pool           = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
    }; //:: vk.stype.pool
    pub const buffer         = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
    }; //:: vk.stype.buffer
  }; //:: vk.stype.command
  pub const sync             = struct {
    pub const fence          = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
    }; //:: vk.stype.fence
    pub const semaphore      = struct {
      pub const Cfg          = c.VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
    }; //:: vk.stype.fence
  }; //:: vk.stype.sync
}; //:: vk.stype

