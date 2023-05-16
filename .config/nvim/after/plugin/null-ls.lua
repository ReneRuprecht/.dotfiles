local nls = require("null-ls")

local formatting = nls.builtins.formatting

nls.setup({
    sources = {
        formatting.prettier,
        --if extra args are needed formatting.prettier.with({ extra_args = {} }),
    },
})
