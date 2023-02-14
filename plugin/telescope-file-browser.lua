-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
require("telescope").setup {
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      initial_mode = 'normal',
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
          ['<C-u>'] = require "telescope.actions".close,
        },
        ["n"] = {
          -- your custom normal mode mappings
          ['<C-u>'] = require "telescope.actions".close,
        },
      },
    },
  },
}
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"

vim.api.nvim_set_keymap(
  "n",
  "<space>fb",
  ":Telescope file_browser",
  { noremap = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<space>fh",
  ":Telescope file_browser hidden=True",
  { noremap = true }
)

require 'nvim-treesitter.configs'.setup {
  auto_install = true,
  ensure_installed = "all",
  highlight = { enable = true },
  indent = { enable = true },
}
