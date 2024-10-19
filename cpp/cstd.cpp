//:____________________________________________________________________
//  Cendk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  |
//:____________________________________________________________________
#include "./cstd.hpp"

// clang-format off
//____________________________
template<class... Args> str     f(Args... args) { str result; (result << ... << args); return result; }
template<class... Args> void echo(Args... args) { (std::cout << ... << args) << std::endl; }
template<class... Args> void prnt(Args... args) { (std::cout << ... << args); }
void err(i32 code, str msg) { fprintf(stderr, "Error: %i->%s\n", code, msg.data()); }
//____________________________
// clang-format on
