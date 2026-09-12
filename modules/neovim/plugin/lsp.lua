-- Setup completion
require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
	},
	sources = {
		default = { "lsp", "path", "buffer" },
	},
})

local on_attach = function(_, bufnr)
	local bufmap = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	bufmap("<leader>r", vim.lsp.buf.rename, "Rename")
	bufmap("<leader>a", vim.lsp.buf.code_action, "Code Action")

	bufmap("gd", vim.lsp.buf.definition, "Go to Definition")
	bufmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
	bufmap("gI", vim.lsp.buf.implementation, "Go to Implementation")
	bufmap("<leader>D", vim.lsp.buf.type_definition, "Go to Type Definition")

	bufmap("gr", require("telescope.builtin").lsp_references, "Go to References")
	bufmap("<leader>s", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
	bufmap("<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

	bufmap("<leader>k", vim.lsp.buf.hover, "Hover Documentation")

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		require("conform").format({ bufnr = bufnr, lsp_fallback = true })
	end, {})
end

vim.lsp.config("*", {
	on_attach = on_attach,
	capabilities = require("blink.cmp").get_lsp_capabilities({}, true),
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod" },
	root_markers = { "go.work", "go.mod", ".git" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } }, -- Fix 'undefined global vim' warnings
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
})

-- ESLint Server
vim.lsp.config("eslint", {
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_dir = vim.fs.root(0, {
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.yaml",
		".eslintrc.json",
		"eslint.config.js",
		"package.json",
		".git",
	}),
	settings = {
		codeActionOnSave = {
			enable = true,
			mode = "all",
		},
		run = "onType",
		validate = "on",
	},
})

-- Tailwind CSS Server
vim.lsp.config("tailwindcss", {
	filetypes = {
		"html",
		"css",
		"scss",
		"jsx",
		"tsx",
		"vue",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	cmd = { "tailwindcss-language-server", "--stdio" },
	root_dir = vim.fs.root(
		0,
		{ "tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "package.json", ".git" }
	),
	settings = {
		tailwindCSS = {
			classAttributes = { "class", "className", "classList", "ngClass" },
		},
	},
})

vim.lsp.config("nixd", {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_dir = vim.fs.root(0, { "flake.nix", "default.nix", ".git" }),
})

-- Rust (incl. ESP32 Xtensa): rust-analyzer shells out to `cargo`/`rustc`,
-- which for ESP work live in ~/.rustup (esp toolchain + Xtensa GCC) and are
-- NOT on the default NixOS PATH. Inject them here so the LSP works no matter
-- where nvim was launched from (a direnv .envrc in esp projects is still
-- useful for the terminal, but the LSP must not depend on it).
do
	local home = vim.fn.expand("$HOME")
	local esp_bin = home .. "/.rustup/toolchains/esp/bin"
	local xtensa_bin = vim.fn.glob(home .. "/.rustup/toolchains/esp/xtensa-esp-elf/*/xtensa-esp-elf/bin", false, true)[1]
	local libclang = vim.fn.glob(home .. "/.rustup/toolchains/esp/xtensa-esp32-elf-clang/*/esp-clang/lib", false, true)[1]
	local cmd = { "env", "PATH=" .. esp_bin .. ":" .. (xtensa_bin or "") .. ":" .. vim.env.PATH }
	if libclang then
		table.insert(cmd, "LIBCLANG_PATH=" .. libclang)
	end
	table.insert(cmd, "rust-analyzer")
	vim.lsp.config("rust_analyzer", {
		cmd = cmd,
		filetypes = { "rust" },
		root_markers = { "Cargo.toml", "rust-project.json", ".git" },
		settings = {
			["rust-analyzer"] = {
				-- The ESP (Xtensa) toolchain ships no `test`/`std` sysroot crates
				-- (bare metal uses build-std with core+alloc only), so checking
				-- test/bench targets always fails with E0463. Check lib+bins only.
				check = { allTargets = false },
			},
		},
	})
end

-- Dart & Flutter Language Server
-- `dart` is provided by the Flutter SDK (which bundles Dart) or the standalone Dart SDK,
-- and the same server handles both pure Dart and Flutter projects.
vim.lsp.config("dartls", {
	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	root_markers = { "pubspec.yaml" },
	settings = {
		dart = {
			analysisExcludedFolders = {
				vim.fn.expand("$HOME/.pub-cache"),
				vim.fn.expand("$HOME/flutter"),
			},
			updateImportsOnRename = true,
			completeFunctionCalls = true,
			showTodos = true,
		},
	},
})

vim.lsp.config("emmet_ls", {
	filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact", "vue" },
	cmd = { "emmet-ls", "--stdio" },
	root_dir = vim.fs.root(0, { ".git" }),
})

----------------------------------------------------------------
--- Vue Language Server with TypeScript Plugin for Vue
-----------------------------------------------------------------
-- Injected from neovim.nix as ${pkgs.vue-language-server}/lib/language-tools/packages/language-server
local vue_language_server_path = vim.g.vue_language_server_path

vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			},
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
})

vim.lsp.config("vue_ls", {
	cmd = { "node", vue_language_server_path .. "/bin/vue-language-server.js", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	init_options = {
		typescript = {
			tsdk = "/Users/marufs/.npm-global/lib/node_modules/typescript/lib",
		},
	},
	on_init = function(client)
		client.handlers["tsserver/request"] = function(_, result, context)
			local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "ts_ls" })
			if #clients == 0 then
				vim.notify(
					"Could not find `ts_ls` lsp client, `vue_ls` would not work without it.",
					vim.log.levels.ERROR
				)
				return
			end
			local ts_client = clients[1]
			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = "vue_request_forward",
				command = "typescript.tsserverRequest",
				arguments = { command, payload },
			}, { bufnr = context.bufnr }, function(_, r)
				local response_data = { { id, r.body } }
				client:notify("tsserver/response", response_data)
			end)
		end
	end,
})
----------------------------------------------------------------
--- Vue Language Server with TypeScript Plugin for Vue
-----------------------------------------------------------------

-- clangd: C/C++ intellisense, also used for PlatformIO/Arduino projects.
-- PlatformIO has no language server of its own; it is made LSP-consumable via
-- compile_commands.json (see plugin/platformio.lua for the compiledb workflow).
-- --query-driver lets clangd query the GCC cross-toolchains that PlatformIO
-- keeps in ~/.platformio (xtensa/arm/etc.) for their built-in include paths.
vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--query-driver=" .. vim.fn.expand("$HOME") .. "/.platformio/packages/**/bin/*",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "arduino" },
	root_markers = { "compile_commands.json", "platformio.ini", "compile_flags.txt", ".git" },
})

vim.lsp.enable({
	"lua_ls",
	"nixd",
	"gopls",
	"clangd",
	"ts_ls",
	"vue_ls",
	"tailwindcss",
	"eslint",
	"emmet_ls",
	"rust_analyzer",
	"dartls",
})
