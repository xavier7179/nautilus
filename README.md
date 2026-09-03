# NAUTILUS Theme

```text
 _  _   _  _   _ _____ ___ _   _   _ ___
| \| | /_\| | | |_   _|_ _| | | | | / __|
| .` |/ _ \ |_| | | |  | || |_| |_| \__ \
|_|\_/_/ \_\___/  |_| |___|____\___/|___/
              a Neovim configuration
```

A complete, opinionated Neovim development environment built around [snacks.nvim](https://github.com/folke/snacks.nvim), [blink.cmp](https://github.com/saghen/blink.cmp), and a modular per-language setup managed by [Mason](https://github.com/williamboman/mason.nvim). It is designed to be cloned or forked, then adapted to your own workflow rather than treated as a fixed personal dotfile dump.

## General Approach

Nautilus aims to provide useful defaults without making routine customization require a rewrite. The configuration is organized around a few principles:

- **Opinionated workflow:** project navigation, completion, diagnostics, formatting, testing, debugging, Git, tasks, and remote development are available from a consistent keymap tree.
- **Low-maintenance configuration:** plugin specifications are grouped by responsibility and use lazy-loading, so most changes are isolated to one small module instead of a monolithic file.
- **One language registry:** language capabilities are declared once in `lua/nautilus/custom/lang-registry.lua`. LSP servers, formatters, linters, debuggers, tests, tasks, and Treesitter parsers are derived from that registry rather than duplicated across plugin files.
- **Explicit extension points:** core options and mappings live under `lua/nautilus/core/`; shared behavior lives under `lua/nautilus/custom/`; language-specific overrides live under `lua/nautilus/plugins/lang/`.
- **Native Neovim APIs:** the configuration targets Neovim 0.12+ and uses its native LSP configuration and enablement APIs.

The boot path is intentionally small: `init.lua` loads `nautilus.core`, then `nautilus.lazy` bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim). Plugins are split into four groups: core plugins (`plugins/`), UI (`plugins/ui/`), languages (`plugins/lang/`), and utilities (`plugins/utils/`).

## Themes

The visual setup is dark-first, terminal-oriented, and built to keep the editor readable while exposing diagnostics, Git changes, code structure, and active modes. Several themes are available rather than enforcing one palette:

- Use `<leader>uC` to choose a colorscheme.
- The selected colorscheme is persisted between Neovim sessions.
- Only the selected theme is eagerly loaded; the other theme plugins remain lazy-loaded.
- Theme integrations cover completion, diagnostics, DAP, Git, Markdown, Snacks, Treesitter, which-key, and other UI components where supported.
- Nerd Font icons, true color, and terminal color support are enabled by default. Set `vim.g.have_nerd_font = false` in `lua/nautilus/core/options.lua` if your terminal does not use a Nerd Font.

## Using This Repository

You can use the upstream repository directly or create your own fork. A fork is recommended when you want to maintain personal keymaps, language choices, plugins, or theme defaults independently.

### Clone the upstream repository

```sh
git clone <PII type="EMAIL" id="22"/>:xavier7179/nautilus.git ~/.config/nvim
```

### Clone your fork

Replace `<your-user>/<your-fork>` with your fork's SSH or HTTPS URL:

```sh
git clone git@github.com:<your-user>/<your-fork>.git ~/.config/nvim
```

If `~/.config/nvim` already contains a configuration, back it up first or use a separate Neovim profile. For a simple backup:

```sh
mv ~/.config/nvim ~/.config/nvim.backup
```

After cloning, start Neovim. `lazy.nvim` bootstraps automatically and installs the configured plugins. The repository's `lazy-lock.json` pins plugin versions and should remain committed in your fork.

The most common customization locations are:

| What to change | Where |
|----------------|-------|
| Editor options and defaults | `lua/nautilus/core/options.lua` |
| Keymaps and leader groups | `lua/nautilus/core/keymaps.lua` |
| Commands and reusable functions | `lua/nautilus/core/commands.lua`, `functions.lua` |
| Theme list and theme-specific options | `lua/nautilus/plugins/ui/themes.lua` |
| Persisted colorscheme behavior | `lua/nautilus/custom/colorscheme.lua` |
| Language capabilities | `lua/nautilus/custom/lang-registry.lua` |
| Language-specific plugin behavior | `lua/nautilus/plugins/lang/` |
| Shared language consumers | `lua/nautilus/custom/lang.lua` and `lua/nautilus/plugins/` |

Most users should be able to customize the config by changing one of these focused files. Adding or changing a language normally does not require editing Mason, LSP, formatting, linting, testing, debugging, task, and Treesitter modules individually.

## Installation

This configuration targets **Neovim 0.12 or newer** and currently assumes macOS with Homebrew.

Back up any existing Neovim configuration, then clone either the upstream repository or your fork into Neovim's configuration directory. If you have not cloned it yet, the upstream option is:

```sh
mv ~/.config/nvim ~/.config/nvim.backup  # skip if no existing config is present
git clone <PII type="EMAIL" id="22"/>:xavier7179/nautilus.git ~/.config/nvim
nvim
```

On the first launch, `lazy.nvim` bootstraps automatically and installs the configured plugins. After the plugin installation finishes, run:

```vim
:ToolsSync
:TSUpdate
:checkhealth
:WorkspaceHealth
```

`:ToolsSync` installs the configured LSP servers, formatters, linters, and debug adapters through Mason. `:TSUpdate` installs or updates Treesitter parsers. `:WorkspaceHealth` reports missing tools for the current language and provides remediation hints.

To update plugins later, use `:Lazy` and run `:Lazy update` manually. Automatic update checks are disabled.

## Dependencies (macOS)

### Required core tools

- Neovim `0.12+`
- Git — required to bootstrap `lazy.nvim` and for Git integrations: `brew install git`
- iTerm2 or [WezTerm](https://wezfurlong.org/wezterm/)
- Nerd font (mono variant): `brew install font-meslo-lg-nerd-font` — select **Meslo LGS Nerd Font Mono** in your terminal profile
- Nerd font (alternative): `brew install font-jetbrains-mono-nerd-font`
- `brew install ripgrep` — used by grep pickers

The Nerd Font is required for the configured iconography. If you do not use a Nerd Font, set `vim.g.have_nerd_font = false` in `lua/nautilus/core/options.lua`.

### Optional integrations

- `brew install lazygit` — enables Snacks lazygit integration (`<leader>gg`, `<leader>gl`)
- `brew install libgit2` — used by fugit2.nvim (`<leader>gc`)
- `brew install cmake` — required for CMake project workflows
- WezTerm — enables cross-pane navigation and resizing through smart-splits; Neovim split navigation works in other terminals too

The plugin manager, Mason packages, and Treesitter parsers are installed automatically. They do not need to be installed with Homebrew.

### Remote development

- `brew install macos-fuse-t/homebrew-cask/fuse-t` — kext-less FUSE for macOS
- `brew install macos-fuse-t/homebrew-cask/sshfs-fuse-t` — SSHFS for mounting remote filesystems
- Configure the hosts you want to access in `~/.ssh/config` before using `<leader>r*`.

#### Configuring a remote host

Add a normal `Host` entry per remote in `~/.ssh/config`:

```
Host myhost
    HostName 203.0.113.10
    User deploy
    Port 22
    # Path=/var/www/myproject
