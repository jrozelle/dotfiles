# Dotfiles

Configuration portable pour macOS et Synology (Entware).

## Contenu

| Fichier/Dossier | Description |
|-----------------|-------------|
| `.zshrc` | Configuration zsh (aliases, completion, plugins) |
| `.zprofile` | Init Homebrew (login shells) |
| `.gitconfig` | Config git (aliases, rebase, push) |
| `starship.toml` | Prompt starship (Catppuccin Mocha) |
| `nvim/` | Config Neovim (lazy.nvim, LSP, Treesitter) |
| `micro/` | Config Micro (settings, colorscheme) |
| `Brewfile` | Packages Homebrew (macOS) |
| `macos.sh` | Defaults macOS (Finder, Dock, clavier) |
| `install.sh` | Script d'installation automatique |

## Installation

### macOS

```bash
git clone https://github.com/jrozelle/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
exec zsh
```

Le script `install.sh` :
- Installe Homebrew si absent
- Crée les symlinks vers `~` et `~/.config`
- Installe les packages du Brewfile
- Configure antidote (plugins zsh)

### Synology (DSM 7+)

```bash
git clone https://github.com/jrozelle/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
exec zsh
```

Le script `install.sh` sur Synology :
- Installe Entware si absent (avec bind mount persistant)
- Configure `/opt` sur volume (survit aux mises à jour DSM)
- Installe git, zsh, neovim, eza, fzf, micro, starship
- Crée les symlinks
- Configure antidote (plugins zsh)

**Note** : Le script nécessite `sudo` pour les opérations sur `/opt`.

## Mise à jour

```bash
cd ~/dotfiles
git pull
exec zsh
```

## Alias utiles

| Alias | Description |
|-------|-------------|
| `l` | `eza -lah --git` (liste fichiers) |
| `gs` | `git status` |
| `gp` | `git push` |
| `gl` | `git pull --rebase` |
| `glog` | `git log --oneline --graph` |
| `d` | `docker` |
| `dc` | `docker compose` |
| `dps` | Liste containers |
| `brewup` | Upgrade Homebrew (macOS) |

Voir [CHEATSHEET.md](CHEATSHEET.md) pour la liste complète.
