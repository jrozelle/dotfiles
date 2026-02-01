# Cheatsheet - Les Essentiels

## Navigation Shell

| Commande | Description |
|----------|-------------|
| `..` | Remonter d'un niveau |
| `...` | Remonter de 2 niveaux |
| `....` | Remonter de 3 niveaux |
| `~` | Aller au home |

## Fichiers (eza/ls)

| Alias | Description |
|-------|-------------|
| `l` | Liste détaillée + cachés |
| `ll` | Liste détaillée |
| `la` | Liste avec cachés |
| `lt` | Trié par date (récent en bas) |
| `tree` | Arborescence niveau 2 |
| `tree3` | Arborescence niveau 3 |

## Manipulation fichiers

| Alias | Description |
|-------|-------------|
| `cp` | Copie interactive + verbose |
| `mv` | Déplacement interactif + verbose |
| `rm` | Suppression interactive + verbose |
| `mkdir` | Création récursive + verbose |

## Recherche

| Alias | Description |
|-------|-------------|
| `g` | grep avec numéros de ligne + couleurs |
| `rg` | ripgrep smart-case |
| `find` | fd (si installé) |
| `cat` | bat avec coloration (si installé) |
| `less` | bat (si installé) |

## Git

| Alias | Description |
|-------|-------------|
| `gs` | `git status` |
| `ga` | `git add` |
| `gaa` | `git add -A` |
| `gc` | `git commit` |
| `gcm` | `git commit -m` |
| `gca` | `git commit --amend` |
| `gco` | `git checkout` |
| `gb` | `git branch` |
| `gbd` | `git branch -d` |
| `gl` | `git pull --rebase` |
| `gp` | `git push` |
| `gpf` | `git push --force-with-lease` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `glog` | Log graphique (25 derniers) |
| `lzg` | lazygit (TUI) |

### Git aliases (.gitconfig)

| Alias | Description |
|-------|-------------|
| `git st` | status |
| `git co` | checkout |
| `git br` | branch |
| `git ci` | commit |
| `git ca` | commit --amend |
| `git sw` | switch |
| `git lg` | log graphique |
| `git last` | dernier commit |
| `git undo` | annuler dernier commit (soft) |
| `git unstage` | unstage fichiers |
| `git wip` | commit WIP rapide |

## Docker

| Alias | Description |
|-------|-------------|
| `d` | docker |
| `dc` | docker compose |
| `dps` | Liste containers (format propre) |
| `dlog` | Logs en temps réel (200 lignes) |
| `dexec` | Exec interactif dans container |

## Réseau / Système

| Commande | Description |
|----------|-------------|
| `myip` | Affiche IP publique |
| `pingg` | Ping 1.1.1.1 (5 paquets) |
| `ports` | Liste ports en écoute |
| `flushdns` | Vider cache DNS (macOS) |
| `brewup` | Mise à jour Homebrew (macOS) |

## fzf (Fuzzy Finder)

| Raccourci | Description |
|-----------|-------------|
| `Ctrl+R` | Recherche dans l'historique |
| `Ctrl+T` | Recherche fichier |
| `Alt+C` | cd dans un dossier |

---

## Micro

### Navigation

| Raccourci | Description |
|-----------|-------------|
| `Ctrl+E` | Ligne de commande |
| `Ctrl+G` | Aide |
| `Ctrl+Q` | Quitter |
| `Ctrl+S` | Sauvegarder |
| `Ctrl+O` | Ouvrir fichier |

### Édition

| Raccourci | Description |
|-----------|-------------|
| `Ctrl+Z` | Annuler |
| `Ctrl+Y` | Refaire |
| `Ctrl+K` | Couper ligne |
| `Ctrl+D` | Dupliquer ligne |
| `Ctrl+C` | Copier |
| `Ctrl+V` | Coller |
| `Ctrl+X` | Couper |
| `Tab` | Indenter |
| `Shift+Tab` | Dé-indenter |

### Recherche

| Raccourci | Description |
|-----------|-------------|
| `Ctrl+F` | Rechercher |
| `Ctrl+N` | Suivant |
| `Ctrl+P` | Précédent |
| `Ctrl+H` | Rechercher/Remplacer |

### Multi-curseurs

