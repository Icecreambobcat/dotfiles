require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

for i = 1, 9 do
  map("n", "<C-" .. i .. ">", i .. "gt", { desc = "Switch to buffer " .. i })
end

map("n", "<leader>sp", "<cmd> set spell! <cr>", { desc = "Toggle spell check" })

local focusmap = function(direction)
  map("n", "z" .. direction, function()
    require("focus").split_command(direction)
  end, { desc = string.format("Create or move to split (%s)", direction) })
end

-- Use `zh` to split the screen to the left, same as command FocusSplitLeft etc
focusmap "h"
focusmap "j"
focusmap "k"
focusmap "l"

map("n", "<Leader>ww", function()
  require("focus").split_nicely()
end, { desc = "Split nicely" })

map("n", "<Leader>M", "<cmd>FocusMaxOrEqual<CR>", { desc = "Toggle Maximise" })
map("n", "<Leader>R", "<cmd>FocusAutoresize<CR>", { desc = "GR tiling" })
map("n", "<Leader>wd", "<c-w><c-q>", { desc = "Close focused window" })

map("n", "<Leader>cm", "<cmd>CompilerOpen<CR>", { desc = "Open compiler" })
map("n", "<Leader>ct", "<cmd>CompilerToggleResults<CR>", { desc = "Toggle compiler results" })
map("n", "<Leader>cr", "<cmd>CompilerRedo<CR>", { desc = "Redo last compiler job" })
map("n", "<Leader>cS", "<cmd>CompilerStop<CR>", { desc = "Stop compiler" })

map("n", "<Leader>q", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug toggle bp" })

map("n", "<Leader>a", function()
  require("dap").continue()
end, { desc = "Debug Continue" })

map("n", "<Leader>o", function()
  require("dap").step_over()
end, { desc = "Debug step over" })

map("n", "<Leader>i", function()
  require("dap").step_into()
end, { desc = "Debug step into" })

map("n", "<Leader>p", function()
  require("dap").step_out()
end, { desc = "Debug step out" })

map("n", "<Leader>u", function()
  require("dap").step_back()
end, { desc = "Debug step back" })

map("n", "<Leader>da", function()
  require("dapui").toggle()
end, { desc = "Debug ui toggle" })

-- toggleable
map({ "n", "t" }, "<A-=>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-]>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-[>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })
