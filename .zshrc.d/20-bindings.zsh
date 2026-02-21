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
