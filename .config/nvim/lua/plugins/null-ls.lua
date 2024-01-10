return {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
        local nls = require("null-ls")
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

        local formatting = nls.builtins.formatting

        nls.setup({
            sources = {
                formatting.prettierd,
                --if extra args are needed formatting.prettier.with({ extra_args = {} }),
            },
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({
                        group = augroup,
                        buffer = bufnr,
                    })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end,
        })
    end
}
