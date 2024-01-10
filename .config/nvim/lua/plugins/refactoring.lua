return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("refactoring").setup()
    end,
    keys = {
        {
            "<leader>r",
            function()
                require("refactoring").select_refactor()
            end,
            mode = "v",
            noremap = true,
            silent = true,
            expr = false,
        },
    },
}
