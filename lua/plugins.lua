local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here

  use({ "wbthomason/packer.nvim" })
  use({ "nvim-lua/plenary.nvim" }) -- Common utilities

  -- Colorschemes
  use({ "Mofiqul/dracula.nvim" }) -- Color scheme

  -- icon
  use({ 'nvim-tree/nvim-web-devicons' })

  -- tag complate
  use({ "itmammoth/doorboy.vim" })

  -- file browser
  use({
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
  })
  use({ "nvim-telescope/telescope-file-browser.nvim" })
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }

  -- statusLine
  use 'feline-nvim/feline.nvim'
  use {
    'lewis6991/gitsigns.nvim',
    -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
  }
  use "Hitesh-Aggarwal/feline_one_monokai.nvim"

  -- manage external editor tooling such as LSP servers, DAP servers, linters, and formatters
  use({
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  })

  -- complement
  use({ "hrsh7th/nvim-cmp" }) --補完エンジン本体
  use({ "hrsh7th/cmp-nvim-lsp" }) --LSPを補完ソースに
  use({ "hrsh7th/cmp-buffer" }) --bufferを補完ソースに
  use({ "hrsh7th/cmp-path" }) --pathを補完ソースに
  use({ "onsails/lspkind.nvim" })
  --LuaSnip
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'


  -- for fomatter and linnter tool
  use({
    "jose-elias-alvarez/null-ls.nvim",
    "jay-babu/mason-null-ls.nvim",
  })


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
