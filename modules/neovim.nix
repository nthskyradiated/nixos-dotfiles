# Method 1: As a module (neovim.nix)
# Save this file as: ~/nixos-config/modules/neovim.nix (or similar path)
# Then import it in your home.nix with: imports = [ ./modules/neovim.nix ];

{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = false;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Theme
      tokyonight-nvim

      # Telescope and dependencies
      telescope-nvim
      telescope-fzf-native-nvim
      plenary-nvim

      # Harpoon
      harpoon2

      # Treesitter
      (nvim-treesitter.withPlugins (p: [
        p.typescript
        p.javascript
        p.tsx
        p.go
        p.terraform
        p.json
        p.yaml
        p.lua
        p.vim
        p.markdown
      ]))

      # LSP
      nvim-lspconfig
      
      # Autocompletion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip

      # Useful plugins
      zen-mode-nvim
      which-key-nvim
      nvim-web-devicons
      lualine-nvim
      gitsigns-nvim
      comment-nvim
    ];

    extraPackages = with pkgs; [
      # LSP servers
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      gopls
      terraform-ls
      yaml-language-server
      
      # Formatters and tools
      nodePackages.prettier
      stylua
      
      # Telescope dependencies
      ripgrep
      fd
    ];

    extraLuaConfig = ''
      -- Leader key
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.mouse = 'a'
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = false
      vim.opt.wrap = false
      vim.opt.breakindent = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.termguicolors = true
      vim.opt.signcolumn = 'yes'
      vim.opt.updatetime = 250
      vim.opt.timeoutlen = 300
      vim.opt.completeopt = 'menu,menuone,noselect'

      -- Theme
      require('tokyonight').setup({
        style = 'storm',
        transparent = true,
      })
      vim.cmd('colorscheme tokyonight-storm')

      -- Lualine
      require('lualine').setup({
        options = {
          theme = 'tokyonight',
          component_separators = '|',
          section_separators = ' ',
        },
      })

      -- Gitsigns
      require('gitsigns').setup()

      -- Comment
      require('Comment').setup()

      -- Treesitter
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
        indent = { enable = true },
      })

      -- LSP Configuration
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Keymaps for LSP
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })

      -- LSP servers using new vim.lsp.config API
      vim.lsp.config('ts_ls', {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
        capabilities = capabilities,
      })

      vim.lsp.config('gopls', {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.work', 'go.mod' },
        capabilities = capabilities,
      })

      vim.lsp.config('terraformls', {
        cmd = { 'terraform-ls', 'serve' },
        filetypes = { 'terraform', 'tf' },
        root_markers = { '.terraform', '.git' },
        capabilities = capabilities,
      })

      vim.lsp.config('jsonls', {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        capabilities = capabilities,
      })

      vim.lsp.config('yamlls', {
        cmd = { 'yaml-language-server', '--stdio' },
        filetypes = { 'yaml', 'yaml.docker-compose' },
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = {
              kubernetes = "*.yaml",
            },
          },
        },
      })

      -- Enable LSP servers
      vim.lsp.enable({ 'ts_ls', 'gopls', 'terraformls', 'jsonls', 'yamlls' })

      -- Autocompletion
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })

      -- Telescope
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      })

      telescope.load_extension('fzf')

      -- Telescope keymaps
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
      vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Document symbols' })

      -- Harpoon
      local harpoon = require('harpoon')
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon add' })
      vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })
      vim.keymap.set('n', '<C-h>', function() harpoon:list():select(1) end, { desc = 'Harpoon 1' })
      vim.keymap.set('n', '<C-j>', function() harpoon:list():select(2) end, { desc = 'Harpoon 2' })
      vim.keymap.set('n', '<C-k>', function() harpoon:list():select(3) end, { desc = 'Harpoon 3' })
      vim.keymap.set('n', '<C-l>', function() harpoon:list():select(4) end, { desc = 'Harpoon 4' })

      -- Zen Mode
      require('zen-mode').setup()
      vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<CR>', { desc = 'Toggle Zen Mode' })

      -- Which-key
      require('which-key').setup()

      -- General keymaps
      -- vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save' })
      vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
      vim.keymap.set('n', '<leader>cd', '<cmd>Ex<CR>', { desc = 'Explorer' })
      
      -- Window navigation
      vim.keymap.set('n', '<C-Left>', '<C-w>h', { desc = 'Window left' })
      vim.keymap.set('n', '<C-Down>', '<C-w>j', { desc = 'Window down' })
      vim.keymap.set('n', '<C-Up>', '<C-w>k', { desc = 'Window up' })
      vim.keymap.set('n', '<C-Right>', '<C-w>l', { desc = 'Window right' })

      -- Better indenting
      vim.keymap.set('v', '<', '<gv')
      vim.keymap.set('v', '>', '>gv')

      -- Move lines
      vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
      vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
      vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move lines down' })
      vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move lines up' })
    '';
  };
}
