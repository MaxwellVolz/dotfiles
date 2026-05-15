# =============================================================
# Maxwell's .zshrc — Modern Zsh Setup
# =============================================================

# ----- Homebrew (Apple Silicon) -----
eval "$(/opt/homebrew/bin/brew shellenv)"

# ----- Zinit Plugin Manager -----
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# ----- Plugins -----
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab                    # fzf-powered tab completion

# ----- Completion System (must come AFTER plugins that register completions) -----
autoload -Uz compinit && compinit

# ----- Starship Prompt -----
eval "$(starship init zsh)"

# ----- Zoxide (smart cd) -----
eval "$(zoxide init zsh)"

# ----- fzf (fuzzy finder) -----
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# ----- History Settings -----
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS       # Don't record duplicate commands
setopt HIST_IGNORE_SPACE      # Commands starting with space are not saved
setopt SHARE_HISTORY          # Share history across sessions
setopt HIST_VERIFY            # Show command before executing from history

# ----- Better Defaults -----
setopt AUTO_CD                # Type a dir name to cd into it
setopt CORRECT                # Suggest corrections for mistyped commands
setopt GLOB_DOTS              # Include dotfiles in globs

# ----- Modern CLI Aliases -----
# eza (better ls)
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -lhF --icons --git'
  alias la='eza -lahF --icons --git'
  alias tree='eza --tree --icons'
fi

# bat (better cat)
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias catp='bat'                  # bat with paging
fi

# ripgrep / fd
command -v rg  &>/dev/null && alias grep='rg'
command -v fd  &>/dev/null && alias find='fd'

# ----- Utility Aliases -----
alias zshrc='${EDITOR:-nano} ~/.zshrc && source ~/.zshrc'
alias reload='source ~/.zshrc'
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -pv'
alias df='df -h'
alias du='du -sh'

# ----- Git Aliases -----
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# ----- Editor -----
export EDITOR='nano'       # Change to 'vim', 'nvim', or 'code --wait' as preferred
export VISUAL="$EDITOR"

# ----- PATH Additions -----
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# ----- Auto-suggestions Config -----
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#888888'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ----- Terminal Title (dir + git branch) -----
function set_terminal_title() {
  local dir="${PWD/#$HOME/~}"
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n "$branch" ]]; then
    print -Pn "\e]0;${dir##*/} (${branch})\a"
  else
    print -Pn "\e]0;${dir##*/}\a"
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd set_terminal_title
add-zsh-hook chpwd set_terminal_title

# ----- Key Bindings -----
bindkey '^[[A' history-search-backward    # Up arrow: search history
bindkey '^[[B' history-search-forward     # Down arrow: search history
bindkey '^R' fzf-history-widget           # Ctrl+R: fzf history search

# ----- Bun -----
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ----- pnpm -----
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# =============================================================
# Machine-specific overrides + secrets (gitignored)
# Put project API keys, work-only paths, etc. in ~/.zshrc.local
# =============================================================
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
