# NAUTILUS Theme

A personal Neovim configuration built around [snacks.nvim](https://github.com/folke/snacks.nvim), [blink.cmp](https://github.com/saghen/blink.cmp), and a modular per-language setup managed by [Mason](https://github.com/williamboman/mason.nvim).

## Pre-Requisites (OSX)

### Core tools

- iTerm2 or WezTerm terminal
- Nerd font (mono variant): `brew install font-meslo-lg-nerd-font` — select **Meslo LGS Nerd Font Mono** in your terminal profile
- Nerd font (alternative): `brew install font-jetbrains-mono-nerd-font`
- `brew install ripgrep` — used by grep pickers
- `brew install fzf`
- `brew install lazygit` — required for Snacks lazygit integration (`<leader>gg`, `<leader>gf`, `<leader>gl`)
- `brew install node` — required by JavaScript, PHP, and Bash DAP adapters
- `brew install cmake` — required for CMake language support
- `brew install pngpaste` — required for image pasting support
- `npm install -g @mermaid-js/mermaid-cli` — required for diagram rendering in snacks

### Rust

Install the Rust toolchain via [rustup](https://rustup.rs):

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Then ensure `rust-analyzer` is present:

```sh
rustup component add rust-analyzer
```

### Grammars

- `brew install tree-sitter` — enables automatic installation of Treesitter parsers

### Linters

Most linters and formatters are **auto-installed via Mason** on first launch (`:MasonUpdate`). The following require system-level installation:

- **(clang-tidy / clang-format)** Install LLVM:

```sh
brew install llvm
ln -s "$(brew --prefix llvm)/bin/clang-format" "/usr/local/bin/clang-format"
ln -s "$(brew --prefix llvm)/bin/clang-tidy" "/usr/local/bin/clang-tidy"
```

All other tools (shellcheck, eslint, phpcs, markdownlint-cli2, yamllint, biome, shfmt, etc.) are managed automatically by Mason.

## Post-Install (OSX)

- Update `.zshrc` setting the default editor: `export EDITOR=nvim`
- **Italian keyboard:** `options.lua` maps `è` and `+` to `[` and `]` via `langmap`. Non-Italian keyboard users should remove or adjust the `opt.langmap` line in `lua/nautilus/core/options.lua`.

## Features

### UI

| Plugin | Purpose |
|--------|---------|
| snacks.nvim | Dashboard, file picker, grep, explorer, notifier, zen mode, lazygit, terminal, scratch buffers |
| noice.nvim | Replaces cmdline, messages, and popupmenu UI |
| mini.statusline | Lightweight statusline |
| mini.tabline | Buffer tabline with modified indicator |
| flash.nvim | Fast motions and search jumps |
| trouble.nvim | Diagnostics, references, and quickfix list panel |
| which-key.nvim | Keymap hints |
| render-markdown.nvim | In-buffer rendered Markdown |
| nvim-highlight-colors | Inline color code previews |
| showkeys | Displays pressed keys on screen (toggle with `<leader>uK`) |

### Completion

| Plugin | Purpose |
|--------|---------|
| blink.cmp | Main completion engine (LSP, snippets, path, buffer, emoji, Copilot) |
| LuaSnip | Snippet engine |
| blink-copilot | GitHub Copilot source for blink.cmp |
| blink-emoji | Emoji completion source (git commits and Markdown) |
| lazydev.nvim | Neovim Lua API completions |

### LSP & Code Quality

| Plugin | Purpose |
|--------|---------|
| nvim-lspconfig | LSP client configuration |
| mason.nvim | LSP / DAP / linter / formatter installer |
| conform.nvim | Formatting on save |
| nvim-lint | Linting on save / insert leave |

### Debugging

| Plugin | Purpose |
|--------|---------|
| nvim-dap | Debug Adapter Protocol client |
| nvim-dap-ui | Debug UI panels (auto-open/close) |
| nvim-dap-virtual-text | Inline variable values during debugging |

### Git

| Plugin | Purpose |
|--------|---------|
| gitsigns.nvim | Hunk signs, staging, blame, diff |
| Snacks lazygit | Full lazygit UI (`<leader>gg`) |

### AI

| Plugin | Purpose |
|--------|---------|
| CodeCompanion.nvim | AI chat and inline edits (Copilot backend) |
| copilot.lua | GitHub Copilot engine |

### Editing Utilities

| Plugin | Purpose |
|--------|---------|
| mini.ai | Extended text objects: `va)`, `yinq`, `ci'`, ... |
| mini.surround | Add / delete / replace surroundings |
| mini.splitjoin | Toggle split/join (`gS`) |
| mini.pairs | Auto-close brackets and quotes |
| nvim-ufo | Modern fold provider (Treesitter + indent) |
| Comment.nvim | Smart commenting with Treesitter context |
| todo-comments.nvim | Highlight and navigate TODO/FIXME/etc. |
| auto-session | Session save and restore |
| vim-pencil | Soft-wrap writing mode for Markdown |

### Language Support

| Language | LSP | Formatter | Linter | Debugger |
|----------|-----|-----------|--------|----------|
| C / C++ | clangd + clangd_extensions | clang-format | clang-tidy | codelldb |
| CMake | cmake-language-server | N/A | cmakelint | N/A |
| Rust | rust-analyzer (rustaceanvim) + crates.nvim | LSP built-in | clippy | codelldb |
| PHP | intelephense | php-cs-fixer | phpcs | php-debug-adapter |
| JavaScript / TypeScript | vtsls | biome | eslint | js-debug-adapter |
| Markdown | marksman | markdownlint-cli2 | markdownlint-cli2 | N/A |
| YAML | yamlls + SchemaStore | LSP built-in | yamllint | N/A |
| Bash / Shell | bashls | shfmt | shellcheck | bash-debug-adapter |
| Lua | lua_ls | stylua | N/A | N/A |

## Uninstall

Follow the [Lazy uninstalling guide](https://github.com/folke/lazy.nvim#-uninstalling).
