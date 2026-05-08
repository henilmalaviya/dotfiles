# Local Plugin settings like:
# ssh-agent identities
[[ -f "$HOME/.config/zshrc/plugins_local.zsh" ]] && source "$HOME/.config/zshrc/plugins_local.zsh"

zstyle :omz:plugins:ssh-agent quiet yes

plugins=(git zsh-autosuggestions zsh-syntax-highlighting ssh-agent)
