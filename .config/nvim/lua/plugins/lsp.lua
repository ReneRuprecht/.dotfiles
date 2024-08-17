return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- LSP Support
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',

        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',

        --
        'windwp/nvim-autopairs',

        "j-hui/fidget.nvim",
    },
    config = function()

        require("fidget").setup({})

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = { 'tsserver',
            'lua_ls',
            'gopls',
            'rust_analyzer',
            'dockerls',
            'docker_compose_language_service',
            'terraformls',
            'ansiblels',
        },
        handlers = {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function (server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup {}
            end,
            -- Next, you can provide targeted overrides for specific servers.
            ["lua_ls"] = function ()
                local lspconfig = require("lspconfig")
                lspconfig.lua_ls.setup {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" }
                            }
                        }
                    }
                }
            end,
            ["gopls"] = function ()
                local lspconfig = require("lspconfig")
                lspconfig.gopls.setup {
                }
            end,
            ["rust_analyzer"] = function ()
                local lspconfig = require("lspconfig")
                lspconfig.rust_analyzer.setup {
                }
            end,
            ["ansiblels"] = function ()
                local lspconfig = require("lspconfig")
                lspconfig.ansiblels.setup {
                }
            end,
            ["terraformls"] = function ()
                local lspconfig = require("lspconfig")
                lspconfig.terraformls.setup {
                    filetypes = {"terraform", "terraform-vars", "tf"}
                }
            end,
            ["dockerls"] = function ()
                local lspconfig = require("lspconfig")
                lspconfig.dockerls.setup {
                }
            end,
            ["docker_compose_language_service"] = function ()
                local lspconfig = require("lspconfig")
                lspconfig.docker_compose_language_service.setup {
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
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    cmp.setup({
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        mapping = cmp.mapping.preset.insert({
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
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' }, -- For luasnip users.
        }, {
            { name = 'buffer' },
        })

    })

    end
}
