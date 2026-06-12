# Session History

← [Back to plan.md](plan.md)

## Context

> Replacing JetBrains IDEs (CLion / WebStorm / PHPStorm) with Neovim + OpenCode + WezTerm pane system.
> Target languages: bash, C/C++ (CLion), CMake, Docker, JavaScript/TypeScript (WebStorm), Lua, Markdown, PHP (PHPStorm), Rust (CLion), YAML.

## Sessions

- **2026-04-17** — Initial plan
- **2026-04-20** — Added `fugit2.nvim`, LuaSnip snippet templates
- **2026-04-25** — Added `mini.move`, `mini.map`, Docker support, MISRA/cppcheck; logged `edgy-group.nvim` as a planned next step
- **2026-04-28** — Added `mini.trailspace`, `mini.comment`
- **2026-04-29** — Updated edgy DAP listeners note; split plan into separate files
- **2026-04-30** — Full config audit (lang files, LSP, formatters, linters, testing, tasks). Removed `vim-visual-multi` (conflict risk, low usage). Deferred LuaSnip custom snippets (friendly-snippets sufficient). Added `neotest-jest` (Electron+React Jest gap). Added `cmakelint` Mason fix (silent install failure). Confirmed: neotest, overseer, CMake, navic all already covered.
- **2026-05-03** — Steps 9–14, 17, 19 completed: `grug-far` toggle fix (`toggle_instance` + `with_visual_selection`, internal keymap remap); `nvim-treesitter-context`; bacon auto-start; `dropbar.nvim` (`<leader>cB`); `neotest-jest` (per-lang in `javascript.lua`); `mini.statusline` enriched (LSP progress + macro indicator); `cmakelint` Mason fix; colorscheme persistence restored (`lazy_setup`, snacks hook, removed `colorsaver.nvim`). Architecture fixes: neotest adapter plugins moved back to per-language files, themes restored to `themes.lua` via `lazy_setup`, Telescope dependency removed from dropbar. `<leader>cb` conflict resolved (dropbar moved to `<leader>cB`). All docs synced.
- **2026-05-05** — Step 15 completed: integrated `edgy-group.nvim` into `windowmanager.lua`, added ft-scoped group orchestration (`nautilus.custom.edgy-groups`), mapped `<leader>uE` to per-buffer cycle including `default`, added explorer left-edge slot for deterministic baseline, and wired DAP listeners to open/restore right-pane groups through edgy-group.
- **2026-05-16** — Agents-as-markdown system: `prompts/init.lua` YAML frontmatter parser + role section parser; 6 new agent `.md` files (explain, fix, refactor, tests, diagnose, review-hunk); `<leader>aa` agent picker (vim.ui.select → `codecompanion.prompt()`); deleted `ai-commands.lua` + removed leftover `<leader>a*` keymaps (ae/af/ar/at/ad/ah). `README.md` and `plans/workflow-and-ux.md` synced.
- **2026-05-16** (continued) — Doc alignment pass: fixed TODO.md (remote-sshfs marked done, added HTML/CSS/JSON to lang list); created `plugins/lang/html.lua` + `plugins/lang/json.lua` (were missing, LSP wouldn't activate); removed stale `telescope = true` from catppuccin integrations in `themes.lua`; fixed misleading Telescope comment in `editing.lua`; added `K` hover, `<leader>un`, and HTML/CSS/JSON rows to README; removed duplicate `<leader>wr` from window table.
- **2026-06-03** — Workflow MVP pass: added run/debug preset registry (`custom/run-registry.lua`) with Snacks picker (`<leader>dr`, `<leader>dR`); added compound pipelines (`custom/pipeline-registry.lua`) with fail-fast sequential Overseer execution (`<leader>op`, `<leader>oP`); added inspection profiles (`strict/normal/fast`) with command + picker (`:InspectionProfile`, `<leader>uI`) and profile-driven lint trigger behavior; added command-only `:WorkspaceHealth` baseline report; added command aliases `:RunDebugPreset`, `:RunPipeline`, `:AgentActions`; reassigned Rust debuggables to `<leader>dG` and DAP REPL to `<leader>dq` to avoid keymap conflicts; docs synced.
- **2026-06-03** (continued) — Phase 2 workflow pass: added command palette aliases via `custom/command-aliases.lua` with `:Action` + `<leader>pa`; hardened `:WorkspaceHealth` with PASS/WARN/FAIL buckets, Mason package checks, treesitter parser checks, external tool checks, and remediation hints; expanded inspection profile effects beyond lint frequency by wiring profile-specific diagnostic behavior (`update_in_insert`, `virtual_text`) through `lsp.lua` via user event propagation.
- **2026-06-03** (continued) — Step 26 completed: introduced template registry/engine (`custom/template-registry.lua`, `custom/template-engine.lua`), added `:TemplateNew` + `<leader>pt`, wired template action alias, and shipped initial templates (Node JS package, Electron Forge + React JS forge-first scaffold + patch, CMake C++ app, Rust bin via `cargo new` + patch). All gates validated with dry-run + real scaffold smoke tests and final regression checks.
- **<PII type="DATE" id="39"/>** — Steps 27–34 completed: Template v2 improvements (overwrite strategy, smoke-run + hooks, per-template health checks); per-project inspection profile persistence (.nvim-inspection-profile); WorkspaceHealth v2 (auto-remediation via :WorkspaceHealthFix); expanded run/debug presets (Docker, CMake, Lua, HTML, CSS, JSON, YAML, Markdown); expanded pipelines (PHP, Docker, C/C++, Lua, JS full CI); QuickHelp command + action palette entry. All TODO.md items resolved, plans synced.

---

## Completed Execution Steps

1. ~~Plugin cleanup: remove `vim-pencil` (+ add `linebreak` to `commands.lua`), fix FeMaco setup, comment out 3 themes, extend `showkeys` as recording mode (+ WezTerm font-size handler)~~ ✓
2. ~~Fix `edgy.nvim`: remove `optional = true`, add `<leader>ue` global toggle, restore and lifecycle-wire DAP panels via `dap.listeners`, add per-language panel visibility autocmds~~ ✓
3. ~~Fix catppuccin navic dead config~~ ✓ _(fixed as side effect of step 1 — `navic = { enabled = false }` set in `ui.lua`)_
4. ~~LSP QoL: intelephense enrichment, C/C++ + Lua inlay hints, bash settings, global hover styling~~ ✓
5. ~~Add clangd header/source switch: `<leader>ch` keymap in `lsp.lua` `LspAttach` callback gated on `client.name == "clangd"`~~ ✓
6. ~~Add `smart-splits.nvim` + replace `<C-hjkl>` navigation and `<A-hjkl>` resize keymaps~~ ✓
7. ~~Add `mini.move` (depends on step 6 freeing `<A-hjkl>`) + `mini.map` + `mini.trailspace` + `mini.comment` (replaces commented-out Comment.nvim); remove Comment.nvim dead code from `editing.lua`~~ ✓
8. ~~Add `fugit2.nvim` + `diffview.nvim` (both go into `plugins/git.lua`, one commit)~~ ✓
9. ~~Add `grug-far.nvim` to `plugins/editing.lua`; toggle fix with `toggle_instance`; visual mode `with_visual_selection`; internal keymaps remapped~~ ✓
10. ~~Add `nvim-treesitter-context` to `plugins/treesitter.lua`~~ ✓
11. ~~Bacon auto-start autocmd in `plugins/lang/rust.lua`~~ ✓
12. ~~Add `dropbar.nvim` to `plugins/ui/dropbar.lua`; breadcrumb picker `<leader>cB`~~ ✓
13. ~~Add `neotest-jest` to `plugins/lang/javascript.lua`; factory in `testing.lua`; registry updated~~ ✓
14. ~~Enrich `mini.statusline`: LSP progress + macro recording indicator~~ ✓
15. ~~Finalize `edgy-group.nvim` as minimal baseline layout + deterministic pane placement~~ ✓
16. ~~Add Docker language support~~ ✓
17. ~~Fix `cmakelint` Mason package name in `lang-registry.lua`~~ ✓
18. ~~Add C/C++ MISRA linting via `cppcheck`~~ ✓
19. ~~Colorscheme persistence: restore `lazy_setup` in `themes.lua`, wire snacks confirm, remove `colorsaver.nvim`, clean `functions.lua`~~ ✓
20. ~~Template overwrite strategy (abort/merge/backup) + per-project .nvim-inspection-profile~~ ✓
21. ~~Generic smoke-run + post_create_hooks for all templates~~ ✓
22. ~~WorkspaceHealth auto-remediation (:WorkspaceHealthFix) + per-template health checks~~ ✓
23. ~~Expanded run/debug presets: Docker, CMake, Lua, HTML, CSS, JSON, YAML, Markdown~~ ✓
24. ~~Expanded pipelines: PHP, Docker, C/C++, Lua, JavaScript full CI~~ ✓
25. ~~QuickHelp command + action palette entry~~ ✓
