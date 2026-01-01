-- ~/.config/nvim/lua/config/keymaps.lua
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader
vim.g.mapleader = " "

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

-- Harpoon
keymap("n", "<leader>ha", function() require("harpoon.mark").add_file() end, opts)
keymap("n", "<leader>hm", function() require("harpoon.ui").toggle_quick_menu() end, opts)
keymap("n", "<leader>h1", function() require("harpoon.ui").nav_file(1) end, opts)
keymap("n", "<leader>h2", function() require("harpoon.ui").nav_file(2) end, opts)

-- LSP
keymap("n", "gd", vim.lsp.buf.definition, opts)
keymap("n", "K", vim.lsp.buf.hover, opts)
keymap("n", "gi", vim.lsp.buf.implementation, opts)
keymap("n", "gr", vim.lsp.buf.references, opts)
keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)

-- Formatting
keymap("n", "<leader>f", "<cmd>Format<cr>", opts)

