

return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "folke/neoconf.nvim",
    },
    opts = {
    --    PATH = "skip",
        ensure_installed = { 
            "efm",
            -- lua stuff
            "lua-language-server",
            "stylua",

            -- json lsp
            "json-lsp",
            -- web dev stuff
            "css-lsp",
            "html-lsp",
            "typescript-language-server",
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

        ui = {
            icons = {
                package_pending = " ",
                package_installed = "󰄳 ",
                package_uninstalled = "✗"
            }
        },
        keymaps = {
            toggle_server_expand = "<CR>",
            install_server = "i",
            update_server = "u",
            check_server_version = "c",
            update_all_servers = "U",
            check_outdated_servers = "C",
            uninstall_server = "X",
            cancel_installation = "<C-c>",
        },
        max_concurrent_installers = 10,
    },

    config =  function(_,opts)
        require("mason").setup(opts)
    end
}
