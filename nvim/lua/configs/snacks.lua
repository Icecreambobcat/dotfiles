local Snacks = require "snacks"
require("snacks").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  bigfile = { enabled = false },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  words = {
    enabled = true,
    debounce = 50,
    modes = { "n", "c" },
  },
  dashboard = {
    width = 80,
    preset = {
      keys = {
        { icon = " ", key = "<spc>ff", desc = "Telescope find files", action = "<space>ff" },
        { icon = " ", key = "<spc>fo", desc = "Telescope oldfiles", action = "<space>fo" },
        { icon = "󰈭 ", key = "<spc>fw", desc = "Telescope live grep", action = "<space>fw" },
        { icon = "󱥚 ", key = "<spc>th", desc = "Telescope themes", action = "<space>th" },
        { icon = " ", key = "<spc>ch", desc = "Cheatsheet", action = "<space>ch" },
        { icon = " ", key = "<spc>fs", desc = "Session search", action = "<space>fs" },
        { icon = " ", key = "<spc>sd", desc = "Session delete", action = "<space>ds" },
      },
      header = [[
██████╗ ██╗ ██████╗███████╗                                
██╔══██╗██║██╔════╝██╔════╝                                
██████╔╝██║██║     █████╗                                  
██╔══██╗██║██║     ██╔══╝                                  
██║  ██║██║╚██████╗███████╗                                
╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝                                

                ██████╗ ██╗ ██████╗███████╗                
                ██╔══██╗██║██╔════╝██╔════╝                
                ██████╔╝██║██║     █████╗                  
                ██╔══██╗██║██║     ██╔══╝                  
                ██║  ██║██║╚██████╗███████╗                
                ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝                

                                ██████╗ ██╗ ██████╗███████╗
                                ██╔══██╗██║██╔════╝██╔════╝
                                ██████╔╝██║██║     █████╗  
                                ██╔══██╗██║██║     ██╔══╝  
                                ██║  ██║██║╚██████╗███████╗
                                ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝
      ]],
    },
    sections = {
      { section = "header" },
      {
        pane = 2,
        section = "terminal",
        cmd = "pokemon-colorscripts -n vaporeon --no-title ; sleep .1",
        height = 16,
        padding = 1,
      },
      { section = "keys", gap = 3, padding = 1 },
      {
        pane = 2,
        icon = " ",
        desc = "Browse Repo",
        padding = 1,
        key = "b",
        action = function()
          Snacks.gitbrowse()
        end,
      },
      function()
        local in_git = Snacks.git.get_root() ~= nil
        local cmds = {
          {
            title = "Notifications",
            cmd = "gh notify -s -a -n5",
            action = function()
              vim.ui.open "https://github.com/notifications"
            end,
            key = "n",
            icon = " ",
            height = 5,
            enabled = true,
          },
          {
            title = "Open Issues",
            cmd = "gh issue list -L 3",
            key = "i",
            action = function()
              vim.fn.jobstart("gh issue list --web", { detach = true })
            end,
            icon = " ",
            height = 7,
          },
          {
            icon = " ",
            title = "Open PRs",
            cmd = "gh pr list -L 3",
            key = "P",
            action = function()
              vim.fn.jobstart("gh pr list --web", { detach = true })
            end,
            height = 7,
          },
          {
            icon = " ",
            title = "Git Status",
            cmd = "git --no-pager diff --stat -B -M -C",
            height = 10,
          },
        }
        return vim.tbl_map(function(cmd)
          return vim.tbl_extend("force", {
            pane = 2,
            section = "terminal",
            enabled = in_git,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          }, cmd)
        end, cmds)
      end,
      { section = "startup" },
    },
  },
}
