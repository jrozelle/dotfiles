# Dotfiles

Configuration portable pour macOS et Synology (Entware).

## Contenu

| Fichier | Description |
|---------|-------------|
| `.zshrc` | Configuration zsh (aliases, completion, plugins) |
| `.zprofile` | Init Homebrew (login shells) |
| `.gitconfig` | Config git (aliases, rebase, push) |
| `starship.toml` | Prompt starship |
| `Brewfile` | Packages Homebrew |
| `macos.sh` | Defaults macOS (Finder, Dock, clavier) |
| `install.sh` | Script d'installation |

## Installation

### macOS (nouveau Mac)

```bash
# 1. Cloner le repo
git clone https://github.com/jrozelle/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Lancer l'installation (installe Homebrew si absent)
./install.sh

# 3. Appliquer les defaults macOS (optionnel)
./macos.sh

# 4. Relancer le shell
exec zsh
```

Le script `install.sh` :
- Installe Homebrew si absent
- Crée les symlinks vers `~`
- Installe les packages du Brewfile
- Configure antidote (plugins zsh)

### Synology (Entware)

```bash
# 1. Installer Entware si absent
# (adapter l'URL selon l'architecture : armv8sf-k3.2, x64-k3.2, etc.)
wget -O - https://bin.entware.net/x64-k3.2/installer/generic.sh | /bin/sh

# 2. Installer git et zsh
opkg install git zsh

# 3. Cloner le repo
git clone https://github.com/jrozelle/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 4. Créer les symlinks manuellement
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
mkdir -p ~/.config
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml

# 5. Bootstrap (plugins + vérification outils)
zsh
zboot

# 6. Installer starship
curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b /opt/usr/bin

# 7. (Optionnel) eza
opkg install eza
```

## Mise à jour

```bash
cd ~/dotfiles
git pull
exec zsh
```

## Alias utiles

| Alias | Commande |
|-------|----------|
| `l` | `eza -lah --git` |
| `ll` | `eza -lh --git` |
| `gs` | `git status` |
| `gp` | `git push` |
| `gl` | `git pull --rebase` |
| `glog` | `git log --oneline --graph` |
| `zboot` | Bootstrap zsh (plugins) |
| `brewup` | Upgrade Homebrew (macOS) |
