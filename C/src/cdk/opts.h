//:__________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:__________________________________________________________________
#pragma once
#include "./std.h"

void opt_parse(const int argc, const char *argv[]);

//_________________________________________________
/// Header Only | Define this in only one file.  //
#if defined cdk_opts //
//_________________________________//
#include "./opts.c"
#endif // cdk_opts
