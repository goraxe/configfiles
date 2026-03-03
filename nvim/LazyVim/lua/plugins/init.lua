
local diagnostics = "rust-analyzer"
-- vim.g.lazyvim_rust_diagnostics

return {
  {
    "davidmh/mdx.nvim",
    config = true,
    lazy = true,
    ft = "markdown.mdx",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      bacon_ls = {
        enabled = diagnostics == "bacon-ls",
      },
      rust_analyzer = { enabled = false },
    },
  },
},

  {
  "mrcjkb/rustaceanvim",
  ft = { "rust" },
  opts = {
    server = {
      on_attach = function(_, bufnr)
        vim.keymap.set("n", "<leader>cR", function()
          vim.cmd.RustLsp("codeAction")
        end, { desc = "Code Action", buffer = bufnr })
        vim.keymap.set("n", "<leader>dr", function()
          vim.cmd.RustLsp("debuggables")
        end, { desc = "Rust Debuggables", buffer = bufnr })
      end,
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          -- Add clippy lints for Rust if using rust-analyzer
          checkOnSave = diagnostics == "rust-analyzer",
          -- Enable diagnostics if using rust-analyzer
          diagnostics = {
            enable = diagnostics == "rust-analyzer",
          },
          procMacro = {
            enable = true,
          },
          files = {
            exclude = {
              ".direnv",
              ".git",
              ".jj",
              ".github",
              ".gitlab",
              "bin",
              "node_modules",
              "target",
              "venv",
              ".venv",
            },
            -- Avoid Roots Scanned hanging, see https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
            watcher = "client",
          },
        },
      },
    },
  },
  config = function(_, opts)
    if LazyVim.has("mason.nvim") then
      local codelldb = vim.fn.exepath("codelldb")
      local codelldb_lib_ext = io.popen("uname"):read("*l") == "Linux" and ".so" or ".dylib"
      local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)
      opts.dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
      }
    end
    vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    if vim.fn.executable("rust-analyzer") == 0 then
      LazyVim.error(
        "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
        { title = "rustaceanvim" }
      )
    end
  end,
},
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        mdx_analyzer = {
          init_opts = { typescript = { enabled = true } },
        },
        vtsls = {
          autoUseWorkspaceTsdk = true,
          tsserver = {
            globalPlugins = {
              {
                name = "@mdx-js/typescript-plugin",
                enableForWorkspaceTypeScriptVersions = true,
                languages = {
                  "mdx",
                },
              },
            },
          },
        },
      },
    },

    -- Configure tsserver plugin
    {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
        table.insert(opts.servers.vtsls.filetypes, "mdx")
        LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
          {
            name = "@mdx-js/typescript-plugin",
            -- location = LazyVim.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
            languages = { "mdx" },
            -- configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        })
      end,
    },

    -- config = function()
    --   vim.print("in setup for lsp")
    --   local lspconfig = require("lspconfig")
    --   --      local cmp_nvim_lsp = require("cmp_nvim_lsp")
    --
    --   --     local capabilities = cmp_nvim_lsp.default_capabilities()
    --
    --   lspconfig["mdx_analyzer"].setup({
    --     filetypes = { "markdown.mdx", "mdx" },
    --     --        capabilities = capabilities,
    --     init_options = { typescript = "enabled" },
    --   })
    -- end,
  },
}
