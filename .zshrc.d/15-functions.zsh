# ====================
# Fonctions utilitaires
# ====================

# mkdir + cd en une commande
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extracteur universel d'archives
extract() {
  if [[ ! -f "$1" ]]; then
    echo "'$1' n'existe pas"
    return 1
  fi
  case "$1" in
    *.tar.bz2) tar xjf "$1"            ;;
    *.tar.gz)  tar xzf "$1"            ;;
    *.tar.xz)  tar xJf "$1"            ;;
    *.tar.zst) tar --zstd -xf "$1"     ;;
    *.tar)     tar xf "$1"             ;;
    *.bz2)     bunzip2 "$1"            ;;
    *.gz)      gunzip "$1"             ;;
    *.zip)     unzip "$1"              ;;
    *.7z)      7z x "$1"               ;;
    *.rar)     unrar x "$1"            ;;
    *)         echo "Format inconnu: $1" ;;
  esac
}

# Backup horodaté avant d'éditer un fichier sensible
bak() { cp -iv "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"; }
