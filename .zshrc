# --------------------
# PATH (portable Mac + Synology/Entware)
# --------------------

# Entware (Synology): /opt/bin + /opt/usr/bin
if [[ -d /opt/bin || -d /opt/usr/bin ]]; then
  export PATH="/opt/bin:/opt/sbin:/opt/usr/bin:/opt/usr/sbin:$PATH"
fi

# Éliminer les doublons dans PATH (cause du "where" qui affiche 3x)
typeset -U PATH path

# Homebrew (macOS): keep brew first if present
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --------------------
# Environment
# --------------------
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
  export VISUAL=nvim
elif command -v micro >/dev/null 2>&1; then
  export EDITOR=micro
  export VISUAL=micro
else
  export EDITOR=vim
  export VISUAL=vim
fi
export MICRO_TRUECOLOR=1

# --------------------
# Zsh core
# --------------------
setopt autocd
setopt extendedglob
setopt nomatch
setopt notify
setopt correct

# --------------------
# Helpers
# --------------------
_has() { command -v "$1" >/dev/null 2>&1; }
case "$OSTYPE" in
  darwin*) _os=mac;;
  linux*) _os=linux;;
  *) _os=other;;
esac

# --------------------
# Completion (rapide, propre)
# --------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
bindkey '^I' complete-word
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*'
if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi
[[ -d ~/.zsh/completions ]] && fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit
# Régénère le cache toutes les 24h, sinon utilise le cache existant
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# --------------------
# Antidote (plugins)
# --------------------
_antidote_files=(
  /opt/homebrew/share/antidote/antidote.zsh
  /usr/share/antidote/antidote.zsh
  "$HOME/.antidote/antidote.zsh"
  "$HOME/.zsh/plugins/antidote/antidote.zsh"
)
for _antidote in "${_antidote_files[@]}"; do
  if [[ -r "$_antidote" ]]; then
    source "$_antidote"
    _plugin_list="${HOME}/.zsh_plugins.txt"
    if [[ -f "${HOME}/.zsh_plugins.zsh" ]]; then
      source "${HOME}/.zsh_plugins.zsh"
    elif [[ -f "${_plugin_list}" ]]; then
      antidote load < "${_plugin_list}"
    else
      antidote load <<'ANTIDOTE_EOF'
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
ANTIDOTE_EOF
    fi
    unset _plugin_list
    break
  fi
done
unset _antidote _antidote_files

# --------------------
# Load .zshrc.d fragments (tri alphabétique = ordre numéroté)
# --------------------
for _f in "${ZDOTDIR:-$HOME}"/.zshrc.d/*.zsh(N); do
  source "$_f"
done
unset _f _os

# --------------------
# Overrides locaux (non versionnés — tokens, chemins machine-spécifiques)
# --------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
