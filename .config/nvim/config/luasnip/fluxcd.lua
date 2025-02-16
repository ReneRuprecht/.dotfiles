local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    -- GitRepository Snippet
    s("gitrepo", {
        t({ "apiVersion: source.toolkit.fluxcd.io/v1beta2", "kind: GitRepository", "metadata:" }),
        t({ "  name: " }), i(1, "name"),
        t({ "", "  namespace: " }), i(2, "flux-system"),
        t({ "", "spec:", "  interval: " }), i(3, "1m"),
        t({ "", "  url: " }), i(4, "https://github.com/username/repo"),
        t({ "", "  branch: " }), i(5, "main"),
        t({ "", "  secretRef:", "    name: " }), i(6, "git-credentials"),
    }),
    -- HelmRelease Snippet
    s("helmrelease", {
        t({ "apiVersion: helm.toolkit.fluxcd.io/v2beta1", "kind: HelmRelease", "metadata:" }),
        t({ "  name: " }), i(1, "release-name"),
        t({ "", "  namespace: " }), i(2, "default"),
        t({ "", "spec:", "  interval: " }), i(3, "5m"),
        t({ "", "  chart:", "    spec:" }),
        t({ "      chart: " }), i(4, "chart-name"),
        t({ "      version: " }), i(5, "1.0.0"),
        t({ "      sourceRef:", "        kind: HelmRepository", "        name: " }), i(6, "repo-name"),
        t({ "        namespace: " }), i(7, "flux-system"),
        t({ "", "  values:", "    replicaCount: " }), i(8, "2"),
    }),
}
