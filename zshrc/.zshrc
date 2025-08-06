export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nano'

ZSH_THEME="robbyrussell"

source $HOME/.config/zshrc/plugins.zsh

source $ZSH/oh-my-zsh.sh

source $HOME/.config/zshrc/modules.zsh
source $HOME/.config/zshrc/aliases.zsh

# installed programs specific configuration
[ -f $HOME/.config/zshrc/programs.zsh ] && source $HOME/.config/zshrc/programs.zsh

# environment variables
[ -f $HOME/.config/zshrc/env.zsh ] && source $HOME/.config/zshrc/env.zsh

# local aliases
[ -f $HOME/.config/zshrc/aliases_local.zsh ] && source $HOME/.config/zshrc/aliases_local.zsh
