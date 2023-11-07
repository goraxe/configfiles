local nvim_lsp = require('lspconfig')

local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "puppet",
    "terraform",
    -- python
    "python",
    "ninja",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.lspconfig = {
  gopls = {
    namer = "test",
  },
  pylsp = {

    settings = {
      pylsp = {

        plugins = {
          jedi_completion = {
            fuzzy = true
          }
        }
      }
    }
  },
  lua_ls = {

    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
            [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  },
  denols = {
    root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc")
  },
  tsserver = {
    root_dir = nvim_lsp.util.root_pattern("package.json"),
    single_file_support = flase
  }
}

M.mason = {

  ensure_installed = {
    "efm",
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",
    "emmet-language-server",

    -- c/cpp stuff
    "clangd",
    "clang-format",

    -- shell
    "bash-language-server",

    -- python
--      "jedi_language_server",
    "pyright",
    "ruff-lsp",

    -- puppet
    "puppet",

    -- docker
    "dockerls",

    -- golang
    "golangci_lint_ls",
    "gopls"
  },
  automatic_installation = true,
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
