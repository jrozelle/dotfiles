#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Files to symlink to $HOME
HOME_FILES=(
  .zshrc
  .gitconfig
)

# Files to symlink to $HOME/.config
CONFIG_FILES=(
  starship.toml
)

link_file() {
  local src="$1"
  local dst="$2"

  if [[ -L "$dst" ]]; then
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    echo "Backing up $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  ln -s "$src" "$dst"
  echo "Linked $dst -> $src"
}

echo "==> Installing dotfiles from $DOTFILES"

# Home directory files
for file in "${HOME_FILES[@]}"; do
  [[ -f "$DOTFILES/$file" ]] && link_file "$DOTFILES/$file" "$HOME/$file"
done

# Config directory files
mkdir -p "$HOME/.config"
for file in "${CONFIG_FILES[@]}"; do
  [[ -f "$DOTFILES/$file" ]] && link_file "$DOTFILES/$file" "$HOME/.config/$file"
done

echo "==> Done. Run: exec zsh"
