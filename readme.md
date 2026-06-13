# Nandanugg's nvim config

### Prerequisite

Make sure these tools exist before installing.

Homebrew:

```bash
brew tap jstkdng/programs && brew install neovim git tree-sitter fzf ripgrep fd bat sqlite go node wget prettier utftex delve gotestsum openjdk@17 php composer tilt chafa viu luarocks julia jstkdng/programs/ueberzugpp && brew install --cask font-jetbrains-mono-nerd-font && brew link --force openjdk@17
```

Arch Linux official repositories:

```bash
sudo pacman -S --needed base-devel neovim git tree-sitter-cli fzf ripgrep fd bat sqlite go nodejs npm wget prettier delve jdk17-openjdk php composer chafa viu ueberzugpp luarocks julia ttf-jetbrains-mono-nerd
```

Arch Linux AUR:

```bash
paru -S --needed gotestsum tilt-bin libtexprintf-git
```

Go projects that use Testify suites:

```bash
go get github.com/stretchr/testify
```

- `neovim` >= 0.12 (required by the current `nvim-treesitter` branch)
- Xcode Command Line Tools (`xcode-select --install`) for `clang`, `make`,
  `curl`, `tar`, `gzip`, and `unzip`
- `git` (lazy.nvim, Mason, Telescope, fzf-lua, gitsigns, fugitive)
- `tree-sitter` (nvim-treesitter parser installs)
- `node` and `npm` (Mason-installed JS/TS/CSS/HTML language servers)
- `go` (Go LSP, Go testing, Go debugging)
- `wget` (Mason downloader fallback)
- `prettier` (Conform fallback formatter for JS/TS/Astro/HTML)
- `utftex` (render-markdown LaTeX rendering)
- `ripgrep` (Telescope, fzf-lua, frecency)
- `fzf` (fzf-lua)
- `fd` (Telescope, fzf-lua, frecency)
- `bat` (syntax-highlighted previews)
- `sqlite3` (sqlite.lua, neoclip, frecency)
- `delve`, `gotestsum`, and `testify` (Go debugging and neotest-golang)
- `openjdk@17` / `jdk17-openjdk` (Java LSP support with `jdtls`)
- `php` and `composer` (PHP tooling)
- `tilt` (Tiltfile LSP support)
- `chafa`, `viu`, and `ueberzugpp` (fzf-lua media previews)
- `luarocks` and `julia` (Mason language package manager checks)
- Nerd Font (icons used by UI and markdown rendering)

### Installing

1. Install the prerequisites above
2. Clone this by:
```bash
git clone git@github.com:nandanugg/nvim-config.git ~/.config/nvim
```
3. Done, run `nvim` and all the config will get installed
