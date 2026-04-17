# TODO List

## Functionalities

[X] Advanced Theme (from [here](https://github.com/folke/snacks.nvim/discussions/1239))
[X] Remove telescope and place Snacks pickers
[X] Check the landing page for Git not to report process exit when no changes are detected

## Plugins

[X] Snacks.nvim Profiler
[X] Blink.cmp
[X] mini.statusline
[X] Replace nvim-ufo with nvim-origami (LSP folds, fold decorations, h/l keymaps, Snacks auto-fold toggle)
[ ] More mini plugins
[ ] Hologram.nvim
[ ] Edgy templates for each type of Supported Language (with [edge-group.vim](https://github.com/lucobellic/edgy-group.nvim)?)
[X] Evaluate placing back overseer
[X] Evaluate introducing neotest

### Plugin notes

- **Comment.nvim**: Neovim 0.10+ has native `gc`/`gcc` commenting. The only real value
  is the `ts_context_commentstring` integration for TSX/JSX/Svelte/HTML. Since
  `ts_context_commentstring` ≥ 0.8 works with the native commenting too, this plugin
  is a candidate for removal in a future cleanup pass.
- **showkeys**: Pure demo/presentation utility (`<leader>uK`). No conflicts; low daily value.
- **vim-pencil**: No keymaps; loaded lazily for markdown/plaintex. Low priority.

## Language support (= LSP, Linter, Formatter, Debugger, Extras)

[X] C
[X] C++
[X] CMake ([CMake tools](https://github.com/Civitasv/cmake-tools.nvim))
[X] Rust
[X] PHP
[X] Node
[X] Javascript / Typescript
[X] Markdown
[X] YAML
[X] Bash / Shell
[X] Lua

## Programming Add-on

[ ] MISRA checker
[ ] Docker support

## AI

[X] AI Assistant (CodeCompanion + GitHub Copilot)

## Optimizations

[X] Check unused or redundant plugins  (see Plugin notes above)
[X] Optimize key mappings              (full tree refactor — see README Keymap Tree)
[X] Git double check (keep only useful stuff)


