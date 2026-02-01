# --------------------
# PATH (portable Mac + Synology/Entware)
# --------------------

# Entware (Synology): /opt/bin + /opt/usr/bin
if [[ -d /opt/bin || -d /opt/usr/bin ]]; then
  export PATH="/opt/bin:/opt/sbin:/opt/usr/bin:/opt/usr/sbin:$PATH"
fi

# Homebrew (macOS): keep brew first if present
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --------------------
# Environment
# --------------------
export EDITOR=vim
export VISUAL=vim
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
autoload -Uz compinit
compinit -C

# --------------------
# Synology tweaks
# --------------------
if [[ -f /etc/synoinfo.conf ]]; then
  alias cdd='cd /volume1/docker'
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

# ====================
# Aliases: navigation
# ====================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'

# ====================
# Aliases: ls / eza
# ====================
if _has eza; then
  alias l='eza -lah --git --group-directories-first'
  alias ll='eza -lh --git --group-directories-first'
  alias la='eza -a --group-directories-first'
  alias lt='eza -lah --git --sort=modified --reverse'
  alias tree='eza --tree --level=2 --group-directories-first'
  alias tree3='eza --tree --level=3 --group-directories-first'
else
  alias l='ls -lah'
  alias ll='ls -lh'
  alias la='ls -a'
  alias lt='ls -lt'
  alias tree='ls -lah'
  alias tree3='ls -lah'
fi

# ====================
# Aliases: fichiers
# ====================
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# ====================
# Aliases: recherche
# ====================
if _has grep && grep --version >/dev/null 2>&1; then
  alias g='grep -n --color=auto'
elif _has ggrep; then
  alias g='ggrep -n --color=auto'
else
  alias g='grep -n'
fi
if _has rg; then
  alias rg='rg --smart-case'
fi
if _has fd; then
  alias find='fd'
fi
if _has bat; then
  alias cat='bat --paging=never'
  alias less='bat'
fi

# ====================
# Aliases: éditeurs
# ====================
if _has nvim; then
  alias v='nvim'
  alias vi='nvim'
  alias vim='nvim'
fi
if _has micro; then
  alias m='micro'
fi

# ====================
# Aliases: git (essentiels)
# ====================
alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gb='git branch'
alias gbd='git branch -d'
alias gl='git pull --rebase'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gd='git diff'
alias gds='git diff --staged'
alias glog='git log --oneline --decorate --graph --all -n 25'

# ====================
# Aliases: réseau / system
# ====================
if [[ "$_os" == mac ]]; then
  alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
fi
if _has lsof; then
  alias ports='lsof -nP -iTCP -sTCP:LISTEN'
fi
myip() {
  if _has curl; then
    curl -s https://ifconfig.me
  elif _has wget; then
    wget -qO- https://ifconfig.me
  fi
  echo
}
alias pingg='ping -c 5 1.1.1.1'
if [[ "$_os" == mac ]]; then
  alias brewup='brew upgrade -g && brew cleanup --prune=0'
fi

# ====================
# Aliases: docker
# ====================
if _has lazygit; then
  alias lzg='lazygit'
fi

if _has docker; then
  alias d='docker'
  alias dc='docker compose'
  alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dlog='docker logs -f --tail=200'
  alias dexec='docker exec -it'

  # Stats temps réel (CPU, RAM, Network)
  alias dstats='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'

  # Restart rapide
  dre() { docker restart "$@" && docker logs -f --tail=50 "$1"; }

  # Shell dans un container (bash ou sh)
  dsh() {
    docker exec -it "$1" bash 2>/dev/null || docker exec -it "$1" sh
  }

  # Cleanup (images dangling, containers stoppés, volumes orphelins)
  dclean() {
    echo "Containers stoppés:"
    docker container prune -f
    echo "\nImages dangling:"
    docker image prune -f
    echo "\nVolumes orphelins:"
    docker volume prune -f
    echo "\nEspace récupéré:"
    docker system df
  }

  # Espace disque Docker
  alias ddf='docker system df -v'

  # Pull toutes les images et rebuild
  dup() {
    if [[ -f docker-compose.yml || -f compose.yml ]]; then
      docker compose pull && docker compose up -d
    else
      echo "Pas de docker-compose.yml dans ce dossier"
    fi
  }
fi

# ====================
# Bindkey
# ====================
# Emacs mode (Ctrl+A/E pour début/fin de ligne)
bindkey -e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Delete / Fn+Backspace (forward delete)
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char

# Home / End (selon terminal)
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# Option/Alt + flèches (sauter par mot)
bindkey '^[[1;3D' backward-word    # Option+Left
bindkey '^[[1;3C' forward-word     # Option+Right
bindkey '^[b' backward-word        # Alt+B (fallback)
bindkey '^[f' forward-word         # Alt+F (fallback)

# Mots moins agressifs
ZSH_DEFAULT_WORDCHARS="$WORDCHARS"
WORDCHARS="${WORDCHARS//[\/._-]/}"

# Option+Backspace (ESC + DEL)
bindkey '^[^?' backward-kill-word

# Option+Shift+Backspace (ESC + BS) => agressif (jusqu'à espace)
backward-kill-space-word() {
  local _old="$WORDCHARS"
  WORDCHARS="$ZSH_DEFAULT_WORDCHARS"
  zle backward-kill-word
  WORDCHARS="$_old"
}
zle -N backward-kill-space-word
bindkey '^[^H' backward-kill-space-word

