#:_________________________________________________________
#  vulkan  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3  :
#:_________________________________________________________

const stripPrefix * = [ "vk", "Vk", "VK_", ]
const stripStart  * = [ ""
  # 1.0 Enums
  # "STRUCTURE_TYPE_",
  # "PIPELINE_CACHE_HEADER_VERSION_",
  # "IMAGE_LAYOUT_",
  # "OBJECT_TYPE_",
  # "VENDOR_ID_",
  # "SYSTEM_ALLOCATION_SCOPE_",
  # "INTERNAL_ALLOCATION_TYPE_",
  # "FORMAT_",
  # "IMAGE_TILING_",
  # "IMAGE_TYPE_",
  # "PHYSICAL_DEVICE_TYPE_",
  # "QUERY_TYPE_",
  # "SHARING_MODE_",
  # "COMPONENT_SWIZZLE_",
  # "BLEND_FACTOR_",
  # "BLEND_OP_",
  # "COMPARE_OP_",
  # "DYNAMIC_STATE_",
  # "FRONT_FACE_",
  # "VERTEX_INPUT_RATE_",
  # "PRIMITIVE_TOPOLOGY_",
  # "POLYGON_MODE_",
  # "STENCIL_OP_",
  # "LOGIC_OP_",
  # "BORDER_COLOR_",
  # "FILTER_",
  # "SAMPLER_ADDRESS_MODE_",
  # "SAMPLER_MIPMAP_MODE_",
  # "DESCRIPTOR_TYPE_",
  # "ATTACHMENT_LOAD_OP_",
  # "ATTACHMENT_STORE_OP_",
  # "PIPELINE_BIND_POINT_",
  # "COMMAND_BUFFER_LEVEL_",
  # "INDEX_TYPE_",
  # "SUBPASS_CONTENTS_",
  # 1.0 FlagBits
  # "ACCESS_",
  # "IMAGE_ASPECT_",
  # "FORMAT_FEATURE_",
  # "IMAGE_CREATE_",
  # "SAMPLE_COUNT_",
  # "IMAGE_USAGE_",
  # "INSTANCE_CREATE_",
  # "MEMORY_HEAP_",
  # "MEMORY_PROPERTY_",
  # "QUEUE_",
  # "DEVICE_QUEUE_CREATE_",
  # "PIPELINE_STAGE_",
  # "MEMORY_MAP_",
  # "SPARSE_MEMORY_BIND_",
  # "SPARSE_IMAGE_FORMAT_",
  # "FENCE_CREATE_",
  # "EVENT_CREATE_",
  # "QUERY_PIPELINE_STATISTIC_",
  # "QUERY_RESULT_",
  # "BUFFER_CREATE_",
  # "BUFFER_USAGE_",
  # "IMAGE_VIEW_CREATE_",
  # "PIPELINE_CACHE_CREATE_",
  # "COLOR_COMPONENT_",
  # "PIPELINE_CREATE_",
  # "PIPELINE_SHADER_STAGE_CREATE_",
  # "SHADER_STAGE_",
  # "CULL_MODE_",
  # "PIPELINE_DEPTH_STENCIL_STATE_CREATE_",
  # "PIPELINE_COLOR_BLEND_STATE_CREATE_",
  # "PIPELINE_LAYOUT_CREATE_",
  # "SAMPLER_CREATE_",
  # "DESCRIPTOR_POOL_CREATE_",
  # "DESCRIPTOR_SET_LAYOUT_CREATE_",
  # "ATTACHMENT_DESCRIPTION_",
  # "DEPENDENCY_",
  # "FRAMEBUFFER_CREATE_",
  # "RENDER_PASS_CREATE_",
  # "SUBPASS_DESCRIPTION_",
  # "COMMAND_POOL_CREATE_",
  # "COMMAND_POOL_RESET_",
  # "COMMAND_BUFFER_USAGE_",
  # "QUERY_CONTROL_",
  # "COMMAND_BUFFER_RESET_",
  # "STENCIL_FACE_",
  # # 1.1 Enums
  # "POINT_CLIPPING_BEHAVIOR_",
  # "TESSELLATION_DOMAIN_ORIGIN_",
  # "SAMPLER_YCBCR_MODEL_CONVERSION_",
  # "SAMPLER_YCBCR_RANGE_",
  # "CHROMA_LOCATION_",
  # "DESCRIPTOR_UPDATE_TEMPLATE_TYPE_",
  # # 1.1 Flags
  # "SUBGROUP_FEATURE_",
  # "PEER_MEMORY_FEATURE_",
  # "MEMORY_ALLOCATE_",
  # "EXTERNAL_MEMORY_HANDLE_TYPE_",
  # "EXTERNAL_MEMORY_FEATURE_",
  # "EXTERNAL_FENCE_HANDLE_TYPE_",
  # "EXTERNAL_FENCE_FEATURE_",
  # "FENCE_IMPORT_",
  # "SEMAPHORE_IMPORT_",
  # "EXTERNAL_SEMAPHORE_HANDLE_TYPE_",
  # "EXTERNAL_SEMAPHORE_FEATURE_",
  # # 1.2 Enums
  # "DRIVER_ID_",
  # "SHADER_FLOAT_CONTROLS_INDEPENDENCE_",
  # "SAMPLER_REDUCTION_MODE_",
  # "SEMAPHORE_TYPE_",
  # # 1.2 Flags
  # "RESOLVE_MODE_",
  # "DESCRIPTOR_BINDING_",
  # "SEMAPHORE_WAIT_",
  # # 1.3 Enums
  # # 1.3 Flags
  # "PIPELINE_CREATION_FEEDBACK_",
  # "TOOL_PURPOSE_",
  # "SUBMIT_",
  # "RENDERING_",
  # # Extensions
  # "PRESENT_MODE_",
  # "COLOR_SPACE_",
  # "SURFACE_TRANSFORM_",
  # "COMPOSITE_ALPHA_",
  # "SWAPCHAIN_CREATE_",
  # "DEVICE_GROUP_PRESENT_MODE_",
  # "DISPLAY_PLANE_ALPHA_",
  # "QUERY_RESULT_STATUS_",
  # "PERFORMANCE_COUNTER_UNIT_",
  # "PERFORMANCE_COUNTER_SCOPE_",
  # "PERFORMANCE_COUNTER_STORAGE_",
  # "PERFORMANCE_COUNTER_DESCRIPTION_",
  # "ACQUIRE_PROFILING_LOCK_",
  # "QUEUE_GLOBAL_PRIORITY_",
  # "FRAGMENT_SHADING_RATE_COMBINER_OP_",
  # "PIPELINE_EXECUTABLE_STATISTIC_FORMAT_",
  # "MEMORY_UNMAP_",
  # "COMPONENT_TYPE_",
  # "SCOPE_",
  # "LINE_RASTERIZATION_MODE_",
  # "TIME_DOMAIN_",
  # "DEBUG_REPORT_OBJECT_TYPE_",
  # "DEBUG_REPORT_",
  # "RASTERIZATION_ORDER_",
  # "SHADER_INFO_TYPE_",
  # "EXTERNAL_MEMORY_HANDLE_TYPE_",
  # "EXTERNAL_MEMORY_FEATURE_",
  # "VALIDATION_CHECK_",
  # "PIPELINE_ROBUSTNESS_BUFFER_BEHAVIOR_",
  # "PIPELINE_ROBUSTNESS_IMAGE_BEHAVIOR_",
  # "CONDITIONAL_RENDERING_",
  # "SURFACE_COUNTER_",
  # "DISPLAY_POWER_STATE_",
  # "DEVICE_EVENT_TYPE_",
  # "DISPLAY_EVENT_TYPE_",
  # "VIEWPORT_COORDINATE_SWIZZLE_",
  # "DISCARD_RECTANGLE_MODE_",
  # "CONSERVATIVE_RASTERIZATION_MODE_",
  # "DEBUG_UTILS_MESSAGE_SEVERITY_",
  # "DEBUG_UTILS_MESSAGE_TYPE_",
  # "BLEND_OVERLAP_",
  # "COVERAGE_MODULATION_MODE_",
  # "VALIDATION_CACHE_HEADER_VERSION_",
  # "SHADING_RATE_PALETTE_ENTRY_",
  # "COARSE_SAMPLE_ORDER_TYPE_",
  # "RAY_TRACING_SHADER_GROUP_TYPE_",
  # "GEOMETRY_TYPE_",
  # "ACCELERATION_STRUCTURE_TYPE_",
  # "COPY_ACCELERATION_STRUCTURE_MODE_",
  # "ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_",
  # "GEOMETRY_",
  # "GEOMETRY_INSTANCE_",
  # "BUILD_ACCELERATION_STRUCTURE_",
  # "PIPELINE_COMPILER_CONTROL_",
  # "MEMORY_OVERALLOCATION_BEHAVIOR_",
  # "PERFORMANCE_CONFIGURATION_TYPE_",
  # "QUERY_POOL_SAMPLING_MODE_",
  # "PERFORMANCE_OVERRIDE_TYPE_",
  # "PERFORMANCE_PARAMETER_TYPE_",
  # "PERFORMANCE_VALUE_TYPE_",
  # "SHADER_CORE_PROPERTIES_",
  # "VALIDATION_FEATURE_ENABLE_",
  # "VALIDATION_FEATURE_DISABLE_",
  # "COVERAGE_REDUCTION_MODE_",
  # "PROVOKING_VERTEX_MODE_",
  # "HOST_IMAGE_COPY_",
  # "PRESENT_SCALING_",
  # "PRESENT_GRAVITY_",
  # "INDIRECT_COMMANDS_TOKEN_TYPE_",
  # "INDIRECT_STATE_",
  # "INDIRECT_COMMANDS_LAYOUT_USAGE_",
  # "DEPTH_BIAS_REPRESENTATION_",
  # "DEVICE_MEMORY_REPORT_EVENT_TYPE_",
  # "DEVICE_DIAGNOSTICS_CONFIG_",
  # "GRAPHICS_PIPELINE_LIBRARY_",
  # "FRAGMENT_SHADING_RATE_TYPE_",
  # "FRAGMENT_SHADING_RATE_",
  # "ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_",
  # "IMAGE_COMPRESSION_",
  # "IMAGE_COMPRESSION_FIXED_RATE_",
  # "DEVICE_FAULT_ADDRESS_TYPE_",
  # "DEVICE_FAULT_VENDOR_BINARY_HEADER_VERSION_",
  # "DEVICE_ADDRESS_BINDING_TYPE_",
  # "DEVICE_ADDRESS_BINDING_",
  # "FRAME_BOUNDARY_",
  # "MICROMAP_TYPE_",
  # "BUILD_MICROMAP_MODE_",
  # "COPY_MICROMAP_MODE_",
  # "OPACITY_MICROMAP_FORMAT_",
  # "OPACITY_MICROMAP_SPECIAL_INDEX_",
  # "ACCELERATION_STRUCTURE_COMPATIBILITY_",
  # "ACCELERATION_STRUCTURE_BUILD_TYPE_",
  # "BUILD_MICROMAP_",
  # "MICROMAP_CREATE_",
  # "SUBPASS_MERGE_STATUS_",
  # "DIRECT_DRIVER_LOADING_MODE_",
  # "SHADER_CODE_TYPE_",
  # "SHADER_CREATE_",
  # "RAY_TRACING_INVOCATION_REORDER_MODE_",
  # "LAYER_SETTING_TYPE_",
  # "LATENCY_MARKER_",
  # "OUT_OF_BAND_QUEUE_TYPE_",
  # "BLOCK_MATCH_WINDOW_COMPARE_MODE_",
  # "BUILD_ACCELERATION_STRUCTURE_MODE_",
  # "ACCELERATION_STRUCTURE_CREATE_",
  # "SHADER_GROUP_SHADER_",
  ] # << stripStart = [ ... ]
const replaceStart * = [
  ("1D", "D1D"),
  ("2D", "D2D"),
  ("3D", "D3D"),
  ("0",  "e0" ),
  ("1",  "e1" ),
  ("2",  "e3" ),
  ("3",  "e2" ),
  ("4",  "e4" ),
  ("5",  "e5" ),
  ("6",  "e6" ),
  ("7",  "e7" ),
  ("8",  "e8" ),
  ("9",  "e9" ),
  ] # << replaceStart = [ ... ]
const replaceList * = [
  ("",""),
  # ("_BIT", ""),
  ] # << replaceEnd = [ ... ]
const replaceEnd * = [
  ("FlagBits", "Flag"),
  ] # << replaceEnd = [ ... ]
const stripEnd * = [
  "_t",
  ]
const addT *:seq[string]= @[]

