# TODO

All items completed. See [plans/archive.md](plans/archive.md) for historical context and completed feature log.

- [x] Language registry architecture (`lang-registry.lua` + `lang.lua`) as single source of truth
- [x] Core language support stack (LSP/format/lint/debug/test/tasks for supported languages)
- [x] Run/Debug presets
- [x] Compound task pipelines
- [x] Inspection profiles (strict / normal / fast)
- [x] Workspace health command
- [x] Action palette (`:Action`) with launcher (`<leader>pa`)
- [x] Templates/wizards command (`:TemplateNew`) with launcher (`<leader>pt`)
- [x] Node JS package template
- [x] Electron Forge + React JS template (forge-first + patch)
- [x] CMake C++ template
- [x] Rust binary template (`cargo new` + patch)
- [x] Templates v2: safer overwrite/merge behavior (abort/merge/backup strategies)
- [x] Templates v2: richer post-create patching (generic post_create_hooks system)
- [x] Templates v2: optional smoke-run profiles per template (generic smoke_run per template)
- [x] WorkspaceHealth v2: stronger remediation output (auto-fix with :WorkspaceHealthFix)
- [x] WorkspaceHealth v2: per-template checks (health_check per template)
- [x] Inspection profile v2: per-project persistence/override (.nvim-inspection-profile)
- [x] Run/debug presets: Docker, CMake, Lua, HTML, CSS, JSON, YAML, Markdown
- [x] Pipelines: PHP, Docker, C/C++, Lua, JavaScript full CI
- [x] Command discoverability polish (QuickHelp command + action palette entry)
