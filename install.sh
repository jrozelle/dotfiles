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
  # Detect architecture
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)  ENTWARE_ARCH="x64-k3.2" ;;
    aarch64) ENTWARE_ARCH="aarch64-k3.10" ;;
    armv7l)  ENTWARE_ARCH="armv7sf-k3.2" ;;
    *)       ENTWARE_ARCH="x64-k3.2" ;;
  esac

  # Find existing Entware (check common Synology locations)
  ENTWARE_ROOT=""
  for d in /opt /volume1/@entware-ng/opt /volume1/@Entware/opt; do
    if [[ -x "$d/bin/opkg" ]]; then
      ENTWARE_ROOT="$d"
      break
    fi
  done

  if [[ -z "$ENTWARE_ROOT" ]]; then
    echo "Entware not found. Installing..."
    ENTWARE_ROOT="/volume1/@Entware/opt"
    sudo mkdir -p "$ENTWARE_ROOT"

    # Entware installer hardcodes /opt as target.
    # Temporarily bind-mount so it writes to the volume.
    # (We unmount after — a persistent bind mount would hide Docker's
    # /opt/containerd and other Synology package data.)
    sudo mkdir -p /opt
    if ! grep -q "$ENTWARE_ROOT /opt " /proc/mounts 2>/dev/null; then
      sudo mount -o bind "$ENTWARE_ROOT" /opt
    fi

    echo "Downloading Entware installer for $ARCH..."
    curl -fsSL "https://bin.entware.net/${ENTWARE_ARCH}/installer/generic.sh" -o /tmp/entware.sh
    sudo /bin/sh /tmp/entware.sh
    rm -f /tmp/entware.sh

    # Remove temporary bind mount
    sudo umount /opt 2>/dev/null || true
  fi

  echo "Entware found at $ENTWARE_ROOT"

  # If Entware lives outside /opt, create symlinks so hardcoded /opt paths
  # (shebangs like #!/opt/bin/sh, library rpaths, etc.) still resolve.
  # Symlinks coexist with Docker's /opt/containerd — unlike a bind mount
  # which would hide it.
  if [[ "$ENTWARE_ROOT" != "/opt" ]]; then
    for d in bin etc lib libexec sbin share; do
      if [[ -d "$ENTWARE_ROOT/$d" ]] && [[ ! -e "/opt/$d" ]]; then
        sudo ln -s "$ENTWARE_ROOT/$d" "/opt/$d" 2>/dev/null || true
      fi
    done
  fi

  # Add Entware to PATH for this session
  export PATH="$ENTWARE_ROOT/bin:$ENTWARE_ROOT/sbin:$PATH"

  # Update package list
  echo "Updating opkg package list..."
  sudo "$ENTWARE_ROOT/bin/opkg" update

  # Ensure essentials are available
  command -v git >/dev/null  || { echo "Installing git...";    sudo "$ENTWARE_ROOT/bin/opkg" install git; }
  command -v zsh >/dev/null  || { echo "Installing zsh...";    sudo "$ENTWARE_ROOT/bin/opkg" install zsh; }
  command -v nvim >/dev/null || { echo "Installing neovim..."; sudo "$ENTWARE_ROOT/bin/opkg" install neovim; }
  command -v eza >/dev/null  || { echo "Installing eza...";    sudo "$ENTWARE_ROOT/bin/opkg" install eza; }
  command -v fzf >/dev/null  || { echo "Installing fzf...";    sudo "$ENTWARE_ROOT/bin/opkg" install fzf; }
  command -v htop >/dev/null || { echo "Installing htop...";   sudo "$ENTWARE_ROOT/bin/opkg" install htop; }
  command -v tmux >/dev/null || { echo "Installing tmux...";   sudo "$ENTWARE_ROOT/bin/opkg" install tmux; }
  command -v ncdu >/dev/null || { echo "Installing ncdu...";   sudo "$ENTWARE_ROOT/bin/opkg" install ncdu; }
  # tldr n'est pas dans opkg — tealdeer (client Rust musl) installé plus bas

  # micro (not in opkg, install from GitHub)
  if ! command -v micro >/dev/null; then
    echo "Installing micro..."
    (cd /tmp && curl -fsSL https://getmic.ro | bash)
    sudo cp -f /tmp/micro "$ENTWARE_ROOT/bin/micro"
    sudo chmod 755 "$ENTWARE_ROOT/bin/micro"
    rm -f /tmp/micro
  fi

  # fzf shell integration (opkg version may not include it)
  if [[ ! -f "$ENTWARE_ROOT/share/fzf/key-bindings.zsh" ]]; then
    echo "Installing fzf shell integration..."
    sudo mkdir -p "$ENTWARE_ROOT/share/fzf"
    sudo curl -fsSL https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh -o "$ENTWARE_ROOT/share/fzf/key-bindings.zsh"
  fi

  # starship (not in opkg, install from official script)
  if ! command -v starship >/dev/null; then
    echo "Installing starship..."
    curl -fsSL https://starship.rs/install.sh | sudo sh -s -- -y -b "$ENTWARE_ROOT/bin"
  fi

  # zoxide (smart cd — not in opkg, install from official script)
  if ! command -v zoxide >/dev/null; then
    echo "Installing zoxide..."
    curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh \
      | BIN_DIR="$ENTWARE_ROOT/bin" bash
  fi

  # delta (better git diff — GitHub releases, not in opkg)
  if ! command -v delta >/dev/null; then
    echo "Installing delta..."
    DELTA_VER=$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest \
      | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": "\(.*\)".*/\1/')
    case "$ARCH" in
      x86_64)  DELTA_ARCH="x86_64-unknown-linux-musl" ;;
      aarch64) DELTA_ARCH="aarch64-unknown-linux-gnu" ;;
      *)       DELTA_ARCH="" ;;
    esac
    if [[ -n "$DELTA_ARCH" && -n "$DELTA_VER" ]]; then
      curl -fsSL "https://github.com/dandavison/delta/releases/download/${DELTA_VER}/delta-${DELTA_VER}-${DELTA_ARCH}.tar.gz" \
        | tar xz -C /tmp
      sudo cp -f "/tmp/delta-${DELTA_VER}-${DELTA_ARCH}/delta" "$ENTWARE_ROOT/bin/delta"
      sudo chmod 755 "$ENTWARE_ROOT/bin/delta"
      rm -rf "/tmp/delta-${DELTA_VER}-${DELTA_ARCH}"
    fi
  fi

  # bat (syntax highlighting — GitHub releases, not in opkg)
  if ! command -v bat >/dev/null; then
    echo "Installing bat..."
    BAT_VER=$(curl -fsSL https://api.github.com/repos/sharkdp/bat/releases/latest \
      | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": "v\(.*\)".*/\1/')
    case "$ARCH" in
      x86_64)  BAT_ARCH="x86_64-unknown-linux-musl" ;;
      aarch64) BAT_ARCH="aarch64-unknown-linux-musl" ;;
      armv7l)  BAT_ARCH="arm-unknown-linux-musleabihf" ;;
      *)       BAT_ARCH="" ;;
    esac
    if [[ -n "$BAT_ARCH" && -n "$BAT_VER" ]]; then
      curl -fsSL "https://github.com/sharkdp/bat/releases/download/v${BAT_VER}/bat-v${BAT_VER}-${BAT_ARCH}.tar.gz" \
        | tar xz -C /tmp
      sudo cp -f "/tmp/bat-v${BAT_VER}-${BAT_ARCH}/bat" "$ENTWARE_ROOT/bin/bat"
      sudo chmod 755 "$ENTWARE_ROOT/bin/bat"
      rm -rf "/tmp/bat-v${BAT_VER}-${BAT_ARCH}"
    fi
  fi

  # gh (GitHub CLI — GitHub releases, not in opkg)
  if ! command -v gh >/dev/null; then
    echo "Installing gh (GitHub CLI)..."
    GH_VER=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest \
      | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": "v\(.*\)".*/\1/')
    case "$ARCH" in
      x86_64)  GH_ARCH="linux_amd64" ;;
      aarch64) GH_ARCH="linux_arm64" ;;
      armv7l)  GH_ARCH="linux_armv6" ;;
      *)       GH_ARCH="" ;;
    esac
    if [[ -n "$GH_ARCH" && -n "$GH_VER" ]]; then
      curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VER}/gh_${GH_VER}_${GH_ARCH}.tar.gz" \
        | tar xz -C /tmp
      sudo cp -f "/tmp/gh_${GH_VER}_${GH_ARCH}/bin/gh" "$ENTWARE_ROOT/bin/gh"
      sudo chmod 755 "$ENTWARE_ROOT/bin/gh"
      rm -rf "/tmp/gh_${GH_VER}_${GH_ARCH}"
    fi
  fi

  # yq (YAML processor — single static binary)
  if ! command -v yq >/dev/null; then
    echo "Installing yq..."
    case "$ARCH" in
      x86_64)  YQ_ARCH="linux_amd64" ;;
      aarch64) YQ_ARCH="linux_arm64" ;;
      armv7l)  YQ_ARCH="linux_arm" ;;
      *)       YQ_ARCH="" ;;
    esac
    if [[ -n "$YQ_ARCH" ]]; then
      sudo curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_${YQ_ARCH}" \
        -o "$ENTWARE_ROOT/bin/yq"
      sudo chmod 755 "$ENTWARE_ROOT/bin/yq"
    fi
  fi

  # tldr via tealdeer (client Rust musl — opkg ne l'a pas)
  if ! tldr --version >/dev/null 2>&1; then
    echo "Installing tealdeer (tldr)..."
    case "$ARCH" in
      x86_64)  TLDR_ARCH="x86_64-musl" ;;
      aarch64) TLDR_ARCH="aarch64-musl" ;;
      armv7l)  TLDR_ARCH="arm-musleabihf" ;;
      *)       TLDR_ARCH="" ;;
    esac
    if [[ -n "$TLDR_ARCH" ]]; then
      sudo curl -fsSL "https://github.com/dbrgn/tealdeer/releases/latest/download/tealdeer-linux-${TLDR_ARCH}" \
        -o "$ENTWARE_ROOT/bin/tldr"
      sudo chmod 755 "$ENTWARE_ROOT/bin/tldr"
      tldr --update >/dev/null 2>&1 || true
    fi
  fi

  # _gh_dl_url OWNER/REPO GREP_PATTERN
  # Récupère le browser_download_url depuis l'API GitHub (|| true = safe avec set -e)
  _gh_dl_url() {
    curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
      | grep '"browser_download_url"' | grep "$2" | head -1 \
      | sed 's/.*"browser_download_url": *"\([^"]*\)".*/\1/' || true
  }

  # duf (df moderne)
  if ! duf --version >/dev/null 2>&1; then
    echo "Installing duf..."
    case "$ARCH" in
      x86_64)  _pat="linux_amd64.tar.gz" ;;
      aarch64) _pat="linux_arm64.tar.gz" ;;
      armv7l)  _pat="linux_armv7.tar.gz" ;;
      *)       _pat="" ;;
    esac
    if [[ -n "$_pat" ]]; then
      _url=$(_gh_dl_url muesli/duf "$_pat")
      if [[ -n "$_url" ]]; then
        mkdir -p /tmp/duf-install
        curl -fsSL "$_url" | tar xz -C /tmp/duf-install
        sudo cp -f /tmp/duf-install/duf "$ENTWARE_ROOT/bin/duf"
        sudo chmod 755 "$ENTWARE_ROOT/bin/duf"
        rm -rf /tmp/duf-install
      fi
    fi
  fi

  # glow (markdown viewer)
  if ! glow --version >/dev/null 2>&1; then
    echo "Installing glow..."
    case "$ARCH" in
      x86_64)  _pat="Linux_x86_64.tar.gz" ;;
      aarch64) _pat="Linux_arm64.tar.gz"  ;;
      armv7l)  _pat="Linux_armv7.tar.gz"  ;;
      *)       _pat="" ;;
    esac
    if [[ -n "$_pat" ]]; then
      _url=$(_gh_dl_url charmbracelet/glow "$_pat")
      if [[ -n "$_url" ]]; then
        mkdir -p /tmp/glow-install
        curl -fsSL "$_url" | tar xz -C /tmp/glow-install
        sudo cp -f /tmp/glow-install/glow "$ENTWARE_ROOT/bin/glow"
        sudo chmod 755 "$ENTWARE_ROOT/bin/glow"
        rm -rf /tmp/glow-install
      fi
    fi
  fi

  # sd (sed moderne — musl static)
  if ! sd --version >/dev/null 2>&1; then
    echo "Installing sd..."
    case "$ARCH" in
      x86_64)  _pat="x86_64-unknown-linux-musl.tar.gz" ;;
      aarch64) _pat="aarch64-unknown-linux-musl.tar.gz" ;;
      *)       _pat="" ;;
    esac
    if [[ -n "$_pat" ]]; then
      _url=$(_gh_dl_url chmln/sd "$_pat")
      if [[ -n "$_url" ]]; then
        mkdir -p /tmp/sd-install
        curl -fsSL "$_url" | tar xz -C /tmp/sd-install
        # binaire peut être à la racine ou dans un sous-répertoire
        _sd_bin=$(find /tmp/sd-install -name sd -type f | head -1)
        if [[ -n "$_sd_bin" ]]; then
          sudo cp -f "$_sd_bin" "$ENTWARE_ROOT/bin/sd"
          sudo chmod 755 "$ENTWARE_ROOT/bin/sd"
        fi
        rm -rf /tmp/sd-install
      fi
    fi
  fi

  # procs (ps moderne — zip)
  if ! procs --version >/dev/null 2>&1; then
    echo "Installing procs..."
    case "$ARCH" in
      x86_64)  _pat="x86_64-linux.zip" ;;
      aarch64) _pat="aarch64-linux.zip" ;;
      *)       _pat="" ;;
    esac
    if [[ -n "$_pat" ]]; then
      _url=$(_gh_dl_url dalance/procs "$_pat")
      if [[ -n "$_url" ]]; then
        curl -fsSL "$_url" -o /tmp/procs.zip
        unzip -q -o /tmp/procs.zip procs -d /tmp
        sudo cp -f /tmp/procs "$ENTWARE_ROOT/bin/procs"
        sudo chmod 755 "$ENTWARE_ROOT/bin/procs"
        rm -f /tmp/procs.zip /tmp/procs
      fi
    fi
  fi

  unset -f _gh_dl_url
  unset _pat _url _sd_bin

  # Ensure all manually-installed binaries are executable (idempotent — fixes
  # previous runs where cp was done without chmod, or where chmod was skipped)
  for _bin in bat delta gh tldr duf glow sd procs; do
    [[ -f "$ENTWARE_ROOT/bin/$_bin" ]] && sudo chmod 755 "$ENTWARE_ROOT/bin/$_bin"
  done
  unset _bin
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
  .gitignore_global
)

