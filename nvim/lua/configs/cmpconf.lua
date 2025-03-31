local cmp = require "cmp"
local luasnip = require "luasnip"

local options = {
  completion = { completeopt = "menu,menuone" },

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- Use luasnip for snippet expansion
    end,
  },

  -- window = {
  --   completion = cmp.config.window.bordered(),
  --   documentation = cmp.config.window.bordered(),
  -- },

  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4), -- Scroll docs up
    ["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll docs down
    ["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
    ["<C-e>"] = cmp.mapping.close(), -- Close completion menu

    -- ["<CR>"] = cmp.mapping.confirm {
    --   behavior = cmp.ConfirmBehavior.Insert,
    --   select = true,
    -- },

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<CR>"] = cmp.mapping {
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm { behavior = cmp.ConfirmBehavior.Insert, select = false }
        elseif luasnip.expandable() then
          luasnip.expand() -- Expand snippet using luasnip
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm { select = true },
      c = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
    },
  },

  sources = {
    { name = "nvim_lsp" }, -- Source from LSP
    { name = "luasnip" }, -- Source for snippets using luasnip
    { name = "buffer" }, -- Source from current buffer
  },
}

return vim.tbl_deep_extend("keep", options, require "nvchad.cmp")
