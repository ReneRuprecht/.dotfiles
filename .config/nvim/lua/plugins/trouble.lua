return {
    "folke/trouble.nvim",
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
    config = function()
        require("trouble").setup {
            vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end),
            vim.keymap.set("n", "[d", function() require("trouble").next({ skip_groups = true, jump = true }); end),
            vim.keymap.set("n", "]d", function()
                require("trouble").previous({ skip_groups = true, jump = true });
            end),
        }
    end
}
