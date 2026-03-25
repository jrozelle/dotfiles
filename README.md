# Dotfiles

Configuration portable pour macOS, Linux et Synology (Entware).

Un seul script d'installation détecte la plateforme et configure l'environnement complet : shell, éditeur, outils CLI modernes et thème unifié [Catppuccin Mocha](https://github.com/catppuccin/catppuccin).

## Fonctionnalités

- **Cross-platform** — macOS (Homebrew), Synology DSM 7+ (Entware), Linux (apt / dnf / pacman / zypper)
- **Outils modernes** — remplaçants plus rapides et ergonomiques aux utilitaires Unix classiques
- **Thème cohérent** — Catppuccin Mocha sur le prompt, fzf, bat, delta et Neovim
- **zsh modulaire** — configuration découpée en fichiers thématiques dans `.zshrc.d/`
- **Neovim complet** — lazy.nvim, LSP, Treesitter, Telescope, Which-key
- **tmux** — multiplexeur configuré avec navigation intuitive et auto-attach SSH
- **Git amélioré** — delta pour les diffs, lazygit en TUI, aliases pratiques

## Outils inclus

| Outil | Remplace | Rôle |
|-------|----------|------|
| [eza](https://github.com/eza-community/eza) | `ls` | Liste de fichiers avec icônes et intégration git |
| [bat](https://github.com/sharkdp/bat) | `cat` | Affichage avec coloration syntaxique |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` | Recherche regex ultra-rapide |
| [fd](https://github.com/sharkdp/fd) | `find` | Recherche de fichiers intuitive |
| [fzf](https://github.com/junegunn/fzf) | — | Fuzzy finder interactif |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` | Navigation intelligente avec apprentissage |
| [delta](https://github.com/dandavison/delta) | `diff` | Diffs git avec coloration et numéros de ligne |
| [lazygit](https://github.com/jesseduffield/lazygit) | — | Interface TUI pour git |
| [duf](https://github.com/muesli/duf) | `df` | Utilisation disque lisible |
| [btop](https://github.com/aristocratseffect/btop) | `top` | Moniteur système interactif |
| [glow](https://github.com/charmbracelet/glow) | — | Lecture de Markdown dans le terminal |
| [tldr](https://github.com/dbrgn/tealdeer) | `man` | Pages de man simplifiées |

## Contenu

| Fichier / Dossier | Description |
|-------------------|-------------|
| `.zshrc` | Configuration zsh principale |
| `.zshrc.d/` | Modules zsh (aliases, fonctions, bindings, historique, fzf, zoxide, tmux, prompt) |
| `.zprofile` | Init Homebrew (login shells macOS) |
| `.gitconfig` | Config git (aliases, delta, rebase, push) |
| `.tmux.conf` | Configuration tmux (mouse, navigation, vi-mode) |
| `starship.toml` | Prompt Starship (Catppuccin Mocha, Nerd Fonts) |
| `nvim/` | Config Neovim (lazy.nvim, LSP, Treesitter) |
| `micro/` | Config Micro (settings, colorscheme) |
| `Brewfile` | Packages Homebrew (macOS) |
| `macos.sh` | Defaults macOS (Finder, Dock, clavier) |
| `install.sh` | Script d'installation automatique |

## Prérequis

- `bash`, `curl`, `git`
- **Synology** : accès `sudo` pour les opérations sur `/opt`
- **Prompt** : une police [Nerd Font](https://www.nerdfonts.com/) dans le terminal (ex. JetBrainsMono Nerd Font)

## Installation

La commande est identique sur toutes les plateformes :

```bash
git clone https://github.com/jrozelle/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
exec zsh
```

### macOS

Le script `install.sh` :
- Installe Homebrew si absent
- Installe les packages du `Brewfile`
- Crée les symlinks vers `~` et `~/.config`
- Configure antidote (gestionnaire de plugins zsh)
- Applique les thèmes Catppuccin (bat, delta)

### Synology (DSM 7+)

Le script `install.sh` :
- Installe Entware si absent (avec bind mount persistant sur `/opt`)
- Installe git, zsh, neovim, eza, fzf, micro, starship via opkg
- Télécharge les binaires manquants depuis GitHub (delta, yq, tealdeer…)
- Crée les symlinks
- Configure antidote

> Le bind mount `/opt` survit aux mises à jour DSM.

### Linux (apt / dnf / pacman / zypper)

Le script `install.sh` détecte le gestionnaire de paquets et :
- Installe les outils core via le gestionnaire système
- Télécharge Neovim et les outils modernes depuis GitHub (versions récentes)
- Crée les symlinks
- Configure antidote

## Post-installation

Créer `~/.gitconfig.local` pour y mettre ton identité git (non versionnée) :

```ini
[user]
    name = Prénom Nom
    email = adresse@exemple.com
```

## Mise à jour

```bash
cd ~/dotfiles
git pull
exec zsh
```

## Alias utiles

### Shell & navigation

| Alias | Commande | Description |
|-------|----------|-------------|
| `l` | `eza -lah --git` | Liste fichiers (détaillée) |
| `lt` | `eza --tree` | Arborescence |
| `z <dossier>` | `zoxide` | Aller dans un dossier fréquent |

### Git

| Alias | Commande | Description |
|-------|----------|-------------|
| `gs` | `git status` | Statut |
| `gp` | `git push` | Push |
| `gl` | `git pull --rebase` | Pull avec rebase |
| `glog` | `git log --oneline --graph` | Historique visuel |
| `lg` | `lazygit` | Interface TUI git |

### Docker

| Alias | Commande | Description |
|-------|----------|-------------|
| `d` | `docker` | Raccourci docker |
| `dc` | `docker compose` | Raccourci compose |
| `dps` | — | Liste les containers actifs |
| `dlog` | — | Logs d'un container |
| `dsh` | — | Shell dans un container |

### macOS

| Alias | Description |
|-------|-------------|
| `brewup` | Mise à jour Homebrew complète |

Voir [CHEATSHEET.md](CHEATSHEET.md) pour la liste complète.
