# --------------------
# tmux — auto-attach en SSH
# --------------------
# Si connexion SSH entrante, tmux installé, et pas déjà dans une session :
# → attach à la session "main" ou en crée une nouvelle
if _has tmux && [[ -n "$SSH_CONNECTION" ]] && [[ -z "$TMUX" ]]; then
  tmux attach-session -t main 2>/dev/null || tmux new-session -s main
fi
