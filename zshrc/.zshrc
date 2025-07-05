export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nano'

ZSH_THEME="robbyrussell"

source $HOME/.config/zshrc/plugins.zsh

source $ZSH/oh-my-zsh.sh

source $HOME/.config/zshrc/modules.zsh

# installed programs specific configuration
[ -f $HOME/.config/zshrc/programs.zsh ] && source $HOME/.config/zshrc/programs.zsh
