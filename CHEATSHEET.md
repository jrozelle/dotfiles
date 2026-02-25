# Cheatsheet — Les Essentiels

> Ouvrir ce fichier : `md ~/dotfiles/CHEATSHEET.md`

---

## Raccourcis Clavier (Ligne de commande)

### Navigation

| Raccourci | Description |
|-----------|-------------|
| `Ctrl+A` | Début de ligne |
| `Ctrl+E` | Fin de ligne |
| `Ctrl+B` | Reculer d'un caractère |
| `Ctrl+F` | Avancer d'un caractère |
| `Option+←` | Mot précédent |
| `Option+→` | Mot suivant |
| `Home` | Début de ligne |
| `End` | Fin de ligne |

### Suppression

| Raccourci | Description |
|-----------|-------------|
| `Ctrl+D` | Supprimer caractère sous curseur |
| `Fn+Backspace` | Supprimer caractère sous curseur |
| `Ctrl+H` | Supprimer caractère avant (= Backspace) |
| `Ctrl+W` | Supprimer mot avant |
| `Option+Backspace` | Supprimer mot avant (smart) |
| `Ctrl+U` | Supprimer jusqu'au début de ligne |
| `Ctrl+K` | Supprimer jusqu'à la fin de ligne |

### Copier/Coller (kill ring)

| Raccourci | Description |
|-----------|-------------|
| `Ctrl+W` | Couper mot avant (ou sélection) |
| `Ctrl+Y` | Coller (yank) |
| `Ctrl+K` | Couper jusqu'à fin de ligne |
| `Ctrl+U` | Couper jusqu'au début de ligne |

### Historique

| Raccourci | Description |
|-----------|-------------|
| `Ctrl+R` | Recherche fuzzy dans l'historique (fzf) |
| `Ctrl+P` / `↑` | Commande précédente |
| `Ctrl+N` / `↓` | Commande suivante |
| `!!` | Répéter dernière commande |
| `!$` | Dernier argument de la commande précédente |
| `!*` | Tous les arguments de la commande précédente |

### Divers

| Raccourci | Description |
|-----------|-------------|
| `Ctrl+L` | Effacer écran |
| `Ctrl+C` | Annuler commande |
| `Ctrl+Z` | Suspendre processus |
| `Ctrl+D` | Fermer shell (si ligne vide) |
| `Ctrl+_` | Annuler dernière édition |

---

## Navigation Dossiers

| Commande | Description |
|----------|-------------|
| `..` | Remonter d'un niveau |
| `...` | Remonter de 2 niveaux |
| `....` | Remonter de 3 niveaux |
| `~` | Aller au home |

---

## zoxide — Navigation intelligente

> `z` remplace `cd` : il apprend les répertoires visités et saute directement.

| Commande | Description |
|----------|-------------|
| `z foo` | cd vers le répertoire le plus visité contenant "foo" |
| `z foo bar` | Affine avec plusieurs termes |
| `z -` | Répertoire précédent |
| `zi` | Sélection interactive via fzf |
| `z ..` | Remonter d'un niveau (comme cd ..) |

---

## fzf — Fuzzy Finder

| Raccourci | Description |
|-----------|-------------|
| `Ctrl+R` | Recherche dans l'historique |
| `Ctrl+T` | Recherche fichier (insère le chemin) |
| `Alt+C` | cd dans un dossier |

> Dans une fenêtre fzf : `↑↓` pour naviguer, `Enter` pour valider, `Tab` pour sélectionner plusieurs, `Ctrl+C` pour annuler.

---

## Fichiers (eza/ls)

| Alias | Description |
|-------|-------------|
| `l` | Liste détaillée + cachés + statut git |
| `ll` | Liste détaillée + statut git |
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

---

## Fonctions utilitaires

| Commande | Description |
|----------|-------------|
| `mkcd <dossier>` | Crée un dossier et s'y déplace |
| `extract <archive>` | Extrait n'importe quelle archive (tar, zip, gz, 7z…) |
| `bak <fichier>` | Copie horodatée avant de modifier un fichier sensible |
| `myip` | Affiche l'IP publique |
| `pingg` | Ping 1.1.1.1 (5 paquets) |
| `ports` | Liste les ports en écoute |
| `md <fichier.md>` | Affiche un fichier Markdown dans le terminal (glow) |
| `df` | Espace disque par partition (duf) |

---

## Recherche

| Alias | Description |
|-------|-------------|
| `g` | grep avec numéros de ligne + couleurs |
| `rg` | ripgrep smart-case |
| `find` | fd (si installé — respecte .gitignore) |
| `cat` | bat avec coloration syntaxique (si installé) |
| `less` | bat (si installé) |

---

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

---

## Docker

