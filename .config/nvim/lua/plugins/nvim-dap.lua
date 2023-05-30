return {
    "mfussenegger/nvim-dap",
    config = function()
        vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>")
        vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over()<CR>")
        vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into()<CR>")
        vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>")
        vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
        vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
        vim.keymap.set("n", "<leader>lp",
            ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
        vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")

        require("dapui").setup()
        require("nvim-dap-virtual-text").setup {
            commented = true,
        }

        local dap, dapui = require "dap", require "dapui"
        dapui.setup {}

        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        require("dap-vscode-js").setup {
            node_path = "node",
            debugger_path = vim.fn.stdpath("data") .. "/custom/debugger/vscode-js-debug",
            -- debugger_cmd = { "js-debug-adapter" },
            adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
        }

        dap.adapters.php = {
            type = "executable",
            command = "node",
            args = { vim.fn.stdpath("data") .. "/custom/debugger/vscode-php-debug/out/phpDebug.js" }
        }

        dap.configurations.php = {
            {
                type = "php",
                request = "launch",
                name = "Listen for Xdebug",
                port = 9003,
                pathMappings = {
                    ["/var/www/html"] = "${workspaceFolder}"
                }
            }
        }
        for _, language in ipairs { "typescript", "javascript" } do
            require("dap").configurations[language] = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                },
                {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach",
                    processId = require("dap.utils").pick_process,
                    cwd = "${workspaceFolder}",
                },
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Debug Jest Tests",
                    -- trace = true, -- include debugger info
                    runtimeExecutable = "node",
                    runtimeArgs = {
                        "./node_modules/jest/bin/jest.js",
                        "--runInBand",
                    },
                    rootPath = "${workspaceFolder}",
                    cwd = "${workspaceFolder}",
                    console = "integratedTerminal",
                    internalConsoleOptions = "neverOpen",
                },
            }
        end
    end,

    dependencies = {
        { "rcarriga/nvim-dap-ui" },
        { "theHamsta/nvim-dap-virtual-text" },
        { "nvim-telescope/telescope-dap.nvim" },
        {
            "mxsdev/nvim-dap-vscode-js",
            module = { "dap-vscode-js" }
        },
        {
            "microsoft/vscode-js-debug",
            opt = true,
            build =
            "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mkdir -p ~/.local/share/nvim/custom/debugger/vscode-js-debug && mv dist ~/.local/share/nvim/custom/debugger/vscode-js-debug/out"
        },
    },
}
