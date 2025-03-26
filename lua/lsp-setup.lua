vim.filetype.add { extension = { templ = 'templ' } }
vim.filetype.add { extension = { typst = 'typ' } }
vim.filetype.add { extension = { typst = 'typst' } }

local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  vim.lsp.inlay_hint.enable(true)


  client.server_capabilities.semanticTokensProvider = nil
end

-- document existing key chains
require 'which-key'
-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  clangd = {},
  gopls = {},
  pyright = {},
  html = {
    filetypes = { 'html', 'twig', 'hbs', 'templ' },
    capabilities = {
      textDocument = {
        formating = false,
      },
    },
  },
  htmx = { filetypes = { 'html', 'twig', 'hbs', 'templ' } },
  templ = { filetypes = { 'templ', 'go' } },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
  tailwindcss = {},
  tinymist = {
    single_file_support = true,
    filetypes = { 'typ', 'typst' },
    exportPdf = 'onType',
    outputPath = '$root/target/$dir/$name',
    semantic_tokens = "disable",
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    local attach_fn = on_attach
    if server_name == "tinymist" then
      attach_fn = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
        on_attach(client, bufnr)
      end
    end

    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = attach_fn,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
      single_file_support = (servers[server_name] or {}).single_file_support or false,
      root_dir = function()
        return vim.fn.getcwd()
      end,
    }
  end,
}

require('lspconfig')['rust_analyzer'].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
      command = 'rust-analyzer',
    },
  },
}


require('lspconfig')["dartls"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { 'dart' },
  cmd = { 'dart', 'language-server', '--protocol=lsp' },
  settings = {
  }
}
