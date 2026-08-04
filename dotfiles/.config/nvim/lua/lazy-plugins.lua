-- Base plugin specs live in lua/plugins/. An optional machine-local overlay
-- (managed outside this repo, e.g. a private work config) lives at
-- ~/.config/nix-local/nvim. When present we prepend it to the runtimepath, which:
--   * makes its lua/ requirable  -> require("work.util") works anywhere,
--     including from the base jdtls config;
--   * runs its after/ftplugin/*.lua (e.g. extend jdtls on FileType java);
--   * lets lazy import extra plugin specs from its lua/local/.
-- Absent -> no-op.
local spec = { { import = "plugins" } }

local overlay = (os.getenv("HOME") or "") .. "/.config/nix-local/nvim"
if vim.uv.fs_stat(overlay) then
  vim.opt.rtp:prepend(overlay)
  if vim.uv.fs_stat(overlay .. "/lua/local") then
    table.insert(spec, { import = "local" })
  end
end

require("lazy").setup(spec, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  change_detection = {
    notify = false,
  },
})
