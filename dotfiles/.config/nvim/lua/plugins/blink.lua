return {
  { -- Autocompletion
    "saghen/blink.cmp",
    event = "InsertEnter",
    -- use a release tag to download pre-built fuzzy-matcher binaries
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "folke/lazydev.nvim",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' preset matches the old nvim-cmp muscle memory:
      -- <C-y> accept, <C-n>/<C-p> next/prev, <C-Space> open menu/docs, <C-e> hide
      keymap = {
        preset = "default",
        -- keep old LuaSnip-style snippet jumps
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
      },

      -- show function signature help while typing (<C-k> toggles)
      signature = { enabled = true },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },

      -- Rust fuzzy matcher for typo resistance and performance,
      -- falls back to the lua implementation with a warning if unavailable
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
