# -------------------------------------------------------------------
# zsh config remote
# -------------------------------------------------------------------

clear
export TERM="xterm-256color"
ZSH=$HOME/.oh-my-zsh
source ~/git/dotfiles/zsh/theme.sh
plugins=(git gitfast pip compleat zsh-syntax-highlighting zsh-autosuggestions zsh-completions history-substring-search tmux)
autoload -U compinit && compinit
source $ZSH/oh-my-zsh.sh
source ~/git/dotfiles/zsh/remote.sh
source ~/git/dotfiles/zsh/aliases.sh
source ~/git/dotfiles/zsh/extras.sh



