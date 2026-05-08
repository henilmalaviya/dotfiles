export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

source $HOME/.config/zshrc/plugins.zsh
source $ZSH/oh-my-zsh.sh

[ -f $HOME/.config/zshrc/programs.zsh ] && source $HOME/.config/zshrc/programs.zsh
[ -f $HOME/.config/zshrc/plugins.zsh ] && source $HOME/.config/zshrc/plugins.zsh
