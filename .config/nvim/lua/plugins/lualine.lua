return {
    'nvim-lualine/lualine.nvim',
    depenencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
    config = function()
        require('lualine').setup()
    end
}
