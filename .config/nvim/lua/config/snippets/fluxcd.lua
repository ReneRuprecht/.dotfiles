local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Kustomization Snippets
local kustomization_snippets = {
    -- Kustomization Snippet
    s("kustomization", {
        t({"apiVersion: kustomize.toolkit.fluxcd.io/v1", "kind: Kustomization", "metadata:"}),
        t({"","  name: "}), i(1, "my-kustomization"),
        t({"", "  namespace: "}), i(2, "default"),
        t({"", "spec:", "  interval: "}), i(3, "5m"),
        t({"", "  timeout: "}), i(4, "2m0s"),
        t({"", "  prune: "}), i(5, "true"),
        t({"", "  force: "}), i(6, "false"),
        t({"", "  wait: "}), i(7, "true"),
        t({"", "  retryInterval: "}), i(8, "1m"),
        t({"", "  path: "}), i(9, "./k8s"),
        t({"", "  sourceRef:", "    kind: GitRepository", "    name: "}), i(10, "repo-name"),
        t({"", "    namespace: "}), i(11, "flux-system"),
        t({"", "  targetNamespace: "}), i(12, "my-namespace"),
        t({"", "  refreshInterval: "}), i(13, "1m0s"),
        t({"", "  waitForDeployment: "}), i(14, "true"),
        t({"", "  commonLabels:", "    app: "}), i(15, "my-app"),
        t({"", "  commonAnnotations:", "    description: "}), i(16, "My Kustomization description"),
    }),

    -- Kustomization with resources field
    s("kustomization-resources", {
        t({"apiVersion: kustomize.toolkit.fluxcd.io/v1", "kind: Kustomization", "metadata:"}),
        t({"", "  name: "}), i(1, "my-kustomization"),
        t({"", "  namespace: "}), i(2, "default"),
        t({"", "spec:", "  resources:"}),
        t({"", "    - "}), i(3, "deployment.yaml"),
        t({"", "    - "}), i(4, "service.yaml"),
    }),

    -- Kustomization with patches
    s("kustomization-patches", {
        t({"apiVersion: kustomize.toolkit.fluxcd.io/v1", "kind: Kustomization", "metadata:"}),
        t({"  name: "}), i(1, "my-kustomization"),
        t({"", "  namespace: "}), i(2, "default"),
        t({"", "spec:", "  patches:"}),
        t({"    - target:", "        kind: Deployment", "        name: "}), i(3, "deployment-name"),
        t({"      patch: |", "        - op: replace", "          path: /spec/replicas", "          value: "}), i(4, "3"),
    }),

    -- Kustomization with secretGenerator
    s("kustomization-secretGenerator", {
        t({"apiVersion: kustomize.toolkit.fluxcd.io/v1", "kind: Kustomization", "metadata:"}),
        t({"  name: "}), i(1, "my-kustomization"),
        t({"", "  namespace: "}), i(2, "default"),
        t({"", "spec:", "  secretGenerator:"}),
        t({"    - name: "}), i(3, "my-secret"),
        t({"      files:", "        - "}), i(4, "secrets.env"),
        t({"      literals:", "        - "}), i(5, "MY_SECRET_KEY=my-secret-value"),
    }),

    -- Kustomization with configMapGenerator
    s("kustomization-configMapGenerator", {
        t({"apiVersion: kustomize.toolkit.fluxcd.io/v1", "kind: Kustomization", "metadata:"}),
        t({"  name: "}), i(1, "my-kustomization"),
        t({"", "  namespace: "}), i(2, "default"),
        t({"", "spec:", "  configMapGenerator:"}),
        t({"    - name: "}), i(3, "my-configmap"),
        t({"      files:", "        - "}), i(4, "config.yaml"),
    }),
}

ls.add_snippets("yaml", kustomization_snippets)