# Directories to symlink to $HOME
HOME_DIRS=(
  .zshrc.d
)

# Files to symlink to $HOME/.config
CONFIG_FILES=(
  starship.toml
)

link_file() {
  local src="$1"
  local dst="$2"

  # Resolve real paths to avoid circular symlinks
  local real_src real_dst_dir
  real_src="$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"
  real_dst_dir="$(cd "$(dirname "$dst")" 2>/dev/null && pwd)"

  # Skip if destination would be inside source (circular symlink)
  if [[ "$real_dst_dir" == "$(dirname "$real_src")"* ]]; then
    echo "Skipping $dst (already in dotfiles)"
    return
  fi

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

# Home directory symlinks (directories)
for dir in "${HOME_DIRS[@]}"; do
  [[ -d "$DOTFILES/$dir" ]] && link_file "$DOTFILES/$dir" "$HOME/$dir"
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
# Skip if ~/.config/micro already points to dotfiles/micro (whole dir symlinked)
if [[ -d "$DOTFILES/micro" ]]; then
  if [[ -L "$HOME/.config/micro" && "$(readlink "$HOME/.config/micro")" == "$DOTFILES/micro" ]]; then
    echo "Skipping micro (already symlinked as directory)"
  else
    mkdir -p "$HOME/.config/micro/colorschemes"
    [[ -f "$DOTFILES/micro/settings.json" ]] && link_file "$DOTFILES/micro/settings.json" "$HOME/.config/micro/settings.json"
    [[ -f "$DOTFILES/micro/colorschemes/catppuccin-mocha.micro" ]] && link_file "$DOTFILES/micro/colorschemes/catppuccin-mocha.micro" "$HOME/.config/micro/colorschemes/catppuccin-mocha.micro"
  fi
fi

# Install packages from Brewfile (macOS only)
if $IS_MAC && command -v brew >/dev/null; then
  if [[ -f "$DOTFILES/Brewfile" ]]; then
    echo "==> Installing packages from Brewfile"
    brew bundle --file="$DOTFILES/Brewfile"
  fi
fi

# --------------------
# Themes: Catppuccin Mocha
# --------------------

# bat — thème Catppuccin Mocha (aussi utilisé par delta via syntect)
if bat --version >/dev/null 2>&1; then
  BAT_THEMES_DIR="$(bat --config-dir)/themes"
  if [[ ! -f "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme" ]]; then
    echo "==> Installing Catppuccin Mocha theme for bat"
    mkdir -p "$BAT_THEMES_DIR"
    curl -fsSL "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme" \
      -o "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme"
    bat cache --build
  fi
fi

# delta — couleurs Catppuccin Mocha (téléchargé depuis catppuccin/delta)
DELTA_CONF_DIR="$HOME/.config/delta"
if [[ ! -f "$DELTA_CONF_DIR/catppuccin.gitconfig" ]]; then
  echo "==> Installing Catppuccin theme for delta"
  mkdir -p "$DELTA_CONF_DIR"
  curl -fsSL "https://raw.githubusercontent.com/catppuccin/delta/main/catppuccin.gitconfig" \
    -o "$DELTA_CONF_DIR/catppuccin.gitconfig"
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

# Note: plugin bundle will be built automatically on first zsh launch
# (antidote.zsh requires zsh, can't be sourced from bash)


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
