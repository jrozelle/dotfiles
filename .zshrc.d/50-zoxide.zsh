# --------------------
# zoxide (smart cd)
# --------------------
# z <query>   → cd vers le répertoire le plus visité correspondant
# zi          → sélection interactive via fzf
# z -         → répertoire précédent
if _has zoxide; then
  eval "$(zoxide init zsh)"
fi
