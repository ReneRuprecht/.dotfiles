return {
    'christoomey/vim-tmux-navigator',
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<m-h>",  ":TmuxNavigateLeft<cr>" },
        { "<m-j>",  ":TmuxNavigateDown<cr>" },
        { "<m-k>",  ":TmuxNavigateUp<cr>" },
        { "<m-l>",  ":TmuxNavigateRight<cr>" },
        { "<m-\\>", ":TmuxNavigatePrevious<cr>" },
    },
}
