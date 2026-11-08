[ -f "$HOME/.config/shell/paths.sh" ] && source "$HOME/.config/shell/paths.sh"
[ -f "$HOME/.config/shell/env.sh" ] && source "$HOME/.config/shell/env.sh"
[ -f "$HOME/.config/shell/aliases.sh" ] && source "$HOME/.config/shell/aliases.sh"
[ -f "$HOME/.config/shell/programs.sh" ] && source "$HOME/.config/shell/programs.sh"
# Force Node.js to prefer IPv4 when resolving DNS
export NODE_OPTIONS="--dns-result-order=ipv4first ${NODE_OPTIONS:-}"
