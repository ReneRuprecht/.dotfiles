return {
    'lewis6991/gitsigns.nvim',
    -- version = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    config = function()
        require('gitsigns').setup()
    end,
}
