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
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
                'ts_ls',
                'lua_ls',
                -- 'gopls',
                -- 'rust_analyzer',
                'dockerls',
                'docker_compose_language_service',
                'pyright',
                'terraformls',
                'ansiblels',
                'yamlls'
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                    }
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                }
                            }
                        }
                    }
                end,
                ["gopls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup {
                        capabilities = capabilities,
                        on_attach = function()
                            vim.keymap.set(
                                "n",
                                "<leader>ee",
                                "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
                            )
                        end,
                    }
                end,
                ["rust_analyzer"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.rust_analyzer.setup {
                        capabilities = capabilities,
                    }
                end,
                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pyright.setup {
                        capabilities = capabilities,
                    }
                end,
                ["ansiblels"] = function()
                    local lspconfig = require("lspconfig")
                    local util = lspconfig.util

                    -- Funktion zur Überprüfung, ob eine `ansible.cfg` im Projekt-Root existiert
                    local function has_ansible_cfg()
                        local root = util.root_pattern('ansible.cfg')(vim.fn.getcwd())
                        return root and vim.fn.filereadable(root .. '/ansible.cfg') == 1
                    end

                    -- Setup nur ausführen, wenn `ansible.cfg` gefunden wird
                    if has_ansible_cfg() then
                        lspconfig.ansiblels.setup {
                            capabilities = capabilities,
                            filetypes = { 'yaml', 'yml' },
                            root_dir = util.root_pattern('ansible.cfg', '.ansible-lint'),
                            single_file_support = true,
                        }
                    end
                end,
                ["terraformls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.terraformls.setup {
                        capabilities = capabilities,
                        filetypes = { "terraform", "terraform-vars", "tf" }
                    }
                end,
                ["dockerls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.dockerls.setup {
                        capabilities = capabilities,
                    }
                end,
                ["docker_compose_language_service"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.docker_compose_language_service.setup {
                        capabilities = capabilities,
                        filetypes = { "yaml.docker-compose" },
                    }
                end,
                ["ts_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ts_ls.setup {
                        capabilities = capabilities,
                        filetypes = {
                            "typescript",
                            "javascript",
                            "javascriptreact",
                            "typescriptreact",
                        },
                        root_dir = lspconfig.util.root_pattern(
                            "package.json",
                            "tsconfig.json",
                            ".git"
                        )
                    }
                end,
                ["yamlls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.yamlls.setup {
                        capabilities = capabilities,
                        filetypes = { "yaml" },
                        settings = {
                            yaml = {
                                schemaStore = {
                                    enable = false
                                },
                                schemas = {
                                    ["https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/all.json"] = {
                                        "*/gitrepository*.yaml",
                                        "*/helmrelease*.yaml",
                                        "*/helmrepository*.yaml",
                                        "*/release*.yaml",
                                        "*/repository*.yaml",
                                        "*/values*.yaml",
                                        "*/chart*.yaml",
                                    },
                                    kubernetes = {
                                        "*/deployment*.yaml",
                                        "*/service*.yaml",
                                        "*/configmap*.yaml",
                                        "*/secret*.yaml",
                                        "*/ingress*.yaml",
                                        "*/namespace*.yaml",
                                        "*/pod*.yaml",
                                        "*/persistentvolume*.yaml",
                                        "*/pv*.yaml",
                                        "*/persistentvolumeclaim*.yaml",
                                        "*/pvc*.yaml",
                                        "*/statefulset*.yaml",
                                        "*/daemonset*.yaml",
                                    },
                                    ["https://www.schemastore.org/kustomization.json"] = {
                                        "*/kustomization*.yaml",
                                    }
                                },
                                validate = { enable = true },
                                completion = { enable = true },
                                hover = { enable = true },
                            }
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
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                        -- elseif cmp.visible() then
                        --     cmp.select_next_item()
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- that way you will only jump inside the snippet region
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                        -- elseif cmp.visible() then
                        --     cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
                { name = "path" }
            }, {
                { name = 'buffer' },
            })

        })
    end
}
