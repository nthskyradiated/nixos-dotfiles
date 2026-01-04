# Neovim LSP configuration
''
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
''
