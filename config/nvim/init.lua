-- ~/.config/nvim/init.lua

-- Core configs
require("config.options")
require("config.keymaps")

-- Load lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugins (from lua/plugins.lua)
require("lazy").setup("plugins")

-- LSP configuration
require("config.lsp")
-- REMOVE: require("config.treesitter")
-- Treesitter is now configured inside plugins.lua via Lazy.nvim

