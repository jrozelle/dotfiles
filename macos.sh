#!/bin/bash
# macos.sh — Configuration macOS personnalisée
# À exécuter une fois sur un nouveau Mac

echo "Configuration macOS..."

# =============================================================================
# FINDER
# =============================================================================

# Afficher les extensions de fichiers
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Barre de chemin en bas
defaults write com.apple.finder ShowPathbar -bool true

# Barre de statut
defaults write com.apple.finder ShowStatusBar -bool true

# Vue colonnes par défaut
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Recherche dans le dossier courant par défaut
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Pas de .DS_Store sur les volumes réseau et USB
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# =============================================================================
# DOCK
# =============================================================================

# Masquer automatiquement
defaults write com.apple.dock autohide -bool true

# Pas de délai au survol
defaults write com.apple.dock autohide-delay -float 0

# Animation rapide
defaults write com.apple.dock autohide-time-modifier -float 0.3

# Pas d'apps récentes dans le Dock
defaults write com.apple.dock show-recents -bool false

# =============================================================================
# SCREENSHOTS
# =============================================================================

# Emplacement : Bureau
defaults write com.apple.screencapture location ~/Desktop

# Format PNG
defaults write com.apple.screencapture type -string "png"

# Pas d'ombre sur les captures de fenêtre
defaults write com.apple.screencapture disable-shadow -bool true

# =============================================================================
# CLAVIER
# =============================================================================

# Répétition touche rapide
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Désactiver correction automatique
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Désactiver capitalisation automatique
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Désactiver le point double-espace
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# =============================================================================
# DIALOGUES
# =============================================================================

# Expand save dialog par défaut
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print dialog par défaut
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# =============================================================================
# SECURITE
# =============================================================================

# Mot de passe immédiat après veille/écran de veille
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# =============================================================================
# APPLIQUER LES CHANGEMENTS
# =============================================================================

echo "Redemarrage des apps affectees..."
killall Finder Dock SystemUIServer 2>/dev/null

echo "Configuration terminee !"
echo "Certains changements necessitent un logout/login."
