-- @type LazySpec 
return {
    {
    "goraxe/lsp-golang",
    dir = "/home/goraxe/configfiles/nvim/lua/goraxe/foo",
    dependencies = { 
    "williamboman/mason.nvim",
        },
    ft =  "go",
    config = function() 
    end,
    opts = {
      gopls = {
        namer = "test",
      },

    }
}

}
