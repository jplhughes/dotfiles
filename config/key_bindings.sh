# Note: must set "Left Option key" in iTerm2 to "Esc+" for this to work

# convert a python command to a debug command
function replace-python {
  if [[ $BUFFER =~ ^python\ .* ]]; then
    BUFFER="python3 -m debugpy --listen 5678 --wait-for-client ${BUFFER#python }"
    zle reset-prompt
  fi
}
zle -N replace-python
bindkey "\ed" replace-python

# prepend sudo to the current command
function prepend-sudo {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"; CURSOR+=5
    zle reset-prompt
  fi
}
zle -N prepend-sudo
bindkey "\es" prepend-sudo