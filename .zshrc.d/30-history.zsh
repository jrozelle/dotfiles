# ====================
# History
# ====================
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search   # Up arrow
bindkey '^[[B' down-line-or-beginning-search # Down arrow
# Accept suggestion with → (right arrow)
bindkey '^[[C' forward-char

setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt APPEND_HISTORY
export HISTSIZE=20000
export SAVEHIST=20000
export HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
