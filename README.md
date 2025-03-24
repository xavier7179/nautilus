# NAUTILUS Theme

This is the full list of modifications required to have all the configuration for nvim
ready and going.

## Pre-Requisites (OSX)

There are a couple of things this configuration is based on:

- iTerm2 terminal
- Nerd font: `brew install font-meslo-lg-nerd-font` and the select Meslo LGS Nerd Font Mono on iTerm2 profile
- brew install ripgrep
- brew install rg

### Linters

- (clang-tidy) Install llvm

```
brew install llvm
ln -s "$(brew --prefix llvm)/bin/clang-format" "/usr/local/bin/clang-format"
ln -s "$(brew --prefix llvm)/bin/clang-tidy" "/usr/local/bin/clang-tidy"
```

## Post-Install (OSX)

- Update the .zshrc placing the EDITOR as nvim

## Uninstall

If you need to uninstall everything, follow the [Lazy uninstalling guide](https://github.com/folke/lazy.nvim#-uninstalling)