| Alias | Description |
|-------|-------------|
| `d` | docker |
| `dc` | docker compose |
| `dps` | Liste containers actifs (nom, statut, ports) |
| `dpsa` | Liste tous les containers |
| `dlog <nom>` | Logs container en temps réel (200 lignes) |
| `dclog` | Logs docker compose en temps réel |
| `dexec <nom>` | Exec interactif dans un container |
| `dstats` | Stats CPU/RAM/Network temps réel |
| `dsh <nom>` | Shell dans un container (bash ou sh) |
| `dre <nom>` | Restart + affiche logs |
| `dup` | Pull images + rebuild (dans dossier compose) |
| `dclean` | Nettoyer containers/images/volumes orphelins |
| `ddf` | Espace disque Docker détaillé |

---

## tmux

> Préfixe par défaut : `Ctrl+B`

### Sessions

| Commande | Description |
|----------|-------------|
| `tmux` | Nouvelle session |
| `tmux new -s <nom>` | Nouvelle session nommée |
| `tmux ls` | Lister les sessions |
| `tmux attach` | Rattacher la dernière session |
| `tmux attach -t <nom>` | Rattacher une session nommée |
| `Préfixe + d` | Detach (session reste active) |
| `Préfixe + $` | Renommer la session |
| `Préfixe + s` | Choisir session (interactif) |

### Fenêtres (onglets)

| Raccourci | Description |
|-----------|-------------|
| `Préfixe + c` | Nouvelle fenêtre |
| `Préfixe + ,` | Renommer fenêtre |
| `Préfixe + n/p` | Fenêtre suivante/précédente |
| `Préfixe + 1-9` | Aller à la fenêtre n |
| `Préfixe + &` | Fermer fenêtre |
| `Préfixe + w` | Liste fenêtres (interactif) |

### Panes (splits)

| Raccourci | Description |
|-----------|-------------|
| `Préfixe + \|` | Split vertical |
| `Préfixe + -` | Split horizontal |
| `Alt+←↑↓→` | Changer de pane (sans préfixe) |
| `Préfixe + z` | Zoom/dézoom pane actuel |
| `Préfixe + x` | Fermer pane |
| `Préfixe + {/}` | Déplacer pane gauche/droite |
| `Préfixe + Espace` | Changer disposition |

### Scroll & Copie

| Raccourci | Description |
|-----------|-------------|
| Scroll souris | Entre en mode copie et défile dans le buffer |
| `Préfixe + [` | Entrer en mode copie manuellement |
| `v` | Début de sélection (mode vi) |
| `y` | Copier sélection + quitter mode copie |
| `Ctrl+V` | Sélection rectangulaire |
| `q` / `Esc` | Quitter mode copie |
| `Préfixe + ]` | Coller |

> **Prérequis iTerm2** : le scroll souris ne fonctionne que si "Enable mouse
> reporting" est activé dans `Preferences → Profiles → [profil] → Terminal`.
> Sans ça, la molette envoie des flèches ↑↓ à zsh → navigation dans l'historique.

### Divers

| Raccourci | Description |
|-----------|-------------|
| `Préfixe + r` | Recharger ~/.tmux.conf |
| `Préfixe + t` | Afficher l'heure |
| `Préfixe + ?` | Aide (tous les raccourcis) |

> **SSH** : connexion SSH → attach automatique à la session "main" (ou création).

---

## Réseau / Système

| Commande | Description |
|----------|-------------|
| `myip` | Affiche IP publique |
| `pingg` | Ping 1.1.1.1 (5 paquets) |
| `ports` | Liste ports en écoute |
| `df` | Espace disque (duf) |
| `flushdns` | Vider cache DNS (macOS) |
| `brewup` | Mise à jour Homebrew (macOS) |

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
- **Branche git** + statut (`!` modifié, `+` staged, `?` non-tracké, `⇡` ahead, `⇣` behind)
- **Contexte Docker** (si docker-compose présent)
- **Durée commande** (si > 2s)
- **Heure** (à droite)
- **User@Host** (uniquement en SSH)

---

## Bootstrap

### macOS
```bash
git clone https://github.com/jrozelle/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
exec zsh
```

### Linux (Ubuntu/Debian, Fedora, Arch, openSUSE)
```bash
git clone https://github.com/jrozelle/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
exec zsh
```
*Note : install.sh détecte apt/dnf/pacman/zypper pour les dépendances de base,
puis télécharge tous les outils modernes (bat, eza, delta, starship…) depuis
GitHub releases sous `/usr/local/bin` — aucune dépendance build, fonctionne
sur n'importe quelle distro x86_64/arm64/armv7.*

### Synology
```bash
git clone https://github.com/jrozelle/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
exec zsh
```
*Note : install.sh installe automatiquement Entware si absent.*

### Mise à jour
```bash
cd ~/dotfiles && git pull && exec zsh
```
