export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nano'

ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

source $ZSH_CUSTOM/plugins.zsh
source $ZSH_CUSTOM/modules.zsh

# installed programs specific configuration
[ -f $ZSH_CUSTOM/programs.zsh ] && source $ZSH_CUSTOM/programs.zsh
