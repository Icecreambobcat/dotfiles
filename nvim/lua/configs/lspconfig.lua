-- Import dependencies
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
require("nvchad.configs.lspconfig").defaults()

-- local lspconfig = require "lspconfig"
-- local cmp_nvim_lsp = require "cmp_nvim_lsp"

-- Extend capabilities with nvim-cmp support
-- capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- LSP servers with default config
local servers = { "html", "cssls", "pyright", "clangd", "texlab", "bashls", "markdown_oxide", "ts_ls" }
-- local servers = { "html", "cssls", "pyright", "clangd", "texlab", "bashls", "ltex", "markdown_oxide", "ts_ls" }

-- Specific LSP configurations
-- Typescript (tsserver)
vim.lsp.config("ts_ls", {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})

-- ltex
-- vim.lsp.config("ltex", {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
--
--   filetypes = { "tex", "md", "markdown" },
--   settings = {
--     ltex = {
--       language = "en-AU",
--     },
--   },
-- })

-- Markdown with additional capabilities
vim.lsp.config("markdown_oxide", {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  }),
})

vim.lsp.enable(servers)
