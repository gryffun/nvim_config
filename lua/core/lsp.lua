local lspconfig = require("lspconfig")

local servers = { "lua_ls", "pyright", "omnisharp", "html", "cssls" }

for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end

