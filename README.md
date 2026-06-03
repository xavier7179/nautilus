# NAUTILUS Theme

A personal Neovim configuration built around [snacks.nvim](https://github.com/folke/snacks.nvim), [blink.cmp](https://github.com/saghen/blink.cmp), and a modular per-language setup managed by [Mason](https://github.com/williamboman/mason.nvim).

## Pre-Requisites (OSX)

### Core tools

- iTerm2 or WezTerm terminal
- Nerd font (mono variant): `brew install font-meslo-lg-nerd-font` — select **Meslo LGS Nerd Font Mono** in your terminal profile
- Nerd font (alternative): `brew install font-jetbrains-mono-nerd-font`
- `brew install ripgrep` — used by grep pickers
- `brew install lazygit` — required for Snacks lazygit integration (`<leader>gg`, `<leader>gl`)
- `brew install libgit2` — required by fugit2.nvim
- `brew install node` — required by `js-debug-adapter`, `vtsls`, `eslint-lsp`, and `markdown-toc`
- `brew install cmake` — required to build CMake projects

### Remote development

- `brew install macos-fuse-t/homebrew-cask/fuse-t` — kext-less FUSE for macOS
- `brew install macos-fuse-t/homebrew-cask/sshfs-fuse-t` — SSHFS for mounting remote filesystems

### Rust

Install the Rust toolchain via [rustup](https://rustup.rs):

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

`rust-analyzer` is **not** used directly — this config uses `bacon-ls` + `rustaceanvim` instead. Both are installed by Mason via Cargo. Install `bacon` separately:

```sh
cargo install bacon
```

### Grammars

Treesitter parsers are managed automatically by `nvim-treesitter` via `:TSUpdate`. No system installation needed.

### Linters

Most linters and formatters are **auto-installed via Mason** on first launch (`:MasonUpdate`). The following require system-level installation:

- `cargo install bacon` — required for Rust continuous background diagnostics (auto-started when opening a Rust project)
- `brew install cppcheck` — required for C/C++ MISRA linting (not available via Mason)

All other tools (shellcheck, eslint, phpcs, markdownlint-cli2, yamllint, biome, shfmt, clang-format, clang-tidy, cmakelint, etc.) are managed automatically by Mason.

C/C++ MISRA checks are available through `cppcheck` in opt-in mode. Toggle MISRA linting in C/C++ buffers with `<leader>uM`.

## Post-Install (OSX)

- Update `.zshrc` setting the default editor: `export EDITOR=nvim`
- **Italian keyboard:** The `opt.langmap` line in `lua/nautilus/core/options.lua` that maps `è`/`+` to `[`/`]` is currently commented out (`-- not working`). Non-Italian keyboard users can ignore it.

## Language architecture

- `lua/nautilus/custom/lang-registry.lua` is the declarative capability registry
- Services may remain fully configured even when `enabled = false`
- `lua/nautilus/custom/lang.lua` is the only supported access layer for consumers
- Shared plugin modules consume normalized enabled-only data from `lang.lua`
- Per-language plugin files provide concrete implementation details and overrides

## Keymap Tree

All `<leader>` bindings follow a strict **tree organisation**: the first letter after `<leader>` identifies a group. Use `<leader>?` to open a which-key popup for the current buffer.

### Navigation (no leader)

| Key | Action |
|-----|--------|
| `gd` | Goto Definition |
| `gD` | Goto Declaration |
| `gR` | Goto References |
| `gi` | Goto Implementation |
| `gt` | Goto Type Definition |
| `ga` | Code Action |
| `gr` | Rename Symbol |
| `gl` | Float Diagnostic |
| `K` | Hover Documentation |
| `gS` | Toggle split/join (mini.splitjoin) |
| `zR` | Open all folds |
| `zM` | Close all folds |
| `h` / `l` | Fold / unfold on cursor line (overloaded) |
| `^` / `$` | Fold / unfold recursively (overloaded) |
| `<leader>uz` | Toggle auto-fold |
| `]h` / `[h` | Next / prev hunk |
| `]t` / `[t` | Next / prev TODO comment |
| `]q` / `[q` | Next / prev Trouble/Quickfix item |
| `]]` / `[[` | Next / prev word reference |
| `[C` | Jump to outer treesitter context |
| `[b` / `]b` | Go to / select next breadcrumb context (dropbar) |
| `<S-h>` / `<S-l>` | Prev / next buffer |
| `<C-hjkl>` | Navigate windows (smart-splits: seamless with WezTerm panes) |
| `<A-hjkl>` | Move lines / selections (mini.move) |
| `<leader>wr` | Resize mode — h/j/k/l to resize splits, `<Esc>` or `q` to exit |
| `<C-t>` | Toggle terminal |
| `<C-f>` / `<C-b>` | Scroll LSP docs forward/backward |

### `<leader>a` — AI

| Key | Action |
|-----|--------|
| `<leader>aa` | Agents: Select Agent (prompt picker) |
| `<leader>ac` | Toggle Chat (CodeCompanion) |
| `<leader>ao` | Actions / Options (CodeCompanion) |

### `<leader>b` — Buffer

| Key | Action |
|-----|--------|
| `<leader>bb` | Switch to other buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bD` | Buffer diagnostics (Trouble) |
| `<leader>bs` | Select scratch buffer |

### `<leader>c` — Code

| Key | Action |
|-----|--------|
| `<leader>cf` | Format buffer (conform.nvim) |
| `<leader>ch` | Switch between header and source (clangd, C/C++ buffers only) |
| `<leader>cg` | CMake Generate |
| `<leader>cb` | CMake Build |
| `<leader>cr` | CMake Run |
| `<leader>ct` | CMake Test |
| `<leader>cB` | Code Breadcrumb picker (dropbar) |
| `<leader>cR` | Rust Code Action (rustaceanvim, Rust buffers only) |

### `<leader>d` — Debug

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle Breakpoint |
| `<leader>dB` | Breakpoint Condition |
| `<leader>dc` | Continue |
| `<leader>dC` | Run to Cursor |
| `<leader>de` | Eval (n/v) |
| `<leader>di` | Step Into |
| `<leader>do` | Step Out |
| `<leader>dO` | Step Over |
| `<leader>dp` | Pause |
| `<leader>dq` | Toggle DAP REPL |
| `<leader>dr` | Run Debug Preset |
| `<leader>dR` | Run Last Debug Preset |
| `<leader>dG` | Rust Debuggables (rustaceanvim, Rust buffers only) |
| `<leader>dt` | Terminate |
| `<leader>du` | Toggle DAP UI |

### `<leader>f` — File

| Key | Action |
|-----|--------|
| `<leader>fe` | Toggle File Explorer |
| `<leader>fn` | New File |
| `<leader>fR` | Rename File |

### `<leader>g` — Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Lazygit |
| `<leader>gl` | Lazygit Log (cwd) |
| `<leader>gb` | Git Blame Line |
| `<leader>gB` | Git Browse (n/v) |
| `<leader>gc` | Fugit2 Commit Panel |
| `<leader>gd` | Diffview Open |
| `<leader>gD` | Diffview Close |
| `<leader>gH` | File History (diffview) |
| **`<leader>gh` — Hunks** | |
| `<leader>ghs` | Stage hunk (n/v) |
| `<leader>ghr` | Reset hunk (n/v) |
| `<leader>ghS` | Stage buffer |
| `<leader>ghR` | Reset buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Blame line (full) |
| `<leader>ghB` | Toggle line blame |
| `<leader>ghd` | Diff this |
| `<leader>ghD` | Diff this ~ |

### `<leader>m` — Markdown _(markdown buffers only)_

| Key | Action |
|-----|--------|
| `<leader>mm` | Toggle Render Markdown |
| `<leader>me` | Edit fenced code block (FeMaco) |
| `<leader>mt` | Update Markdown TOC |

### `<leader>o` — Overseer (Tasks)

| Key | Action |
|-----|--------|
| `<leader>or` | Run Task |
| `<leader>ot` | Toggle Tasks panel |
| `<leader>oa` | Task Quick Action |
| `<leader>oc` | Configure (lang task) |
| `<leader>ob` | Build (lang task) |
| `<leader>od` | Dev task (lang task) |
| `<leader>oR` | Run (lang task) |
| `<leader>oT` | Test task (lang task) |
| `<leader>op` | Run Pipeline |
| `<leader>oP` | Run Last Pipeline |

### `<leader>p` — Project

| Key | Action |
|-----|--------|
| `<leader>pd` | Project Diagnostics (Trouble) |
| `<leader>ps` | Project Symbols (Trouble) |
| `<leader>pL` | Location List (Trouble) |
| `<leader>pQ` | Quickfix List (Trouble) |
| `<leader>pT` | Project TODOs (Trouble) |

### `<leader>r` — Remote

| Key | Action |
|-----|--------|
| `<leader>rc` | Connect to remote host (picker from SSH config) |
| `<leader>rd` | Disconnect from remote host |
| `<leader>rf` | Find files on remote (runs `fd`/`find` via SSH) |
| `<leader>rg` | Live grep on remote (runs `rg` via SSH) |
| `<leader>re` | Edit an SSH config file |

### `<leader>s` — Search

| Key | Action |
|-----|--------|
| `<leader>sR` | Search & Replace (grug-far) |
| `<leader>sf` | Search Files |
| `<leader>sg` | Search Grep |
| `<leader>sw` | Search Word / selection |
| `<leader>sr` | Search Recent |
| `<leader>sb` | Search Open Buffers (sidebar) |
| `<leader>sB` | Grep Open Buffers |
| `<leader>sp` | Search Projects |
| `<leader>sc` | Search Config Files |
| `<leader>sh` | Search Help Pages |
| `<leader>sk` | Search Keymaps |
| `<leader>ss` | Search LSP Symbols |
| `<leader>sS` | Search LSP Workspace Symbols |
| **`<leader>sn` — Noice** | |
| `<leader>snl` | Noice Last Message |
| `<leader>snh` | Noice History |
| `<leader>sna` | Noice All |
| `<leader>snd` | Dismiss All |

### `<leader>t` — Test

| Key | Action |
|-----|--------|
| `<leader>tn` | Test Nearest |
| `<leader>tf` | Test File |
| `<leader>tl` | Test Last |
| `<leader>td` | Debug Test |
| `<leader>ts` | Test Summary |
| `<leader>to` | Test Output Panel |
| `<leader>tO` | Test Output |
| `<leader>tS` | Stop Test |

### `<leader>u` — UI / Toggles

| Key | Action |
|-----|--------|
| `<leader>uA` | Toggle Animate |
| `<leader>ub` | Toggle Dark Background |
| `<leader>uc` | Toggle Conceal Level |
| `<leader>uC` | Pick Colorscheme |
| `<leader>ud` | Toggle Diagnostics |
| `<leader>uD` | Toggle Dim Mode |
| `<leader>ue` | Toggle panels (explorer + terminal) |
| `<leader>ug` | Toggle Indent Guides |
| `<leader>uh` | Toggle Inlay Hints |
| `<leader>uK` | Toggle recording mode (showkeys + WezTerm font zoom) |
| `<leader>uI` | Pick Inspection Profile |
| `<leader>ul` | Toggle Line Numbers |
| `<leader>uL` | Toggle Relative Numbers |
| `<leader>um` | Toggle minimap |
| `<leader>uP` | Toggle Profiler |
| `<leader>uS` | Toggle Session Autosave |
| `<leader>us` | Toggle Spelling |
| `<leader>uT` | Toggle Treesitter |
| `<leader>uw` | Toggle Wrap |
| `<leader>un` | Dismiss all notifications |
| `<leader>uW` | Trim trailing whitespace |

### `<leader>w` — Window / Workspace

| Key | Action |
|-----|--------|
| `<leader>wv` | Split window vertically |
| `<leader>wh` | Split window horizontally |
| `<leader>we` | Equalize splits |
| `<leader>wc` | Close current split |
| `<leader>wo` | Open new tab |
| `<leader>wq` | Close current tab |
| `<leader>wn` | Next tab |
| `<leader>wp` | Previous tab |
| `<leader>wt` | Current buffer in new tab |
| `<leader>ws` | Save session |
| `<leader>wR` | Session search |
| `<leader>wl` | Restore last session |

### Convenience leaves (single-key shortcuts)

| Key | Action |
|-----|--------|
| `<leader>z` | Toggle Zen Mode |
| `<leader>Z` | Toggle Zoom |
| `<leader>.` | Toggle Scratch Buffer |
| `<leader>n` | Notification History |
| `<leader>N` | Neovim News |
| `<leader>?` | Buffer Keymaps (which-key) |

## Workflow Commands

- `:InspectionProfile` — show current inspection profile (`strict`, `normal`, `fast`)
- `:InspectionProfile <profile>` — switch inspection profile
- `:WorkspaceHealth` — show a workspace health report for current buffer context
- `:RunDebugPreset` — open debug preset picker (alias for `<leader>dr`)
- `:RunPipeline` — open pipeline picker (alias for `<leader>op`)
- `:AgentActions` — open AI agent picker (alias for `<leader>aa`)

## Features

### UI

| Plugin | Purpose |
|--------|---------|
| snacks.nvim | Dashboard, file picker, grep, explorer, notifier, zen mode, lazygit, terminal, scratch buffers |
| noice.nvim | Replaces cmdline, messages, and popupmenu UI |
| mini.statusline | Lightweight statusline with LSP progress, macro recording indicator, and lazy update count |
| mini.tabline | Buffer tabline with modified indicator |
| flash.nvim | Fast motions and search jumps |
| trouble.nvim | Diagnostics, references, and quickfix list panel |
| which-key.nvim | Keymap hints |
| render-markdown.nvim | In-buffer rendered Markdown |
| nvim-highlight-colors | Inline color code previews |
| showkeys | Displays pressed keys on screen — recording mode toggle (`<leader>uK`) also zooms WezTerm font |
| dropbar.nvim | IDE-style LSP/treesitter breadcrumb in the winbar (`<leader>cB` picker, `[b`/`]b` navigation) |
| nvim-treesitter-context | Sticky function/class context header while scrolling (`[C` to jump to context) |

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
| conform.nvim | Formatting on save (`<leader>cf` for manual format) |
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
| gitsigns.nvim | Hunk signs, staging, blame, diff (`<leader>gh*`) |
| fugit2.nvim | Floating commit panel — staged/unstaged tree, inline diff, commit message (`<leader>gc`) |
| diffview.nvim | Full-project diff view, file history, merge tool (`<leader>gd/gD/gH`) |
| Snacks lazygit | Full lazygit TUI — log, rebase, stash, remote management (`<leader>gg`, `<leader>gl`) |

### AI

| Plugin | Purpose |
|--------|---------|
| CodeCompanion.nvim | AI chat and inline edits (Copilot backend) |
| copilot.lua | GitHub Copilot engine |

### Editing Utilities

| Plugin | Purpose |
|--------|---------|
| smart-splits.nvim | Seamless navigation and resize across Neovim splits and WezTerm panes (`<C-hjkl>`, `<leader>wr` resize mode) |
| mini.ai | Extended text objects: `va)`, `yinq`, `ci'`, ... |
| mini.surround | Add / delete / replace surroundings (`sa`, `sd`, `sr`, …) |
| mini.splitjoin | Toggle split/join (`gS`) |
| mini.pairs | Auto-close brackets and quotes |
| mini.move | Move lines / selections in any direction (`<A-hjkl>`) |
| mini.map | Minimap sidebar with git diff and diagnostic markers (`<leader>um`) |
| mini.trailspace | Trailing whitespace highlight and auto-trim on save (`<leader>uW`) |
| mini.comment | Comment toggling with Treesitter context (`gc`, `gcc`) |
| nvim-ts-context-commentstring | Correct commentstring per embedded language context (used by mini.comment) |
| nvim-origami | LSP/Treesitter fold provider with fold decorations, auto-fold, and search-pause |
| grug-far.nvim | Project-wide find & replace panel (`<leader>sR`) |
| remote-sshfs.nvim | Remote file editing via SSHFS — connect to hosts, browse files, live grep over SSH (`<leader>r*`) |

### Language Support

| Language | LSP | Formatter | Linter | Debugger | Inlay Hints |
|----------|-----|-----------|--------|----------|-------------|
| C / C++ | clangd + clangd_extensions | clang-format | cppcheck (+ clang-tidy via clangd) | codelldb | ✓ (auto-enabled) |
| CMake | cmake-language-server | N/A | cmakelint | N/A | — |
| Dockerfile | dockerls | N/A | hadolint | N/A | — |
| Rust | bacon-ls + rustaceanvim + crates.nvim | rustfmt (built-in) | bacon | codelldb | `<leader>uh` |
| PHP | intelephense | php-cs-fixer | phpcs | php-debug-adapter | — |
| JavaScript / TypeScript | vtsls | biome | eslint | js-debug-adapter | ✓ (configured) — Jest + Vitest adapters |
| Markdown | marksman | markdownlint-cli2 | markdownlint-cli2 | N/A | — |
| YAML | yamlls + SchemaStore | LSP built-in | yamllint | N/A | — |
| Bash / Shell | bashls | shfmt | shellcheck | bash-debug-adapter | — |
| HTML | html-lsp | prettier | htmlhint | N/A | — |
| CSS | cssls | prettier | stylelint | N/A | — |
| JSON | json-lsp | prettier | N/A | N/A | — |
| Lua | lua_ls | stylua | N/A | N/A | ✓ (auto-enabled) |

## Uninstall

Follow the [Lazy uninstalling guide](https://github.com/folke/lazy.nvim#-uninstalling).
