# --------------------
# fzf (fuzzy finder)
# --------------------
if _has fzf; then
  # fzf 0.48+ has --zsh, older versions use separate scripts
  if fzf --zsh &>/dev/null; then
    source <(fzf --zsh)
  elif [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  elif [[ -f /opt/share/fzf/key-bindings.zsh ]]; then
    # Entware (Synology)
    source /opt/share/fzf/key-bindings.zsh
  elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
  elif [[ -f /usr/local/share/fzf/key-bindings.zsh ]]; then
    # Linux: install.sh installs here
    source /usr/local/share/fzf/key-bindings.zsh
  elif [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
  fi

  # Utiliser fd comme source (respecte .gitignore, plus rapide que find)
  if _has fd; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi

  # Options par défaut — Catppuccin Mocha
  export FZF_DEFAULT_OPTS="
    --height 40% --layout=reverse --border --info=inline
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
fi
