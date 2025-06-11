# NAUTILUS Theme

This is the full list of modifications required to have all the configuration for nvim
ready and going.

## Pre-Requisites (OSX)

There are a couple of things this configuration is based on:

- iTerm2/Wezterm terminal
- Nerd font: `brew install font-meslo-lg-nerd-font` and the select Meslo LGS Nerd Font Mono on iTerm2 profile
- Nerd font: `brew install font-jetbrains-mono-nerd-font`
- brew install ripgrep
- brew install rg
- brew install fzf
- brew install xclip
- npm install -g @mermaid-js/mermaid-cli (to fully support snacks.images)

### Grammars

- brew install tree-sitter (to support treesitter automatic installation of parsers

### Linters

- (clang-tidy) Install llvm

```
brew install llvm
ln -s "$(brew --prefix llvm)/bin/clang-format" "/usr/local/bin/clang-format"
ln -s "$(brew --prefix llvm)/bin/clang-tidy" "/usr/local/bin/clang-tidy"
```

- Rust: ensure adding the rust-analyzer if not present by running `rustup component add rust-analyzer`

## Post-Install (OSX)

- Update the .zshrc placing the EDITOR as nvim

## Uninstall

If you need to uninstall everything, follow the [Lazy uninstalling guide](https://github.com/folke/lazy.nvim#-uninstalling)
