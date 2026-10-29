local config = vim.g

config.vimtex_view_method = "zathura_simple"

vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventViewReverse",
  callback = function()
    local window_id = vim.env.WINDOWID
    if window_id and window_id:match("^%d+$") then
      vim.fn.jobstart({ "/opt/homebrew/bin/yabai", "-m", "window", "--focus", window_id })
    end
  end,
})
config.vimtex_mappings_prefix = "<leader>l"
config.tex_flavor = "latex"
config.vimtex_quickfix_mode = 2
config.vimtex_syntax_enabled = 1
-- config.vimtex_syntax_enabled = 0
-- config.vimtex_syntax_conceal_disable = 1

config.vimtex_syntax_conceal = {
  accents = 1,
  ligatures = 1,
  cites = 1,
  fancy = 1,
  spacing = 0,
  greek = 1,
  math_bounds = 1,
  math_delimiters = 1,
  math_fracs = 1,
  math_super_sub = 1,
  math_symbols = 1,
  sections = 0,
  styles = 1,
}

config.vimtex_compiler_latexmk = {
  aux_dir = ".tmp",
  out_dir = "",
  callback = 1,
  continuous = 1,
  executable = "latexmk",
  hooks = {},
  options = {
    "-verbose",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}

config.vimtex_compiler_latexmk_engines = {
  _ = "-lualatex",
}
