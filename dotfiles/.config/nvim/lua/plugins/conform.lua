return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "[C]ode [F]ormat",
      },
    },
    config = function()
      local conform = require("conform")
      local prettier = { "prettierd", "prettier", stop_after_first = true }
      conform.setup({
        -- format_on_save = {
        --   timeout_ms = 500,
        --   lsp_fallback = true,
        -- },
        notify_on_error = false,
        default_format_opts = {
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          c = { "clang-format" },
          cpp = { "clang-format" },
          css = prettier,
          html = prettier,
          javascript = prettier,
          json = prettier,
          lua = { "stylua" },
          python = { "isort", "black" },
          typescript = prettier,
          yaml = prettier,
        },
      })
    end,
  }, -- Autoformat
}
