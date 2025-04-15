-- Import dependencies
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local cmp_nvim_lsp = require "cmp_nvim_lsp"

-- Extend capabilities with nvim-cmp support
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- LSP servers with default config
local servers = { "html", "cssls", "pyright", "clangd", "texlab", "bashls" }
vim.lsp.enable(servers)

-- Specific LSP configurations
-- Typescript (tsserver)
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

-- ltex
lspconfig.ltex.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,

  filetypes = { "tex", "md", "markdown" },
  settings = {
    ltex = {
      language = "en-AU",
    },
  },
}

-- Markdown with additional capabilities
lspconfig.markdown_oxide.setup {
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  }),
  on_attach = on_attach,
  on_init = on_init,
}
