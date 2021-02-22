# -------------------------------------------------------------------
# zsh config local
# -------------------------------------------------------------------

# Instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM="xterm-256color"
ZSH=$HOME/.oh-my-zsh
ZSH_THEME=powerlevel10k/powerlevel10k
plugins=(git compleat zsh-syntax-highlighting zsh-autosuggestions history-substring-search)
autoload -U compinit && compinit
source $ZSH/oh-my-zsh.sh
source ~/git/dotfiles/zsh/local.sh
source ~/git/dotfiles/zsh/aliases.sh
source ~/git/dotfiles/zsh/extras.sh
source ~/git/dotfiles/zsh/p10k.zsh