```

- `Path` is a custom comment directive — not a real `ssh_config` keyword — that `remote-sshfs.nvim` parses to pick the subdirectory sshfs mounts. With it set, `<leader>rc` lands directly in `/var/www/myproject` instead of the account's home directory. Omit it to mount the home directory.
- Set up key-based authentication for the host **before** connecting:

  ```sh
  ssh-copy-id -p <port> -i ~/.ssh/id_ed25519.pub myhost
  ssh -o BatchMode=yes myhost 'echo ok'   # should print "ok" with no password prompt
  ```

  Password auth works, but on this fuse-t/macOS setup it reliably drives `sshfs`'s `password_stdin` path into a busy-poll loop that pegs a CPU core and floods Neovim's job callback with log output, freezing the editor until the stray `sshfs`/`go-nfsv4` processes are killed by hand. Key auth skips the password path entirely and avoids this.
- `<leader>rf` / `<leader>rg` shell out over SSH and require `rg`, `fd`, `fdfind`, or `where` to be installed on the *remote* host. Many hosts (shared hosting, minimal containers) have none of these. Since the mount already exposes the remote files locally under `~/.sshfs/<host>/`, prefer the regular local pickers (`<leader>sf`, `<leader>sg`) once connected — they run `rg`/`fd` on macOS against the mounted files and don't depend on what's installed remotely.

#### Deploy workflow (edit locally, push on demand)

`<leader>rc`/sshfs above mounts and edits the remote filesystem live over the network — the right tool for quick remote browsing, but the wrong one for sustained work on a project: every read/write is a network round-trip, and a stalled connection stalls the editor with it. For a project you're actually developing, keep a real local working copy and push to the remote explicitly instead — the same model as JetBrains' "Deployment" feature.

Add a `.nvim-deploy.lua` file at the project's root:

```lua
return {
  host = "myhost",                    -- SSH config Host alias
  remote_path = "/var/www/myproject",
  excludes = { "uploads/", "cache/" }, -- optional, merged with built-in defaults
  delete = false,                     -- optional: pass --delete to rsync on push only
}
```

- `<leader>rp` (`:DeployPush`) and `<leader>rP` (`:DeployPull`) walk up from the current buffer to find `.nvim-deploy.lua`, run an `rsync` dry-run, show the itemized changes in a scratch buffer, and ask for confirmation before actually syncing (via `rsync` in a terminal split, so transfer progress is visible).
- Nothing is pushed automatically on save — sync only happens when you explicitly ask for it.
- `delete` only ever applies to push (`--delete`, removing remote files absent locally); pull never deletes local files, regardless of that setting — pull is for reviewing/grabbing server-side drift, not for silently discarding local work.
- If the project doesn't already have a local copy, pull one down manually first (`rsync -avz host:/remote/path/ ./`), `git init` it, then use `<leader>rp`/`<leader>rP` from there on.
- See `lua/nautilus/custom/deploy.lua` for the implementation.

### Rust

Install the Rust toolchain via [rustup](https://rustup.rs):

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

The Rust configuration uses `bacon-ls` and `rustaceanvim` for the primary workflow, while `rust-analyzer` remains available in the registry for compatibility. Mason installs the configured Rust packages. Install `bacon` separately:

```sh
cargo install bacon
```

### Grammars

Treesitter parsers are managed automatically by `nvim-treesitter` via `:TSUpdate`. No system installation needed.

### Language-specific tools

Install only the tools for the languages you use:

- JavaScript / TypeScript: `brew install node` — required by npm tasks, `vtsls`, `js-debug-adapter`, and Markdown TOC tooling
- PHP: install PHP and [Composer](https://getcomposer.org/) — required for PHP runtime, Composer tasks, PHPUnit, and project-local `vendor/bin/*` tools
- Python: install Python and `pytest`; Ruff, basedpyright, and debugpy are installed through Mason
- Rust: install the Rust toolchain with `rustup`, then `cargo install bacon`
- CMake: `brew install cmake`

### Linters and formatters

Most linters and formatters are **auto-installed via Mason** on first launch (`:MasonUpdate`). The following require system-level installation:

- `cargo install bacon` — required for Rust continuous background diagnostics (auto-started when opening a Rust project)
- `brew install cppcheck` — required for C/C++ MISRA linting (not available via Mason)

All other configured tools (shellcheck, eslint, phpcs, markdownlint-cli2, yamllint, biome, shfmt, clang-format, clang-tidy, cmakelint, and most language servers/debug adapters) are managed automatically by Mason.

C/C++ MISRA checks are available through `cppcheck` in opt-in mode. Toggle MISRA linting in C/C++ buffers with `<leader>uM`.

## Optional AI setup

AI plugins are installed with the configuration but require their own authentication:

- GitHub Copilot: install and authenticate `copilot.lua` with `:Copilot auth`. Copilot powers completion and CodeCompanion chat.
- Claude Code: install and authenticate the `claude` CLI, then use the `<leader>ak*` mappings. The Claude integration does not work until the CLI is available on `PATH`.

These integrations are optional; the rest of the configuration works without either service.

## Post-Install (OSX)

- Update `.zshrc` setting the default editor: `export EDITOR=nvim`
- **Italian keyboard:** The `opt.langmap` line in `lua/nautilus/core/options.lua` that maps `è`/`+` to `[`/`]` is currently commented out (`-- not working`). Non-Italian keyboard users can ignore it.

## Troubleshooting

- Run `:WorkspaceHealth` from a language buffer to identify missing Mason packages, Treesitter parsers, or external binaries.
- Run `:WorkspaceHealthFix` to install missing Mason packages and Treesitter parsers for the current buffer.
- Run `:Mason` to inspect or install individual packages.
- Run `:MasonToolsInstall` to install all configured Mason-managed tools.
- Run `:TSUpdate` if syntax highlighting or indentation is missing.
- Run `:checkhealth` when Neovim, a plugin, or an external executable is not behaving as expected.
- For language tasks and tests, verify that the project itself provides the expected commands, such as npm scripts, Composer scripts, `pytest`, or Cargo targets.

## Language architecture

- `lua/nautilus/custom/lang-registry.lua` is the declarative capability registry
- Services may remain fully configured even when `enabled = false`
- `lua/nautilus/custom/lang.lua` is the only supported access layer for consumers
- Shared plugin modules consume normalized enabled-only data from `lang.lua`
- Per-language plugin files provide concrete implementation details and overrides

## Supported Languages

The registry currently provides the following language workflows. Services marked as unavailable are intentionally not configured for that language.

| Language | LSP | Formatting | Linting | Debugging | Tests / Tasks |
|----------|-----|------------|---------|-----------|--------------|
| C / C++ | `clangd` | `clang-format` | `cppcheck` | `codelldb` | Project tasks |
| CMake | `cmake-language-server` | `cmake-format` | `cmakelint` | N/A | Configure, build, test |
| Dockerfile | `dockerls` | N/A | `hadolint` | N/A | Docker workflows |
| Rust | `bacon-ls`, `rustaceanvim` (`rust-analyzer` available) | `rustfmt` | `bacon` | `codelldb` | Cargo tasks, tests, debug presets |
| PHP | `intelephense` | `php-cs-fixer` | `phpcs` | `php-debug-adapter` | Composer and PHPUnit workflows |
| JavaScript / TypeScript | `vtsls` | `biome` | `eslint` | `js-debug-adapter` | npm, Jest, and Vitest workflows |
| Python | `basedpyright` | Ruff | Ruff | `debugpy` | pytest workflows |
| Markdown | `marksman` | N/A | `markdownlint-cli2` | N/A | Markdown tasks and rendering |
| YAML | `yamlls` + SchemaStore | `yamlfmt` | `yamllint` | N/A | YAML tasks |
| Bash / Shell | `bashls` | `shfmt` | `shellcheck` | `bash-debug-adapter` | Shell tasks |
| HTML | `html-lsp` | Prettier | `htmlhint` | N/A | HTML tasks and rendering |
| CSS | `cssls` | Prettier | `stylelint` | N/A | CSS tasks |
| JSON | `json-lsp` | Prettier | N/A | N/A | JSON tasks |
| Lua | `lua_ls` | `stylua` | N/A | N/A | Lua run/debug presets |

To add or change a language, update the registry first, then add or adjust its focused file under `lua/nautilus/plugins/lang/`. Shared consumers automatically receive the normalized registry data. See `plans/language-support.md` for the complete language-entry template.

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
| `<leader>pa` | Action Palette |
| `<leader>pt` | Project Templates |

### `<leader>r` — Remote

| Key | Action |
|-----|--------|
| `<leader>rc` | Connect to remote host (picker from SSH config) |
| `<leader>rd` | Disconnect from remote host |
| `<leader>rf` | Find files on remote (runs `fd`/`find` via SSH) |
| `<leader>rg` | Live grep on remote (runs `rg` via SSH) |
| `<leader>re` | Edit an SSH config file |
| `<leader>rp` | Deploy: push local changes to the project's remote (`:DeployPush`) |
| `<leader>rP` | Deploy: pull remote changes into the local project (`:DeployPull`) |

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
- `:Action` — open command palette aliases (launcher: `<leader>pa`)
- `:TemplateNew` — open project template wizard (launcher: `<leader>pt`)

## Daily Workflow

- Open action palette with `<leader>pa` (or `:Action`) for high-signal actions.
- Create new projects with `<leader>pt` (or `:TemplateNew`).
- Start debug via `<leader>dr` (preset picker), then iterate with `<leader>dR`.
- Run workflows with `<leader>op` (pipeline picker) and rerun with `<leader>oP`.
- Switch quality mode quickly with `<leader>uI` or `:InspectionProfile <strict|normal|fast>`.
- Run `:WorkspaceHealth` to validate toolchain/registry readiness and get remediation hints.

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
| deploy (custom, `custom/deploy.lua`) | Local-edit/explicit-push workflow for remote projects — rsync push/pull with dry-run diff and confirmation (`<leader>rp`/`<leader>rP`, see `.nvim-deploy.lua`) |

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
