local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    markdown = { "markdownlint" },
    python = { "black" },
    cpp = { "clang-format" },
    latex = { "latexindent" },
    zsh = { "beautysh", timeout_ms = 2000 },
    tex = { "latexindent", timeout_ms = 2000 },
    java = { "google-java-format", timeout_ms = 3500 },
    json = { "prettier" },
    bib = { "bibtex-tidy" },
    yaml = { "prettier" },
  },
  -- format_on_save = {
  --   -- I recommend these options. See :help conform.format for details.
  --   lsp_format = "fallback",
  --   timeout_ms = 500,
  -- },
}

require("conform").setup(options)

require("conform").formatters.latexindent = {
}
