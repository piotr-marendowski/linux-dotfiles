-- LSP for nvim
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Set up Mason before anything else
			require("mason").setup()
			require("mason-lspconfig").setup({
				--[[ ensure_installed = {
					"lua_ls",
					"clangd",
				}, ]]
				automatic_installation = true,
			})

			-- Quick access via keymap
			require("keys").map("n", "<leader>om", "<cmd>Mason<cr>", "󰏗 Mason")

			-- Neodev setup before LSP config
			require("neodev").setup()

			-- Set up cool signs for diagnostics
			local signs = { Error = "", Warn = "", Hint = "", Info = "" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- Diagnostic config
			local config = {
				virtual_text = true,
				signs = {
					active = signs,
				},
				update_in_insert = true,
				underline = true,
				severity_sort = true,
				float = {
					focusable = true,
					style = "minimal",
					border = "single",
					source = "always",
					header = "",
					prefix = "",
				},
			}
			vim.diagnostic.config(config)

			-- This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(client, bufnr)
				local lsp_map = require("keys").lsp_map

				lsp_map("<leader>cr", vim.lsp.buf.rename, bufnr, "󰑕 Rename symbol")
				lsp_map("<leader>ca", vim.lsp.buf.code_action, bufnr, " Code action")
				lsp_map("ga", vim.lsp.buf.type_definition, bufnr, "󰡱 Type definition")
				-- lsp_map("<leader>cs", require("telescope.builtin").lsp_document_symbols,
                --    bufnr, " Document symbols")

				lsp_map("gd", vim.lsp.buf.definition, bufnr, "Goto Definition")
				lsp_map("gr", require("telescope.builtin").lsp_references, bufnr, "Goto References")
				lsp_map("gI", vim.lsp.buf.implementation, bufnr, "Goto Implementation")
				lsp_map("K", vim.lsp.buf.hover, bufnr, "Hover Documentation")
				lsp_map("gD", vim.lsp.buf.declaration, bufnr, "Goto Declaration")

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
					vim.lsp.buf.format({ formatting_options = { tabSize = 4 } })
				end, { desc = "Format current buffer with LSP" })

				lsp_map("<leader>cf", "<cmd>Format<cr>", bufnr, " Format")

				-- Attach and configure vim-illuminate
				-- require("illuminate").on_attach(client)
			end

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Lua
			require("lspconfig")["lua_ls"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})

			-- Python
			require("lspconfig")["pylsp"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							flake8 = {
								enabled = true,
								maxLineLength = 88, -- Black's line length
							},
							-- Disable plugins overlapping with flake8
							pycodestyle = {
								enabled = false,
							},
							mccabe = {
								enabled = false,
							},
							pyflakes = {
								enabled = false,
							},
							-- Use Black as the formatter
							autopep8 = {
								enabled = false,
							},
						},
					},
				},
			})

			-- C
			require("lspconfig")["clangd"].setup({
				on_attach = on_attach,
				capabilities = { capabilities, offsetEncoding = "utf-8" },
			})

			-- Java
			require("lspconfig")["jdtls"].setup({
				cmd = { "jdtls" },
				on_attach = on_attach,
				capabilities = { capabilities, offsetEncoding = "utf-8" },
				root_dir = function(fname)
					return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git")(fname)
						or vim.fn.getcwd()
				end,
			})

			local function setup_lsp_diags()
				vim.lsp.handlers["textDocument/publishDiagnostics"] =
					vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
						virtual_text = true,
						signs = true,
						update_in_insert = false,
						underline = true,
					})
			end

			setup_lsp_diags()
		end,
	},
	{
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup({
				library = { plugins = { "nvim-dap-ui" }, types = true },
			})
		end,
	},
}
