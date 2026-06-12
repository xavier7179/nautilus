# JetBrains Replacement Plan

> Replacing JetBrains IDEs (CLion / WebStorm / PHPStorm) with Neovim + OpenCode + WezTerm.
> Target languages: bash, C/C++, CMake, Docker, JavaScript/TypeScript, Lua, Markdown, PHP, Rust, YAML.

See [history.md](history.md) for session log and completed steps 1–8.

---

## Active Steps

| # | Task | Detail |
|---|------|--------|
| ~~9~~ | ~~Add `grug-far.nvim`~~ | ✓ done |
| ~~10~~ | ~~Add `nvim-treesitter-context`~~ | ✓ done |
| ~~11~~ | ~~Add bacon auto-start autocmd~~ | ✓ done |
| ~~12~~ | ~~Add `dropbar.nvim`~~ | ✓ done |
| ~~13~~ | ~~Add `neotest-jest` adapter for JS/TS~~ | ✓ done |
| ~~14~~ | ~~Enrich `mini.statusline`~~ | ✓ done |
| ~~15~~ | ~~Finalize `edgy-group.nvim` as minimal baseline layout + deterministic pane placement~~ | ✓ ABANDONED — edgy/edgy-group removed; layout via snacks + dapui |
| ~~16~~ | ~~Add Docker language support~~ | ✓ done |
| ~~17~~ | ~~Fix `cmakelint` Mason package entry~~ | ✓ done |
| ~~18~~ | ~~Add C/C++ MISRA linting via `cppcheck`~~ | ✓ done |
| ~~19~~ | ~~Colorscheme persistence overhaul~~ | ✓ done (restored `lazy_setup` + snacks confirm hook) |
| ~~20~~ | ~~Add run/debug configuration registry~~ | ✓ done (MVP) |
| ~~21~~ | ~~Add compound task pipelines~~ | ✓ done (MVP) |
| ~~22~~ | ~~Add inspection profiles (strict/normal/fast)~~ | ✓ done (MVP) |
| ~~23~~ | ~~Add workspace health command~~ | ✓ done (MVP) |
| ~~24~~ | ~~Add structured AI workflow commands~~ | ✓ done |
| ~~25~~ | ~~Add command-palette aliases~~ | ✓ done |
| ~~26~~ | ~~Add language/project templates & wizards~~ | ✓ done |

> **Removed from plan:**
| ~~27~~ | ~~Template overwrite strategy (abort/merge/backup)~~ | ✓ done |
| ~~28~~ | ~~Generic smoke-run + post-create hooks~~ | ✓ done |
| ~~29~~ | ~~Per-project inspection profile persistence~~ | ✓ done |
| ~~30~~ | ~~WorkspaceHealth auto-remediation (:WorkspaceHealthFix)~~ | ✓ done |
| ~~31~~ | ~~Per-template health checks~~ | ✓ done |
| ~~32~~ | ~~Debug presets: Docker, CMake, Lua, HTML, CSS, JSON, YAML, Markdown~~ | ✓ done |
| ~~33~~ | ~~Pipelines: PHP, Docker, C/C++, Lua, JS full CI~~ | ✓ done |
| ~~34~~ | ~~QuickHelp command + action palette entry~~ | ✓ done |

> **Removed from plan:**
> - ~~step 13~~ `vim-visual-multi` — conflict risk with `mini.*` + `flash` outweighs low usage frequency; `gn` + `.` repeat covers occasional multi-cursor needs
> - ~~step 14~~ LuaSnip custom snippets — deferred indefinitely; `friendly-snippets` already covers Electron/React/Rust/PHP patterns; revisit only if gaps emerge in practice

---

## All Detail Files

| File | Contents |
|------|---------|
| [plugins-to-add.md](plugins-to-add.md) | Pending plugins (High / Medium / Low priority) |
| [language-support.md](language-support.md) | Language support tracking (Docker done) |
| [bugs-and-fixes.md](bugs-and-fixes.md) | Broken config fixes + LSP QoL |
| [workflow-and-ux.md](workflow-and-ux.md) | IDE workflow parity features (run/debug/tasks/AI/health/templates) |
| [plugin-cleanup.md](plugin-cleanup.md) | Plugin cleanup notes |
| [archive.md](archive.md) | All completed items |
| [history.md](history.md) | Session log + completed steps 1–8 |
