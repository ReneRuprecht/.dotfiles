vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*dockerfile*", "*Dockerfile*" },
    callback = function()
        vim.bo.filetype = "dockerfile"
    end,
})
