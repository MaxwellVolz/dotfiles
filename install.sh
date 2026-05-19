#!/usr/bin/env bash
# Bootstrap a fresh macOS machine with Maxwell's dotfiles.
# Usage:  ./install.sh           # full bootstrap (idempotent)
#         ./install.sh --link    # just relink stow packages
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_PACKAGES=(zsh git starship claude)

# ----- Colors -----
b() { printf "\033[1m%s\033[0m\n" "$*"; }
ok() { printf "  \033[32m✓\033[0m %s\n" "$*"; }
warn() { printf "  \033[33m!\033[0m %s\n" "$*"; }

step_link_only=false
[[ "${1:-}" == "--link" ]] && step_link_only=true

# ----- 1. Homebrew -----
if ! $step_link_only; then
  b "1. Homebrew"
  if ! command -v brew >/dev/null 2>&1; then
    warn "installing Homebrew (you may be prompted for sudo)…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    ok "brew already installed"
  fi
fi

# ----- 2. Brew bundle -----
if ! $step_link_only; then
  b "2. Brew bundle"
  brew bundle --file="$DOTFILES_DIR/Brewfile"
  ok "brew bundle complete"
fi

# ----- 3. Stow (needed in both modes — symlinking is the whole point of --link) -----
b "3. GNU stow"
if ! command -v stow >/dev/null 2>&1; then
  warn "installing stow…"
  brew install stow
else
  ok "stow already installed"
fi

# ----- 4. Backup conflicting files, then symlink -----
b "4. Linking dotfiles into \$HOME"
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

for pkg in "${STOW_PACKAGES[@]}"; do
  # Find files this package would install, back up any pre-existing real files
  while IFS= read -r -d '' src; do
    rel="${src#$DOTFILES_DIR/$pkg/}"
    target="$HOME/$rel"
    if [[ -e "$target" && ! -L "$target" ]]; then
      mkdir -p "$backup_dir/$(dirname "$rel")"
      mv "$target" "$backup_dir/$rel"
      warn "backed up $target -> $backup_dir/$rel"
    fi
  done < <(find "$DOTFILES_DIR/$pkg" -mindepth 1 -type f -print0)

  stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$pkg"
  ok "linked $pkg"
done

if [[ -z "$(ls -A "$backup_dir")" ]]; then
  rmdir "$backup_dir"
else
  warn "pre-existing files saved to $backup_dir"
fi

# ----- 5. Seed ~/.zshrc.local from example -----
if [[ ! -f "$HOME/.zshrc.local" ]]; then
  cp "$DOTFILES_DIR/zsh/.zshrc.local.example" "$HOME/.zshrc.local"
  ok "seeded ~/.zshrc.local (fill in machine-specific secrets)"
else
  ok "~/.zshrc.local already exists"
fi

# ----- 6. fzf shell integration -----
if [[ ! -f "$HOME/.fzf.zsh" ]] && command -v fzf >/dev/null 2>&1; then
  b "5. fzf shell integration"
  yes | "$(brew --prefix)/opt/fzf/install" --no-bash --no-fish --key-bindings --completion --no-update-rc
  ok "fzf integration installed"
fi

b "Done."
echo
echo "Next steps:"
echo "  1. Open a new terminal (zinit will self-install on first launch)."
echo "  2. Edit ~/.zshrc.local for machine-specific secrets."
echo "  3. Sign in to gh / supabase / flyctl / stripe etc. as needed."
