-- mason
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})
require("mason-lspconfig").setup()

-- null-ls
local null_ls = require('null-ls')
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  source = {
    null_ls.builtins.diagnostics.eslint_d.with({
      prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.formatting.prettierd.with {
      prefer_local = "node_modules/.bin",
    },
  },
  -- you can reuse a shared lspconfig on_attach callback here
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          vim.lsp.buf.formatting_sync()
        end,
      })
    end
  end,
})

require("mason-null-ls").setup({
  automatic_setup = true,
  ensure_installed = { 'lua-language-server', "lua_ls", 'luaformatter', 'prettierd', 'typescript-language-server', 'eslint_d','css_lsp' },
})


-- lspconfig
--tsserver setting
require 'lspconfig'.tsserver.setup {
  on_attach = function(client)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end,
  capabilities = require('cmp_nvim_lsp').default_capabilities()
}
--css setting
require 'lspconfig'.cssls.setup {}
--lua setting
require 'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
}

require'lspconfig'.pyright.setup{}


-- C-hでhoverでLSPの情報が閲覧できる。
vim.api.nvim_set_keymap('n', '<C-h>', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true })
-- C-fでFormat
vim.api.nvim_set_keymap('n', '<C-f>', '<Cmd>lua vim.lsp.buf.format()<CR>', { noremap = true })


-- nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = require('cmp').mapping.preset.insert({
    ['<CR>'] = require('cmp').mapping.confirm({ select = true }),
    ["<C-k>"] = require('cmp').mapping.select_prev_item(),
    ["<C-j>"] = require('cmp').mapping.select_next_item(),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),

  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
  experimental = {
    ghost_text = true,
  },
})

local lspkind = require('lspkind')
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

    })
  }
}
