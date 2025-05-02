vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Array of file names indicating root directory. Modify to your liking.
local root_names = { ".git", "Makefile", "ROOTFILE.ROOTFILE" }

local set_root = function()
  -- Get directory path to start search from
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return
  end
  path = vim.fs.dirname(path)

  -- Search upward for root directory
  local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
  local root
  if root_file == nil then
    -- No root file found, set to user's home directory
    root = os.getenv "HOME"
  else
    root = vim.fs.dirname(root_file)
  end

  -- Set current directory
  vim.fn.chdir(root)
end

local root_augroup = vim.api.nvim_create_augroup("MyAutoRoot", {})
vim.api.nvim_create_autocmd("BufEnter", { group = root_augroup, callback = set_root })

local autocmd = vim.api.nvim_create_autocmd

-- autocmd({ "ModeChanged", "VimEnter" }, {
--   callback = function()
--     local current_mode = vim.fn.mode()
--     if current_mode == "n" then
--       vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#8aa872" })
--       vim.fn.sign_define("smoothcursor", { text = "" })
--     elseif current_mode == "v" then
--       vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#bf616a" })
--       vim.fn.sign_define("smoothcursor", { text = "" })
--     elseif current_mode == "V" then
--       vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#bf616a" })
--       vim.fn.sign_define("smoothcursor", { text = "" })
--     elseif current_mode == "�" then
--       vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#bf616a" })
--       vim.fn.sign_define("smoothcursor", { text = "" })
--     elseif current_mode == "i" then
--       vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#668aab" })
--       vim.fn.sign_define("smoothcursor", { text = "" })
--     end
--   end,
-- })

autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
  callback = function()
    local current_lang = vim.bo.filetype
    if current_lang == "tex" or current_lang == "md" then
      vim.o.conceallevel = 2
    else
      vim.o.conceallevel = 0
    end
  end,
})

autocmd("VimEnter", {
  command = ":silent !kitty @ set-spacing padding=0 margin=0",
})

autocmd("VimLeavePre", {
  command = ":silent !kitty @ set-spacing padding=20 margin=10",
})

-- autocmd("BufDelete", {
--   callback = function()
--     local bufs = vim.t.bufs
--     if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
--       require("snacks").dashboard()
--     end
--   end,
-- })

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

local highlight = {
  "RainbowRed",
  -- "RainbowOrange",
  "RainbowYellow",
  "RainbowGreen",
  -- "RainbowCyan",
  "RainbowBlue",
  "RainbowViolet",
}

local CurrentScope = {
  "CurrentScope",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  vim.api.nvim_set_hl(0, "CurrentScope", { fg = "#FFFFFF" })
end)

require("ibl").setup { indent = { highlight = highlight }, scope = { highlight = CurrentScope } }
