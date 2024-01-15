return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        -- LSP Support
        { 'neovim/nvim-lspconfig' },
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },

        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lua' },

        -- Snippets
        { 'L3MON4D3/LuaSnip' },
        { 'rafamadriz/friendly-snippets' },

        --
        { 'windwp/nvim-autopairs' },
    },
    config = function()
        local lsp_zero = require('lsp-zero')

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = { 'tsserver',
                'rust_analyzer',
                'lua_ls',
                'clangd',
                'emmet_ls',
                'html',
                'eslint',
                'intelephense',
                'tailwindcss',
                'dockerls',
                'docker_compose_language_service', },
            handlers = {
                lsp_zero.default_setup,
                lua_ls = function()
                    local lua_opts = lsp_zero.nvim_lua_ls()
                    require('lspconfig').lua_ls.setup(lua_opts)
                end,
                rust_analyzer = function()
                    require('lspconfig').rust_analyzer.setup {

                    }
                end,
                gopls = function()
                    require('lspconfig').gopls.setup {
                        settings = {
                            gopls = {
                                usePlaceholders = true,
                                analyses = {
                                    unusedparams = true,
                                },
                                staticcheck = true,
                                gofumpt = true,
                            },
                        },
                    }
                end,
                emmet_ls = function()
                    require('lspconfig').emmet_ls.setup {
                        filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
                        init_options = {
                            html = {
                                options = {
                                    -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                                    ["bem.enabled"] = true,
                                },
                            },
                        }
                    }
                end,
            }
        })

        -- snip
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/nvim/config/custom-snippets/" } })
        -- end snip

        local cmp = require('cmp')
        local cmp_format = lsp_zero.cmp_format()
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local cmp_mappings = lsp_zero.defaults.cmp_mappings({
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<Enter>'] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                    -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                    -- that way you will only jump inside the snippet region
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        })

        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )

        cmp.setup({
            formatting = cmp_format,
            mapping = cmp_mappings,
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            }, {
                { name = "buffer" },
            }),
        })

        lsp_zero.on_attach(function(client, bufnr)
            local opts = { buffer = bufnr, remap = false }

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", "<M-Enter>", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("n", "<leader>qf", function()
                vim.lsp.buf.format({
                    async = false,
                    timeout_ms = 10000,

                })
            end, opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        end)

        lsp_zero.set_sign_icons({
            error = 'E',
            warn = 'W',
            hint = 'H',
            info = 'I'
        })

        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
        })
    end
}
