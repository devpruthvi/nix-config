return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true }, -- disable heavy features in huge files
      quickfile = { enabled = true }, -- render file before plugins load
      indent = { enabled = true }, -- indent guides (replaces indent-blankline)
      input = { enabled = true }, -- nicer vim.ui.input
      notifier = { enabled = true, timeout = 3000 },
      scope = { enabled = true },
      words = { enabled = true }, -- LSP reference highlight + ]] [[ navigation
      picker = {
        enabled = true,
        ui_select = true, -- replaces telescope-ui-select
      },
      dashboard = {
        preset = {
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
    },
    keys = {
      -- files / grep (old telescope muscle memory)
      { "<leader>pf", function() Snacks.picker.files() end, desc = "[S]earch [F]iles" },
      { "<leader>ps", function() Snacks.picker.grep() end, desc = "[S]earch by Grep" },
      { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "[ ] Find existing buffers" },
      { "<leader>/", function() Snacks.picker.lines() end, desc = "[/] Fuzzily search in current buffer" },
      { "<leader>s/", function() Snacks.picker.grep_buffers() end, desc = "[S]earch [/] in Open Files" },
      -- search
      { "<leader>sh", function() Snacks.picker.help() end, desc = "[S]earch [H]elp" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "[S]earch [K]eymaps" },
      { "<leader>ss", function() Snacks.picker.pickers() end, desc = "[S]earch [S]elect Picker" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "[S]earch current [W]ord", mode = { "n", "x" } },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "[S]earch [D]iagnostics" },
      { "<leader>sr", function() Snacks.picker.resume() end, desc = "[S]earch [R]esume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "[S]earch [U]ndo history" },
      { "<leader>s.", function() Snacks.picker.recent() end, desc = '[S]earch Recent Files ("." for repeat)' },
      { "<leader>sn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "[S]earch [N]eovim files" },
      -- git
      { "<leader>lg", function() Snacks.lazygit() end, desc = "Open lazygit" },
      -- notifications
      { "<leader>nh", function() Snacks.picker.notifications() end, desc = "[N]otification [H]istory" },
    },
  },
}
