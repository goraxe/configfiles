M = {


    keymaps = require("goraxe.core.keybinds")
}



-- local wk = require("which-key")
--wk.register(M.keymaps[1], M.keymaps[2])

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.hoverProvider then
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
    end
  end,
})

vim.api.nvim_create_user_command('Mkdir', 'echo (<f-args>)', { nargs = 1})

return M

