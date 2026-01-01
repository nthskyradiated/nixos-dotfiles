-- ~/.config/nvim/lua/config/lsp.lua

local lspconfig = require("lspconfig")
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- List of LSP servers
local servers = {
    "ts_ls",        -- TypeScript/JS
    "gopls",        -- Go
    "svelte",       -- SvelteKit
    "yaml_ls",      -- YAML (Ansible, Kubernetes)
    "terraformls",  -- Terraform
    "dockerls",     -- Docker
    "jsonls",       -- JSON
    "lua_ls",       -- Lua (Neovim)
}

-- Generic on_attach function (optional, for keymaps)
local on_attach = function(client, bufnr)
    local buf_map = function(mode, lhs, rhs, desc)
        if desc then desc = "LSP: " .. desc end
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap=true, silent=true, desc=desc })
    end

    buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition")
    buf_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", "References")
    buf_map("n", "K",  "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover info")
    buf_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol")
end

-- Setup all servers
for _, server in ipairs(servers) do
    if server ~= "lua_ls" then
        lspconfig[server].setup({
            capabilities = cmp_capabilities,
            on_attach = on_attach,
        })
    end
end

-- Lua LSP special configuration for Neovim
lspconfig.lua_ls.setup({
    capabilities = cmp_capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

-- Optional: custom server overrides can be added here
-- For example, YAML settings:
lspconfig.yaml_ls.setup({
    capabilities = cmp_capabilities,
    on_attach = on_attach,
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
            },
        },
    },
})

