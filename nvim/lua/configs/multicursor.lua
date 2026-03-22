local mc = require "multicursor-nvim"
local map = vim.keymap.set
mc.setup()

-- Add cursors above/below the main cursor.
map({ "n", "x" }, "<leader>k", function()
  mc.addCursor "k"
end)
map({ "n", "x" }, "<leader>j", function()
  mc.addCursor "j"
end)

-- Add a cursor and jump to the next word under cursor.
map({ "n", "x" }, "<leader>cw", function()
  mc.addCursor "*"
end)

-- Jump to the next word under cursor but do not add a cursor.
map({ "n", "x" }, "<leader>cW", function()
  mc.skipCursor "*"
end)

-- Rotate the main cursor.
map({ "n", "x" }, "<leader>L", mc.nextCursor)
map({ "n", "x" }, "<leader>H", mc.prevCursor)

-- Delete the main cursor.
map({ "n", "x" }, "<leader>cx", mc.deleteCursor)

-- Add and remove cursors with control + left click.
map("n", "<c-leftmouse>", mc.handleMouse)
map("n", "<c-leftdrag>", mc.handleMouseDrag)
map("n", "<c-leftrelease>", mc.handleMouseRelease)

map({ "n", "x" }, "<leader>cs", mc.toggleCursor)

map("n", "<leader>C", function()
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  elseif mc.hasCursors() then
    mc.clearCursors()
    vim.cmd "noh"
  end
end)

map({ "n", "x" }, "<leader>ca", mc.addCursorOperator)
map({ "n", "x" }, "<leader>cA", mc.operator)

-- Add a cursor and jump to the next/previous search result.
map("n", "<leader>/n", function()
  mc.searchAddCursor(1)
end)
map("n", "<leader>/N", function()
  mc.searchAddCursor(-1)
end)

-- Jump to the next/previous search result without adding a cursor.
map("n", "<leader>/s", function()
  mc.searchSkipCursor(1)
end)
map("n", "<leader>/S", function()
  mc.searchSkipCursor(-1)
end)

-- Add a cursor to every search result in the buffer.
map("n", "<leader>/A", mc.searchAllAddCursors)

-- Align cursor columns.
map("n", "<leader>A", mc.alignCursors)

-- Split visual selections by regex.
map("x", "S", mc.splitCursors)

-- Append/insert for each line of visual selections.
map("x", "I", mc.insertVisual)
map("x", "A", mc.appendVisual)

-- match new cursors within visual selections by regex.
map("x", "M", mc.matchCursors)

-- Rotate visual selection contents.
map("x", "<leader>t", function()
  mc.transposeCursors(1)
end)
map("x", "<leader>T", function()
  mc.transposeCursors(-1)
end)

-- Customize how cursors look.
local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { reverse = true })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn" })
hl(0, "MultiCursorMatchPreview", { link = "Search" })
hl(0, "MultiCursorDisabledCursor", { reverse = true })
hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
