-- LLMs for superior autocompletion
return {
    {
        "huggingface/llm.nvim",
        event = "VeryLazy",
        config = function()
            require("llm").setup({
                api_token = "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",
                accept_keymap = "<A-j>",
                dismiss_keymap = "<i>",

                tokens_to_clear = { "<EOT>" },
                fim = {
                    enabled = true,
                    prefix = "<PRE> ",
                    middle = " <MID>",
                    suffix = " <SUF>",
                },
                model = "codellama/CodeLlama-13b-hf",
                context_window = 8192,
                tokenizer = {
                    repository = "codellama/CodeLlama-13b-hf",
                },
                enable_suggestions_on_startup = false,

                lsp = {
                    bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
                },
            })
            local map = require("keys").map
            map("n", "<leader>ou", "<cmd>LLMToggleAutoSuggest<cr>", " Toggle autosuggestions")
        end,
    },
    {
        "Exafunction/codeium.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({})
        end,
    },
}
