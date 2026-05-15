# dotfiles

Maxwell's macOS dev environment, packaged for one-command provisioning.

```
git clone https://github.com/<you>/dotfiles.git ~/_git/dotfiles
cd ~/_git/dotfiles
./install.sh
```

That's it. New shell, new prompt, new tools, new bells.

## What's inside

| Package | Lands at | Contents |
|---|---|---|
| `zsh/` | `~/.zshrc`, `~/.zshenv`, `~/.zprofile`, `~/.bashrc`, `~/.profile`, `~/.tcshrc` | Zinit + plugins, starship init, zoxide, fzf, aliases, key bindings, terminal-title hook, bun/pnpm PATH |
| `git/` | `~/.gitconfig`, `~/.config/git/ignore` | identity + global ignore |
| `starship/` | `~/.config/starship.toml` | prompt theme |
| `claude/` | `~/.claude/settings.json`, `~/.claude/sounds/bass-notify.aiff` | Claude Code stop-hook, statusline, enabled plugins |
| `Brewfile` | — | every formula, cask, and VSCode extension |
| `install.sh` | — | brew bundle + stow loop, idempotent |

## How it works

GNU `stow` symlinks each top-level package into `$HOME`. Each package's directory tree mirrors what it places in your home:

```
zsh/.zshrc                            →  ~/.zshrc
starship/.config/starship.toml        →  ~/.config/starship.toml
claude/.claude/settings.json          →  ~/.claude/settings.json
```

Add files by dropping them at the right path inside a package; re-run `./install.sh --link` (or `stow -d . -t ~ --restow zsh`) to relink.

## Secrets & per-machine config

`~/.zshrc` sources `~/.zshrc.local` at the very end. That file is **gitignored** — put API keys, work paths, and per-machine overrides there. A template lives at `zsh/.zshrc.local.example` and is copied on first install.

```bash
# ~/.zshrc.local
export OPENAI_API_KEY="sk-..."
export EDITOR='code --wait'
```

## Updating

```bash
brew bundle dump --force --file=Brewfile      # snapshot current brew state
git add Brewfile && git commit -m "brew sync"
```

Edit any dotfile in-place (it's a symlink), commit, push.

## Enabled Claude Code plugins

Captured in `claude/.claude/settings.json`:

- `frontend-design@claude-plugins-official`
- `vercel@claude-plugins-official`
- `superpowers@claude-plugins-official`
- `ui-ux-pro-max-skill` (extra marketplace)

The `gstack` plugin and its `notion-task-databases.json` are **not** included — they're machine-specific (Notion auth + per-repo paths). Re-add manually if desired.

## Not included (intentionally)

- `~/.claude.json` — session state / auth
- `~/.ssh/` — keys
- `~/.fly/`, `~/.copilot/`, `~/.cargo/`, etc. — tool state, rebuilt on first use
- VSCode `settings.json` — minimal enough to not bother; extensions are in the Brewfile
- Roblox / project API keys — belong in project-scoped `.env` files, not the global shell
