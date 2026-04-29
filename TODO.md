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
[X] More mini plugins
[X] Hologram.nvim — dropped, not pursuing (inline image rendering not a priority)
[ ] Edgy templates for each type of Supported Language (with [edge-group.vim](https://github.com/lucobellic/edgy-group.nvim)?) — tracked in plan.md step 16
[X] Evaluate placing back overseer
[X] Evaluate introducing neotest

### Plugin notes

- **showkeys**: Recording mode toggle (`<leader>uK`). Simultaneously toggles key display and sends OSC escape to WezTerm to zoom font size. Implemented in `plugins/utils/showkeys.lua`.

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


