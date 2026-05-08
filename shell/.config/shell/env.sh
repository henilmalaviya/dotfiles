#!/bin/sh
# Environment variables - shell-agnostic

export EDITOR='nano'

[[ -f "$HOME/.config/shell/env_local.sh" ]] && source "$HOME/.config/shell/env_local.sh"