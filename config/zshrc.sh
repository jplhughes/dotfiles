CONFIG_DIR=$(dirname $(realpath ${(%):-%x}))
DOT_DIR=$CONFIG_DIR/..

# Instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export TERM="xterm-256color"

ZSH_DISABLE_COMPFIX=true
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH=$HOME/.oh-my-zsh

plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-history-substring-search)

source $ZSH/oh-my-zsh.sh
source $CONFIG_DIR/aliases.sh
source $CONFIG_DIR/p10k.zsh
source $CONFIG_DIR/extras.sh
source $CONFIG_DIR/key_bindings.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

add_to_path "${DOT_DIR}/custom_bins"
cat $CONFIG_DIR/start.txt

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
