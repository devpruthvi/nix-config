return {
  {
    -- The `master` branch is frozen; `main` is the maintained rewrite for 0.11+.
    -- It no longer has a `configs` module: highlight/indent are enabled per
    -- buffer via the core vim.treesitter API below.
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").install({
        "bash",
        "c",
        "go",
        "graphql",
        "html",
        "java",
        "javascript",
        "lua",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "typescript",
        "vim",
        "vimdoc",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitterStart", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          -- start errors when no parser is installed for the language
          if lang and pcall(vim.treesitter.start, ev.buf, lang) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
