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
  elif [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
  fi
fi