| Raccourci | Description |
|-----------|-------------|
| `Ctrl+Shift+Up/Down` | Ajouter curseur |
| `Alt+N` | Sélectionner mot suivant identique |
| `Alt+Shift+N` | Sélectionner tous les mots identiques |

### Commandes (Ctrl+E)

```
set colorscheme <nom>   # Changer thème
set tabsize 4           # Taille tabs
vsplit <fichier>        # Split vertical
hsplit <fichier>        # Split horizontal
```

---

## Neovim

### Modes

| Touche | Mode |
|--------|------|
| `i` | Insert |
| `v` | Visual |
| `V` | Visual Line |
| `Ctrl+V` | Visual Block |
| `Esc` | Normal |
| `:` | Command |

### Navigation

| Raccourci | Description |
|-----------|-------------|
| `h j k l` | Gauche, Bas, Haut, Droite |
| `w` | Mot suivant |
| `b` | Mot précédent |
| `0` | Début de ligne |
| `$` | Fin de ligne |
| `gg` | Début du fichier |
| `G` | Fin du fichier |
| `Ctrl+D` | Descendre demi-page |
| `Ctrl+U` | Monter demi-page |
| `Ctrl+h/j/k/l` | Changer de fenêtre |

### Édition

| Raccourci | Description |
|-----------|-------------|
| `dd` | Supprimer ligne |
| `yy` | Copier ligne |
| `p` | Coller après |
| `P` | Coller avant |
| `u` | Annuler |
| `Ctrl+R` | Refaire |
| `ciw` | Changer mot |
| `ci"` | Changer dans guillemets |
| `>>` | Indenter |
| `<<` | Dé-indenter |
| `gc` | Toggle commentaire (visual) |
| `gcc` | Toggle commentaire ligne |

### Recherche

| Raccourci | Description |
|-----------|-------------|
| `/pattern` | Rechercher |
| `n` | Suivant |
| `N` | Précédent |
| `*` | Chercher mot sous curseur |
| `Esc` | Effacer highlight |

### Leader (Space)

| Raccourci | Description |
|-----------|-------------|
| `Space+w` | Sauvegarder |
| `Space+q` | Quitter |
| `Space+Space` | Chercher fichiers |
| `Space+ff` | Chercher fichiers |
| `Space+fg` | Grep dans projet |
| `Space+fb` | Liste buffers |
| `Space+fh` | Aide tags |

### LSP

| Raccourci | Description |
|-----------|-------------|
| `gd` | Aller à la définition |
| `gr` | Références |
| `K` | Documentation hover |
| `Space+rn` | Renommer symbole |
| `Space+ca` | Code action |

### Git (gitsigns)

| Raccourci | Description |
|-----------|-------------|
| `]c` | Hunk suivant |
| `[c` | Hunk précédent |
| `Space+gp` | Preview hunk |
| `Space+gb` | Blame ligne |

### Autocomplétion

| Raccourci | Description |
|-----------|-------------|
| `Tab` | Suggestion suivante |
| `Shift+Tab` | Suggestion précédente |
| `Enter` | Confirmer |
| `Ctrl+Space` | Ouvrir suggestions |
| `Ctrl+E` | Fermer suggestions |

### Commandes utiles

```vim
:w                  " Sauvegarder
:q                  " Quitter
:wq                 " Sauvegarder et quitter
:e <fichier>        " Ouvrir fichier
:vs <fichier>       " Split vertical
:sp <fichier>       " Split horizontal
:Lazy               " Gestionnaire plugins
:Mason              " Gestionnaire LSP
:checkhealth        " Diagnostic nvim
```

---

## Starship Prompt

Le prompt affiche automatiquement :
- **Répertoire** (tronqué à 4 niveaux)
- **Branche git** + statut (!, +, ?, ⇡, ⇣)
- **Contexte Docker** (si docker-compose présent)
- **Durée commande** (si > 2s)
- **Heure** (à droite)
- **User@Host** (uniquement en SSH)

---

## Bootstrap

### macOS (nouveau Mac)
```bash
git clone https://github.com/jrozelle/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
exec zsh
```

### Synology
```bash
# 1. Installer Entware d'abord (si pas fait)
# wget -O - https://bin.entware.net/x64-k3.2/installer/generic.sh | /bin/sh

git clone https://github.com/jrozelle/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
exec zsh
```

### Mise à jour plugins zsh
```bash
zboot
exec zsh
```
