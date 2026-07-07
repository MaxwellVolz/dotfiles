# Maxwell's macOS toolchain — install with: brew bundle --file=Brewfile
# Regenerate with: brew bundle dump --force --file=Brewfile

# ----- Core CLI -----
brew "coreutils"
brew "git"
brew "gh"
brew "pandoc"
brew "ffmpeg"
brew "stow"            # symlinks dotfiles into $HOME (used by install.sh)
brew "tmux"            # terminal multiplexer

# ----- Modern CLI replacements -----
brew "starship"        # prompt
brew "zoxide"          # smart cd
brew "fzf"             # fuzzy finder
brew "eza"             # ls
brew "bat"             # cat
brew "ripgrep"         # grep
brew "fd"              # find

# ----- Zsh plugins (used by zinit, but installed via brew as backup) -----
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# ----- Languages / runtimes -----
brew "node", link: false
brew "node@22", link: true
brew "python@3.13"
brew "uv"              # python package manager

# ----- Casks -----
cask "ghostty"                          # terminal
cask "font-jetbrains-mono-nerd-font"    # nerd font for starship glyphs
cask "localsend"
cask "ngrok"

# ----- VSCode extensions -----
vscode "anthropic.claude-code"
vscode "kamikillerto.vscode-colorize"
vscode "yzhang.markdown-all-in-one"
