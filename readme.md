# Nandanugg's nvim config

### Prerequisite

Make sure these tools exist before installing.

Homebrew:

```bash
brew install neovim git gh tree-sitter-cli fzf ripgrep fd bat go node wget prettier utftex delve openjdk@21 tilt && brew install --cask font-jetbrains-mono-nerd-font && brew link --force openjdk@21
```

Arch Linux official repositories:

```bash
sudo pacman -S --needed base-devel curl unzip neovim git github-cli tree-sitter-cli fzf ripgrep fd bat go nodejs npm wget prettier delve jdk21-openjdk ttf-jetbrains-mono-nerd
```

Arch Linux AUR:

```bash
paru -S --needed tilt-bin libtexprintf-git
```

- `neovim` >= 0.12 (required by the current `nvim-treesitter` branch)
- A C compiler, `make`, `curl`, `tar`, `gzip`, and `unzip` (nvim-treesitter parser
  builds, Mason downloads, codesnap library download, `go test -race`).
  On macOS install Xcode Command Line Tools (`xcode-select --install`); on Arch use
  `base-devel`, `curl`, and `unzip`
- `git` (lazy.nvim, Mason, Telescope, fzf-lua, gitsigns, fugitive)
- `gh`, authenticated with `gh auth login` (GitHub PR review comments)
- `tree-sitter-cli` >= 0.26.1 (nvim-treesitter parser installs; use the package
  manager, not npm)
- `node` and `npm` (Mason-installed JS/TS/CSS/HTML/PHP language servers)
- `go` (Go LSP, Go formatters, Go testing, Go debugging)
- `wget` (Mason downloader fallback)
- `prettier` (Conform fallback formatter for JS/TS/Astro/HTML)
- `utftex` (render-markdown LaTeX rendering)
- `ripgrep` (Telescope, fzf-lua)
- `fzf` (fzf-lua)
- `fd` (Telescope, fzf-lua)
- `bat` (syntax-highlighted previews)
- `delve` (Go debugging)
- `openjdk@21` / `jdk21-openjdk` (`jdtls` requires Java 21+, also used by
  `google-java-format`)
- `tilt` (Tiltfile LSP support)
- Nerd Font (icons used by UI and markdown rendering)

### Optional

Not required by the config, but useful for specific workflows or to silence
`:checkhealth` warnings:

- `gotestsum` (alternative neotest-golang runner, currently disabled):
  `go install gotest.tools/gotestsum@latest`
- `php` and `composer` (running PHP projects; intelephense itself does not need them)
- `chafa`, `viu`, and `ueberzugpp` (fzf-lua image previews). Homebrew:
  `brew install chafa viu jstkdng/programs/ueberzugpp`
- `luarocks` and `julia` (only silence `:checkhealth mason` warnings)

### Installing

1. Install the prerequisites above
2. Clone this by:
```bash
git clone git@github.com:nandanugg/nvim-config.git ~/.config/nvim
```
3. Done, run `nvim` and all the config will get installed

### GitHub PR line comments

Select one or more lines in Visual or Visual Block mode, press `:`, then use:

- `gc [comment]` to submit a short comment immediately.
- `gce` to compose a longer Markdown comment in a new buffer. Close it
  with `ZZ` or `:wq` to submit, or `ZQ`/`:q!` to cancel.

The current branch must have an open PR. Comments target the selected lines on the
right (head) side of its diff, and GitHub only accepts lines that are part of that diff.
