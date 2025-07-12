return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():add()
      end, { desc = "[H]arpoon [A]dd" })
      vim.keymap.set("n", "<leader>hl", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "[H]arpoon [L]ist" })

      -- Set <leader>1..<leader>5 as shortcuts for harpoon files
      for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
        vim.keymap.set("n", string.format("<leader>%d", idx), function()
          harpoon:list():select(idx)
        end, { desc = string.format("Harpoon: %d", idx) })
      end
    end,
  },
}
