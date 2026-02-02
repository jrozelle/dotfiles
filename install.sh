#!/usr/bin/env bash
set -euo pipefail

# Detect platform
IS_SYNOLOGY=false
IS_MAC=false
if [[ -f /etc/synoinfo.conf ]]; then
  IS_SYNOLOGY=true
elif [[ "$OSTYPE" == darwin* ]]; then
  IS_MAC=true
fi

# Synology: check Entware/opkg
if $IS_SYNOLOGY; then
  if ! command -v opkg >/dev/null; then
    # Detect architecture for Entware URL
    ARCH=$(uname -m)
    case "$ARCH" in
      x86_64)  ENTWARE_ARCH="x64-k3.2" ;;
      aarch64) ENTWARE_ARCH="aarch64-k3.10" ;;
      armv7l)  ENTWARE_ARCH="armv7sf-k3.2" ;;
      *)       ENTWARE_ARCH="x64-k3.2" ;;
    esac
    echo "ERROR: opkg (Entware) not found on Synology."
    echo "Detected architecture: $ARCH"
    echo "Install Entware first:"
    echo "  wget -O - https://bin.entware.net/${ENTWARE_ARCH}/installer/generic.sh | /bin/sh"
    exit 1
  fi
  # Ensure essentials are available
  command -v git >/dev/null || { echo "Installing git..."; opkg install git; }
  command -v zsh >/dev/null || { echo "Installing zsh..."; opkg install zsh; }
  command -v nvim >/dev/null || { echo "Installing neovim..."; opkg install neovim; }

  # micro (not in opkg, install from GitHub)
  if ! command -v micro >/dev/null; then
    echo "Installing micro..."
    cd /tmp
    curl -fsSL https://getmic.ro | bash
    rm -rf /opt/usr/bin/micro
    mv -f /tmp/micro /opt/usr/bin/micro
    cd - >/dev/null
  fi
fi

# macOS: install Homebrew if missing
if $IS_MAC && ! command -v brew >/dev/null; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Files to symlink to $HOME
HOME_FILES=(
  .zprofile
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

# Config directories (nvim, etc.)
CONFIG_DIRS=(
  nvim
)
for dir in "${CONFIG_DIRS[@]}"; do
  [[ -d "$DOTFILES/$dir" ]] && link_file "$DOTFILES/$dir" "$HOME/.config/$dir"
done

# micro: only symlink settings.json and colorschemes (micro needs to write runtime files)
if [[ -d "$DOTFILES/micro" ]]; then
  mkdir -p "$HOME/.config/micro/colorschemes"
  [[ -f "$DOTFILES/micro/settings.json" ]] && link_file "$DOTFILES/micro/settings.json" "$HOME/.config/micro/settings.json"
  [[ -f "$DOTFILES/micro/colorschemes/catppuccin-mocha.micro" ]] && link_file "$DOTFILES/micro/colorschemes/catppuccin-mocha.micro" "$HOME/.config/micro/colorschemes/catppuccin-mocha.micro"
fi

# Install packages from Brewfile (macOS only)
if $IS_MAC && command -v brew >/dev/null; then
  if [[ -f "$DOTFILES/Brewfile" ]]; then
    echo "==> Installing packages from Brewfile"
    brew bundle --file="$DOTFILES/Brewfile"
  fi
fi

# Bootstrap zsh plugins (antidote)
echo "==> Bootstrapping zsh plugins"

PLUGIN_ROOT="$HOME/.zsh/plugins"
ANTIDOTE_DIR="$PLUGIN_ROOT/antidote"
PLUGIN_LIST="$HOME/.zsh_plugins.txt"

if [[ ! -d "$ANTIDOTE_DIR" ]]; then
  if ! command -v git >/dev/null; then
    echo "ERROR: git not found. Install git first."
    exit 1
  fi
  mkdir -p "$PLUGIN_ROOT"
  echo "Installing antidote..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
else
  echo "antidote already installed"
fi

if [[ ! -f "$PLUGIN_LIST" ]]; then
  echo "Creating $PLUGIN_LIST"
  cat > "$PLUGIN_LIST" <<'EOF'
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
EOF
else
  echo "$PLUGIN_LIST already exists"
fi

# Build plugin bundle
if [[ -f "$ANTIDOTE_DIR/antidote.zsh" ]]; then
  echo "Building plugin bundle..."
  source "$ANTIDOTE_DIR/antidote.zsh"
  antidote bundle < "$PLUGIN_LIST" > "$HOME/.zsh_plugins.zsh"
fi

# Check optional tools
echo
if ! command -v starship >/dev/null; then
  if $IS_SYNOLOGY; then
    echo "NOTE: starship not found"
    echo "  curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b /opt/usr/bin"
  else
    echo "NOTE: starship not found (brew install starship)"
  fi
fi
if ! command -v eza >/dev/null; then
  if $IS_SYNOLOGY; then
    echo "NOTE: eza not found (opkg install eza)"
  else
    echo "NOTE: eza not found (brew install eza)"
  fi
fi
if ! command -v nvim >/dev/null; then
  if $IS_SYNOLOGY; then
    echo "NOTE: neovim not found (opkg install neovim)"
  else
    echo "NOTE: neovim not found (brew install neovim)"
  fi
fi

# macOS defaults (optional)
if $IS_MAC && [[ -f "$DOTFILES/macos.sh" ]]; then
  echo
  read -p "Run macos.sh to configure macOS defaults? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    "$DOTFILES/macos.sh"
  fi
fi

echo
echo "==> Done. Run: exec zsh"