# --------------------
# Shift+Arrows (sélection de texte)
# --------------------
# Widgets pour shift-select
shift-left() {
  ((REGION_ACTIVE)) || zle set-mark-command
  zle backward-char
}
zle -N shift-left

shift-right() {
  ((REGION_ACTIVE)) || zle set-mark-command
  zle forward-char
}
zle -N shift-right

shift-up() {
  ((REGION_ACTIVE)) || zle set-mark-command
  zle up-line-or-history
}
zle -N shift-up

shift-down() {
  ((REGION_ACTIVE)) || zle set-mark-command
  zle down-line-or-history
}
zle -N shift-down

# Shift+Option pour sélectionner par mot
shift-left-word() {
  ((REGION_ACTIVE)) || zle set-mark-command
  zle backward-word
}
zle -N shift-left-word

shift-right-word() {
  ((REGION_ACTIVE)) || zle set-mark-command
  zle forward-word
}
zle -N shift-right-word

# Bindings Shift+flèches (séquences xterm/iTerm2/Terminal.app)
bindkey '^[[1;2D' shift-left       # Shift+Left
bindkey '^[[1;2C' shift-right      # Shift+Right
bindkey '^[[1;2A' shift-up         # Shift+Up
bindkey '^[[1;2B' shift-down       # Shift+Down

# Shift+Option+flèches (sélection par mot)
bindkey '^[[1;4D' shift-left-word  # Shift+Option+Left
bindkey '^[[1;4C' shift-right-word # Shift+Option+Right

# Désactiver la sélection si on tape autre chose
deselect() {
  REGION_ACTIVE=0
  zle "$@"
}
for widget in self-insert backward-delete-char delete-char kill-word backward-kill-word; do
  eval "deselect-$widget() { deselect $widget; }"
  zle -N "deselect-$widget"
done

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
# (zsh-autosuggestions mappe souvent → tout seul, mais pas toujours)
# Better history behavior
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt APPEND_HISTORY
export HISTSIZE=20000
export SAVEHIST=20000
export HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"

# --------------------
# ZSH-bootstrap
# > zboot
# > exec zsh
# --------------------
zsh-bootstrap() {
  set -euo pipefail

  local plugin_root="${HOME}/.zsh/plugins"
  local antidote_dir="${plugin_root}/antidote"
  local plugin_list="${HOME}/.zsh_plugins.txt"

  echo "==> Bootstrapping Zsh environment"

  # 0) Synology: check opkg (Entware)
  if [[ -f /etc/synoinfo.conf ]] && ! command -v opkg >/dev/null; then
    echo "ERROR: opkg (Entware) not found on Synology."
    echo "Install Entware first:"
    echo "  wget -O - https://bin.entware.net/armv8sf-k3.2/installer/generic.sh | /bin/sh"
    echo "(adjust URL for your arch: armv8sf-k3.2, x64-k3.2, etc.)"
    return 1
  fi

  # 1) Antidote
  if [[ ! -f "${antidote_dir}/antidote.zsh" ]]; then
    if ! command -v git >/dev/null; then
      echo "ERROR: git not found. Install git first (brew/opkg) then re-run."
      return 1
    fi
    mkdir -p "${plugin_root}"
    echo "==> Installing antidote into ${antidote_dir}"
    git clone --depth=1 https://github.com/mattmc3/antidote.git "${antidote_dir}"
  else
    echo "==> antidote already installed"
  fi

  # 2) Plugin list (create if missing)
  if [[ ! -f "${plugin_list}" ]]; then
    echo "==> Creating ${plugin_list}"
    cat > "${plugin_list}" <<'EOF'
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
EOF
  else
    echo "==> ${plugin_list} already exists"
  fi

  # 3) Build bundle (optional but nice)
  if [[ -f "${antidote_dir}/antidote.zsh" ]]; then
    source "${antidote_dir}/antidote.zsh"
    echo "==> Building plugin bundle (this speeds up shell startup)"
    antidote bundle < "${plugin_list}" > "${HOME}/.zsh_plugins.zsh"
  fi

  # 4) Check optional tools
  echo
  if ! command -v starship >/dev/null; then
    echo "NOTE: starship not found"
    if [[ -f /etc/synoinfo.conf ]]; then
      echo "  curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b /opt/usr/bin"
    else
      echo "  brew install starship"
    fi
  fi
  if ! command -v eza >/dev/null; then
    echo "NOTE: eza not found"
    if [[ -f /etc/synoinfo.conf ]]; then
      echo "  opkg install eza"
    else
      echo "  brew install eza"
    fi
  fi
  echo
  echo "==> Done. Run: exec zsh"
}
alias zboot='zsh-bootstrap'

# --------------------
# fzf (fuzzy finder)
# --------------------
if _has fzf; then
  # fzf 0.48+ has --zsh, older versions use separate scripts
  if fzf --zsh &>/dev/null; then
    source <(fzf --zsh)
  elif [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
  elif [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
  fi
fi

# --------------------
# Prompt - GARDER A LA FIN DU FICHIER
# --------------------
if _has starship; then
  eval "$(starship init zsh)"
fi

unset _os
