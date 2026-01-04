# Neovim Treesitter configuration
{ pkgs, ... }:

''
  -- Treesitter
  require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    indent = { enable = true },
  })
''
