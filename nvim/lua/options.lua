require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "number" -- to enable cursorline!

o.spelllang = "en_gb"
o.relativenumber = true
o.number = true
o.termguicolors = true

o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.g.codeium_disable_bindings = 1
vim.fn.sign_define('DapBreakpoint',{ text ='🔴', texthl ='', linehl ='', numhl =''})
vim.fn.sign_define('DapStopped',{ text ='🟢', texthl ='', linehl ='', numhl =''})
