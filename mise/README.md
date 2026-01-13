# Mise Configuration for Language Profiles

This directory contains example mise configurations for each language profile supported in the neovim setup.

## What is Mise?

[Mise](https://mise.jdx.dev/) is a polyglot tool version manager. It replaces tools like nvm, rbenv, pyenv, etc. with a single unified interface for managing development tools and their versions.

## How It Works with Neovim

The neovim language profiles expect all LSP servers, formatters, and linters to be available in your PATH. Mise manages the installation and versioning of these tools, while neovim simply uses them.

**Key principle:** Neovim and mise are completely decoupled. You manually activate the mise environment AND load the neovim profile.

## Usage

### Option 1: Project-specific Configuration (Recommended)

Copy the relevant `.toml` file(s) to your project as `.mise.toml`:

```bash
# For a Go project
cp mise/go.toml /path/to/project/.mise.toml

# For a full-stack project (combine multiple languages)
cat mise/go.toml mise/typescript.toml > /path/to/project/.mise.toml
```

Then install and activate tools:

```bash
cd /path/to/project
mise install    # Install all tools defined in .mise.toml
mise use        # Activate tools in current shell
```

### Option 2: Global Configuration

Add tools to your global mise config (`~/.config/mise/config.toml`):

```bash
cat mise/go.toml >> ~/.config/mise/config.toml
mise install
```

### Option 3: Per-directory Environment

Use mise's directory-specific activation:

```bash
# Add to your shell rc file (~/.zshrc or ~/.bashrc)
eval "$(mise activate zsh)"  # or bash

# Then mise automatically activates when you cd into a directory with .mise.toml
cd /path/to/project  # Tools automatically available
```

## Neovim Integration

After mise tools are in your PATH, load the corresponding neovim profile:

### Automatic Loading

Create a `.nvim-profiles` file in your project root:

```
# .nvim-profiles
go
typescript
```

Then just open neovim - profiles load automatically.

### Manual Loading

```vim
:LoadLanguage go
:LoadLanguages go typescript rust
```

### Shell Aliases

Add to your shell rc file:

```bash
nvim-go() { nvim -c "LoadLanguage go" "$@" }
nvim-rust() { nvim -c "LoadLanguage rust" "$@" }
```

## Tool Matrix

| Language   | LSP Servers                          | Formatters            | Linters | Mise Config    |
|------------|--------------------------------------|-----------------------|---------|----------------|
| Go         | gopls, templ                         | goimports, golines    | -       | `go.toml`      |
| Rust       | rust-analyzer                        | rustfmt               | -       | `rust.toml`    |
| TypeScript | ts_ls, html, cssls, tailwindcss      | prettierd             | -       | `typescript.toml` |
| Python     | pyright                              | isort, black          | ruff    | `python.toml`  |
| Lua        | lua_ls                               | stylua                | -       | `lua.toml`     |
| Elixir     | elixirls                             | -                     | -       | `elixir.toml`  |
| PHP        | intelephense                         | pint                  | -       | `php.toml`     |
| Svelte     | svelte, tailwindcss                  | prettierd             | -       | `svelte.toml`  |
| Odin       | ols                                  | -                     | -       | `odin.toml`    |

## Example Workflow

### Starting a New Go Project

```bash
# 1. Create project directory
mkdir my-go-project
cd my-go-project

# 2. Copy mise config
cp ~/repo/neovim-setup/mise/go.toml .mise.toml

# 3. Install tools
mise install

# 4. Create .nvim-profiles for automatic neovim setup
echo "go" > .nvim-profiles

# 5. Open neovim (Go profile loads automatically)
nvim main.go
```

### Working on an Existing Project

```bash
# 1. Navigate to project
cd existing-project

# 2. If .mise.toml exists, activate it
mise use

# 3. Open neovim and load profile(s)
nvim
:LoadLanguage go
```

## Installing Mise

### macOS/Linux

```bash
curl https://mise.run | sh
```

### With Homebrew

```bash
brew install mise
```

### Shell Integration

Add to `~/.zshrc` or `~/.bashrc`:

```bash
eval "$(mise activate zsh)"  # or bash
```

## Tips

1. **Check installed tools:** `mise list`
2. **Check active tools:** `mise current`
3. **Update tools:** `mise upgrade`
4. **Remove unused versions:** `mise prune`
5. **See available versions:** `mise ls-remote go` (for example)

## Troubleshooting

### LSP Server Not Found

```bash
# Check if tool is in PATH
which gopls

# If not, ensure mise is activated
mise use

# Or check mise installation
mise list
```

### Wrong Version

```bash
# Check current version
go version

# Check mise config
cat .mise.toml

# Reinstall
mise install
```

### Neovim Can't Find Tools

Ensure mise is activated in your shell BEFORE launching neovim:

```bash
mise use
nvim
```

Or configure your shell to auto-activate mise:

```bash
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
```

## Further Reading

- [Mise Documentation](https://mise.jdx.dev/)
- [Mise Configuration Reference](https://mise.jdx.dev/configuration.html)
- [Neovim LSP Guide](https://neovim.io/doc/user/lsp.html)
