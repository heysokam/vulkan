//:__________________________________________________________________
//  cvk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#pragma once
#include "./base.h"
#include "./validation.h"

typedef struct cvk_instance_create_args_s {
  str appName;
  u32 appVers;
  str engineName;
  u32 engineVers;
} cvk_instance_create_args;

VkInstance cvk_instance_create(cvk_instance_create_args in);
