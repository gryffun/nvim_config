local M = {}

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = "rounded",
    focusable = false,
    relative = "cursor",
    row_offset = 1,
  }
)

M.on_attach = function(_, bufnr)
  -- your existing nmap helper...
  local nmap = function(keys, fn, desc)
    if desc then desc = "LSP: " .. desc end
    vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
  end

  require("lsp_signature").on_attach({
    bind = true,
    handler_opts = { border = "rounded" },
  }, bufnr)

  -- your existing keymaps…
  nmap("gd", vim.lsp.buf.definition,       "[G]oto [D]efinition")
  nmap("gD", vim.lsp.buf.declaration,      "[G]oto [D]eclaration")
  nmap("gr", vim.lsp.buf.references,       "[G]oto [R]eferences")
  nmap("gi", vim.lsp.buf.implementation,   "[G]oto [I]mplementation")
  nmap("K",  vim.lsp.buf.hover,            "Hover Documentation")
  nmap("<leader>rn", vim.lsp.buf.rename,   "[R]e[n]ame Symbol")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
end

-- add cmp_nvim_lsp capabilities
local caps = vim.lsp.protocol.make_client_capabilities()
caps = require("cmp_nvim_lsp").default_capabilities(caps)

local servers = {
  "lua_ls", "pyright", "ts_ls", "omnisharp", "html", "cssls",
}

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed   = servers,
  automatic_installation = true,
})

local lspconfig = require("lspconfig")
local util = lspconfig.util

for _, name in ipairs(servers) do
  local opts = {
    on_attach = M.on_attach,
    capabilities = caps,
  }

  if name == "lua_ls" then
    -- your existing lua_ls settings…
    local runtime_files = vim.api.nvim_get_runtime_file("", true)
    local lib = {}
    for _, p in ipairs(runtime_files) do lib[p] = true end
    opts.settings = {
      Lua = {
        runtime   = { version = "LuaJIT" },
        diagnostics = { globals = { "vim", "love" } },
        workspace    = { library = lib },
      },
    }
  end

  if name == "omnisharp" then
    opts.cmd = {
      "omnisharp", "--languageserver", "--hostPID",
      tostring(vim.fn.getpid()),
      "--solution-path", util.root_pattern("*.sln")(vim.fn.getcwd()),
    }
    opts.root_dir = util.root_pattern("project.godot", "*.sln")
  end

  lspconfig[name].setup(opts)
end

return M
