-- lua/core/lsp.lua
local M = {}

M.on_attach = function(_, bufnr)
  local nmap = function(keys, fn, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
  end

  -- 2) Your LSP keymaps
  nmap("gd", vim.lsp.buf.definition,       "[G]oto [D]efinition")
  nmap("gD", vim.lsp.buf.declaration,      "[G]oto [D]eclaration")
  nmap("gr", vim.lsp.buf.references,       "[G]oto [R]eferences")
  nmap("gi", vim.lsp.buf.implementation,   "[G]oto [I]mplementation")
  nmap("K",  vim.lsp.buf.hover,            "Hover Documentation")
  nmap("<leader>rn", vim.lsp.buf.rename,   "[R]e[n]ame Symbol")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  nmap("<leader>f", vim.lsp.buf.format,    "[F]ormat Buffer")
end

local servers = {
  "lua_ls",
  "pyright",
  "ts_ls",
  "omnisharp",
  "html",
  "cssls",
}

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true,
})

local lspconfig = require("lspconfig")
local coq = require("coq")
local util = require("lspconfig.util")

local addons_path = vim.fn.stdpath("data")
  .. "/lsp_servers/lua_ls/meta/3rd/LLS-Addons/meta/3rd/love2d"

for _, name in ipairs(servers) do
  local opts = {
    on_attach = M.on_attach,
  }

  if name == "lua_ls" then
    local runtime_files = vim.api.nvim_get_runtime_file("", true)
    local lib = {}

    for _, path in ipairs(runtime_files) do
        lib[path] = true
    end
    lib[addons_path] = true

    opts.settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "love" } },
        workspace = { library = lib },
      },
    }
  elseif name == "omnisharp" then
    opts.cmd = {
      "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()),
      "--solution-path", util.root_pattern("*.sln")(vim.fn.getcwd())
    }
    opts.root_dir = util.root_pattern("project.godot","*.sln")
  end

  lspconfig[name].setup(coq.lsp_ensure_capabilities(opts))
end
vim.cmd("COQnow [--shut-up]")

return M

