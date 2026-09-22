#!/bin/sh
# Environment variables - shell-agnostic

export EDITOR='nano'

# Ensure non-interactive bash subshells run by agents also load this environment
export BASH_ENV="$HOME/.config/shell/env.sh"

# Build resource limits (prevents 100% CPU lockups and RAM thrashing)
export DOTNET_CLI_BUILD_MAX_CPU_COUNT=8   # Cap .NET to 8 cores (leaves 4 cores free for system/browser)
export MSBUILDDISABLENODEREUSE=1         # Prevent VBCSCompiler from staying alive in RAM after builds
export MAKEFLAGS="-j8"                   # Cap C/C++ builds to 8 jobs
export CARGO_BUILD_JOBS=8                # Cap Rust builds to 8 jobs
export CMAKE_BUILD_PARALLEL_LEVEL=8      # Cap CMake builds to 8 jobs

[[ -f "$HOME/.config/shell/env_local.sh" ]] && source "$HOME/.config/shell/env_local.sh"
