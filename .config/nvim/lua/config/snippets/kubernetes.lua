local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node


local kubernetes_namespace_snippet = {
    s("namespace", {
        t({ "---", "apiVersion: v1", "kind: Namespace", "metadata:" }),
        t({ "", "  name: " }), i(1, "my-namespace"),
        t({ "", "  labels:", "    environment: " }), i(2, "dev"),
        t({ "", "  annotations:", "    description: " }), i(3, "Namespace for my application"),
    }),
}

ls.add_snippets("yaml", kubernetes_namespace_snippet)
