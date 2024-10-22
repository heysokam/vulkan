#:__________________________________________________________________
#  ndk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
type ObjectType *{.importc:"VkObjectType", header:"vulkan/vulkan.h", pure, size:sizeof(int32).}= enum
  unknown                       = 0          , # VK_OBJECT_TYPE_UNKNOWN = 0,
  instance                      = 1          , # VK_OBJECT_TYPE_INSTANCE = 1,
  physicalDevice                = 2          , # VK_OBJECT_TYPE_PHYSICAL_DEVICE = 2,
  device                        = 3          , # VK_OBJECT_TYPE_DEVICE = 3,
  queue                         = 4          , # VK_OBJECT_TYPE_QUEUE = 4,
  semaphore                     = 5          , # VK_OBJECT_TYPE_SEMAPHORE = 5,
  commandBuffer                 = 6          , # VK_OBJECT_TYPE_COMMAND_BUFFER = 6,
  fence                         = 7          , # VK_OBJECT_TYPE_FENCE = 7,
  deviceMemory                  = 8          , # VK_OBJECT_TYPE_DEVICE_MEMORY = 8,
  buffer                        = 9          , # VK_OBJECT_TYPE_BUFFER = 9,
  image                         = 10         , # VK_OBJECT_TYPE_IMAGE = 10,
  event                         = 11         , # VK_OBJECT_TYPE_EVENT = 11,
  queryPool                     = 12         , # VK_OBJECT_TYPE_QUERY_POOL = 12,
  bufferView                    = 13         , # VK_OBJECT_TYPE_BUFFER_VIEW = 13,
  imageView                     = 14         , # VK_OBJECT_TYPE_IMAGE_VIEW = 14,
  shaderModule                  = 15         , # VK_OBJECT_TYPE_SHADER_MODULE = 15,
  pipelineCache                 = 16         , # VK_OBJECT_TYPE_PIPELINE_CACHE = 16,
  pipelineLayout                = 17         , # VK_OBJECT_TYPE_PIPELINE_LAYOUT = 17,
  renderPass                    = 18         , # VK_OBJECT_TYPE_RENDER_PASS = 18,
  pipeline                      = 19         , # VK_OBJECT_TYPE_PIPELINE = 19,
  descriptorSetLayout           = 20         , # VK_OBJECT_TYPE_DESCRIPTOR_SET_LAYOUT = 20,
  sampler                       = 21         , # VK_OBJECT_TYPE_SAMPLER = 21,
  descriptorPool                = 22         , # VK_OBJECT_TYPE_DESCRIPTOR_POOL = 22,
  descriptorSet                 = 23         , # VK_OBJECT_TYPE_DESCRIPTOR_SET = 23,
  framebuffer                   = 24         , # VK_OBJECT_TYPE_FRAMEBUFFER = 24,
  commandPool                   = 25         , # VK_OBJECT_TYPE_COMMAND_POOL = 25,
  surface                       = 1000000000 , # VK_OBJECT_TYPE_SURFACE_KHR = 1000000000,
  swapchain                     = 1000001000 , # VK_OBJECT_TYPE_SWAPCHAIN_KHR = 1000001000,
  display                       = 1000002000 , # VK_OBJECT_TYPE_DISPLAY_KHR = 1000002000,
  displayMode                   = 1000002001 , # VK_OBJECT_TYPE_DISPLAY_MODE_KHR = 1000002001,
  debugReportCallback           = 1000011000 , # VK_OBJECT_TYPE_DEBUG_REPORT_CALLBACK_EXT = 1000011000,
  videoSession                  = 1000023000 , # VK_OBJECT_TYPE_VIDEO_SESSION_KHR = 1000023000,
  videoSessionParameters        = 1000023001 , # VK_OBJECT_TYPE_VIDEO_SESSION_PARAMETERS_KHR = 1000023001,
  cuModuleNVX                   = 1000029000 , # VK_OBJECT_TYPE_CU_MODULE_NVX = 1000029000,
  cuFunctionNVX                 = 1000029001 , # VK_OBJECT_TYPE_CU_FUNCTION_NVX = 1000029001,
  descriptorUpdateTemplate      = 1000085000 , # VK_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE = 1000085000,
  debugUtilsMessenger           = 1000128000 , # VK_OBJECT_TYPE_DEBUG_UTILS_MESSENGER_EXT = 1000128000,
  accelerationStructure         = 1000150000 , # VK_OBJECT_TYPE_ACCELERATION_STRUCTURE_KHR = 1000150000,
  samplerYCBCRConversion        = 1000156000 , # VK_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION = 1000156000,
  validationCache               = 1000160000 , # VK_OBJECT_TYPE_VALIDATION_CACHE_EXT = 1000160000,
  accelerationStructureNV       = 1000165000 , # VK_OBJECT_TYPE_ACCELERATION_STRUCTURE_NV = 1000165000,
  performanceConfigurationINTEL = 1000210000 , # VK_OBJECT_TYPE_PERFORMANCE_CONFIGURATION_INTEL = 1000210000,
  deferredOperation             = 1000268000 , # VK_OBJECT_TYPE_DEFERRED_OPERATION_KHR = 1000268000,
  indirectCommandsLayoutNV      = 1000277000 , # VK_OBJECT_TYPE_INDIRECT_COMMANDS_LAYOUT_NV = 1000277000,
  privateDataSlot               = 1000295000 , # VK_OBJECT_TYPE_PRIVATE_DATA_SLOT = 1000295000,
  cudaModuleNV                  = 1000307000 , # VK_OBJECT_TYPE_CUDA_MODULE_NV = 1000307000,
  cudaFunctionNV                = 1000307001 , # VK_OBJECT_TYPE_CUDA_FUNCTION_NV = 1000307001,
  bufferCollectionFUCHSIA       = 1000366000 , # VK_OBJECT_TYPE_BUFFER_COLLECTION_FUCHSIA = 1000366000,
  micromap                      = 1000396000 , # VK_OBJECT_TYPE_MICROMAP_EXT = 1000396000,
  opticalFlowSessionNV          = 1000464000 , # VK_OBJECT_TYPE_OPTICAL_FLOW_SESSION_NV = 1000464000,
  shader                        = 1000482000 , # VK_OBJECT_TYPE_SHADER_EXT = 1000482000,
  pipelineBinary                = 1000483000 , # VK_OBJECT_TYPE_PIPELINE_BINARY_KHR = 1000483000,
  indirectCommandsLayout        = 1000572000 , # VK_OBJECT_TYPE_INDIRECT_COMMANDS_LAYOUT_EXT = 1000572000,
  indirectExecutionSet          = 1000572001 , # VK_OBJECT_TYPE_INDIRECT_EXECUTION_SET_EXT = 1000572001,

