# ====================
# Aliases: navigation
# ====================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'

# Synology
if [[ -f /etc/synoinfo.conf ]]; then
  alias cdd='cd /volume1/docker'
fi

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
  export BAT_THEME="Catppuccin Mocha"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
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

if _has gh; then
  # Completions (générées une seule fois)
  if [[ ! -f ~/.zsh/completions/_gh ]]; then
    mkdir -p ~/.zsh/completions
    gh completion -s zsh > ~/.zsh/completions/_gh
  fi
fi

if _has docker; then
  # Generate docker completions if missing
  if [[ ! -f ~/.zsh/completions/_docker ]] && docker completion zsh &>/dev/null; then
    mkdir -p ~/.zsh/completions
    docker completion zsh > ~/.zsh/completions/_docker
  fi
  alias d='docker'
  alias dc='docker compose'
  alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dlog='docker logs -f --tail=200'
  alias dclog='docker compose logs -f --tail=200'
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
    if [[ -f docker-compose.yaml || -f docker-compose.yml || -f compose.yml ]]; then
      docker compose pull && docker compose up -d
    else
      echo "Pas de docker-compose.yml dans ce dossier"
    fi
  }
fi
