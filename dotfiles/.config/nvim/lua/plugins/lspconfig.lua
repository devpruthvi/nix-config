return {
  {
    -- nvim-lspconfig is now a *data-only* repo: it ships server configs in
    -- its `lsp/` directory which `vim.lsp.config()` discovers automatically.
    -- The `require("lspconfig")` framework is deprecated on 0.11+.
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspGroup", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, modes)
            modes = modes or { "n" }
            vim.keymap.set(modes, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Note: 0.11+ also ships defaults: grn (rename), gra (code action),
          -- grr (references), gri (implementation), grt (type def), gO (symbols),
          -- K (hover), <C-s> (signature help in insert mode).

          --  To jump back, press <C-t>.
          map("gd", function() Snacks.picker.lsp_definitions() end, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", function() Snacks.picker.lsp_references() end, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          map("gI", function() Snacks.picker.lsp_implementations() end, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          map("<leader>D", function() Snacks.picker.lsp_type_definitions() end, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          map("<leader>ds", function() Snacks.picker.lsp_symbols() end, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          map("<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "v" })

          map("K", vim.lsp.buf.hover, "Hover Documentation")

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- Reference highlighting under the cursor is handled by snacks.words
          -- (see plugins/snacks.lua); ]] and [[ jump between references.
        end,
      })

      -- Diagnostics: virtual_text by default, <leader>l toggles to the
      -- native virtual_lines (0.11+ builtin, replaces lsp_lines.nvim).
      vim.diagnostic.config({ virtual_text = true, virtual_lines = false, severity_sort = true })
      vim.keymap.set("", "<leader>l", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
        else
          vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
        end
      end, { desc = "Toggle diagnostic virtual lines" })

      -- Server-specific settings, merged on top of the nvim-lspconfig defaults.
      -- blink.cmp auto-injects its completion capabilities via vim.lsp.config on 0.11+.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "jdtls",
        },
      })

      -- mason-lspconfig v2 calls vim.lsp.enable() for every installed server.
      -- jdtls is excluded as it is started by the after/ftplugin/java.lua via nvim-jdtls.
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "gopls" },
        automatic_enable = {
          exclude = { "jdtls" },
        },
      })
    end,
  },
}
