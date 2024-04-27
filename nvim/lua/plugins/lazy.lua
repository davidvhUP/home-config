-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- Ensure latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Managing
require('lazy').setup({
    -- Colour Scheme
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- Fuzzy Finder
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- File tree
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        requires = {
            "nvim-tree/nvim-web-devicons",
        },
        config= function()
            require("nvim-tree").setup{}
        end,
   },

    -- visualise buffers as tabs
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

    -- lsp-zero
    {
        {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v3.x',
            lazy = true,
            config = false,
            init = function()
                -- Disable automatic setup, we are doing it manually
                vim.g.lsp_zero_extend_cmp = 0
                vim.g.lsp_zero_extend_lspconfig = 0
            end,
        },
        {
            'williamboman/mason.nvim',
            lazy = false,
            config = true,
        },

        -- Autocompletion
        {
            'hrsh7th/nvim-cmp',
            event = 'InsertEnter',
            dependencies = {
                {'L3MON4D3/LuaSnip'},
            },
            config = function()
                -- Here is where you configure the autocompletion settings.
                local lsp_zero = require('lsp-zero')
                lsp_zero.extend_cmp()
                -- And you can configure cmp even more, if you want to.
                local cmp = require('cmp')
                local cmp_action = lsp_zero.cmp_action()
                cmp.setup({
                    formatting = lsp_zero.cmp_format({details = true}),
                    mapping = cmp.mapping.preset.insert({
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-d>'] = cmp.mapping.scroll_docs(4),
                        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                    }),
                    snippet = {
                        expand = function(args)
                            require('luasnip').lsp_expand(args.body)
                        end,
                    },
                })
            end
        },
        {
            "/hrsh7th/cmp-cmdline",
            config = function()
                local lsp_zero = require('lsp-zero')
                lsp_zero.extend_cmp()
                local cmp = require('cmp')
--                local cmp_action = lsp_zero.cmp_action()
                    -- `/` cmdline setup.
                    cmp.setup.cmdline('/', {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = {
                            { name = 'buffer' }
                        }
                    })
                    -- `:` cmdline setup.
                    cmp.setup.cmdline(':', {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = cmp.config.sources({
                            { name = 'path' }
                        }, {
                            {
                                name = 'cmdline',
                                option = {
                                    ignore_cmds = { 'Man', '!' }
                                }
                            }
                        })
                    })
                end
        },

        -- Language Server Protocol
        {
            'neovim/nvim-lspconfig',
            cmd = {'LspInfo', 'LspInstall', 'LspStart'},
            event = {'BufReadPre', 'BufNewFile'},
            dependencies = {
                {'hrsh7th/cmp-nvim-lsp'},
                {'williamboman/mason-lspconfig.nvim'},
            },
            config = function()
                -- This is where all the LSP shenanigans will live
                local lsp_zero = require('lsp-zero')
                lsp_zero.extend_lspconfig()
                --- if you want to know more about lsp-zero and mason.nvim
                --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
                lsp_zero.on_attach(function(client, bufnr)
                    -- see :help lsp-zero-keybindings
                    -- to learn the available actions
                    lsp_zero.default_keymaps({buffer = bufnr})
                end)
                require('mason-lspconfig').setup({
                    ensure_installed = {
                        "pyright",
                        "lua_ls",
                        "r_language_server",
                    },
                    handlers = {
                        lsp_zero.default_setup,
                        lua_ls = function()
                            -- (Optional) Configure lua language server for neovim
                            local lua_opts = lsp_zero.nvim_lua_ls()
                            require('lspconfig').lua_ls.setup(lua_opts)
                        end,
                    }
                })
            end
        },

        -- Debugger
        { "mfussenegger/nvim-dap" },
        { "/HiPhish/debugpy.nvim" }, -- python debugger
        { "rcarriga/nvim-dap-ui", -- Debug UI
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", "/folke/neodev.nvim"},
            config = function()
                require("dapui").setup{
                    mappings = {
                        -- Use a table to apply multiple mappings
                        expand = { "<CR>", "<2-LeftMouse>" },
                        open = "o",
                        remove = "d",
                        edit = "e",
                        repl = "r",
                        toggle = "t",
                    },
                }
                require("neodev").setup{
                    library = { plugins = { "nvim-dap-ui" }, types = true },
                }
            end,
        },
        -- icons
        { "/ChristianChiarulli/neovim-codicons" },
            config = function()
                require("neovim-codicons").setup{
                }
            end,
        -- Virtual text
        { "/theHamsta/nvim-dap-virtual-text" },
        -- Python DAP
        { "/mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            require('dap-python').setup('/home/davidvh/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
            local dap = require ('dap')
            dap.configurations.python = {
                {
                    type = 'python',
                    request = 'launch',
                    name = "Launch file",
                    program = "${file}";
                    pythonPath = '/usr/bin/python3';
                    cwd = "/"

                }
            }
        end,
    },

        -- R.nvim
        {
            "R-nvim/R.nvim",
            lazy = false
        },
        "R-nvim/cmp-r",
        {
            "hrsh7th/nvim-cmp",
            config = function()
                require("cmp").setup({ sources = {{ name = "cmp_r" }}})
                require("cmp_r").setup({ })
            end,
        },

        -- Visualise Marks
        {

            "/chentoast/marks.nvim",
            config = function()
                require("marks").setup()
            end

        },

        -- autoclose
        { 'm4xshen/autoclose.nvim',
            config = function()
                require("autoclose").setup({
                    keys = {
                        ["("] = { escape = false, close = true, pair = "()" },
                        ["["] = { escape = false, close = true, pair = "[]" },
                        ["{"] = { escape = false, close = true, pair = "{}" },
                        ['"'] = { escape = true, close = true, pair = '""' },
                        ["'"] = { escape = true, close = true, pair = "''" },
                        ["`"] = { escape = true, close = true, pair = "``" },
                    },
                    options = {
                        disabled_filetypes = { "text" },
                        disable_when_touch = false,
                        touch_regex = "[%w(%[{]",
                        pair_spaces = false,
                        auto_indent = true,
                        disable_command_mode = false,},
                    })
            end
        },

        -- gen.nvim model
        { "David-Kunz/gen.nvim",
        opts = {
            model = "orca-mini", -- The default model to use.
            host = "localhost", -- The host running the Ollama service.
            port = "11434", -- The port on which the Ollama service is listening.
            quit_map = "q", -- set keymap for close the response window
            retry_map = "<c-r>", -- set keymap to re-send the current prompt
            init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
            -- Function to initialize Ollama
            command = function(options)
                local body = {model = options.model, stream = true}
                return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
            end,
            -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
            -- This can also be a command string.
            -- The executed command must return a JSON object with { response, context }
            -- (context property is optional).
            -- list_models = '<omitted lua function>', -- Retrieves a list of model names
            display_mode = "float", -- The display mode. Can be "float" or "split".
            show_prompt = false, -- Shows the prompt submitted to Ollama.
            show_model = false, -- Displays which model you are using at the beginning of your chat session.
            no_auto_close = false, -- Never closes the window automatically.
            debug = false -- Prints errors and the command which is run.
            }
        },

        -- obsidian.nvim
        {
            "epwalsh/obsidian.nvim",
            version = "3.7.9",  -- recommended, use latest release instead of latest commit
            lazy = false,
            ft = "markdown",
            dependencies = {
                -- Required.
                "nvim-lua/plenary.nvim",
                -- Optional.
                "nvim-telescope/telescope.nvim"
                -- see below for full list of optional dependencies 👇
            },
            opts = {
                workspaces = {
                    {
                        name = "Obsidian Vault",
                        path = "/mnt/d/Google Drive/Obsidian Vault",
                    },
                },
                daily_notes = {
                    -- Optional, if you keep daily notes in a separate directory.
                    folder = "Periodic notes/Daily Notes",
                    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
                    template = "Templates/Daily Review.md"
                },
                completion = {
                    -- Set to false to disable completion.
                    nvim_cmp = true,
                    -- Trigger completion at 2 chars.
                    min_chars = 2,
                },
                templates = {
                    subdir = "Templates",
                },
            },
        },

        -- treesitter
        { "/nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = { "markdown", "markdown_inline", "lua", "python", "r", "rnoweb" },
                    highlight = {
                        enable = true,
                    },
                })
            end,
        },

        -- Noice (command popup)
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            opts = {
                -- add any options here
            },
            dependencies = {
                -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                "MunifTanjim/nui.nvim",
                -- OPTIONAL:
                --   `nvim-notify` is only needed, if you want to use the notification view.
                --   If not available, we use `mini` as the fallback
                "rcarriga/nvim-notify",
            },
        },

        --  code commenter
        {
            'numToStr/Comment.nvim',
            opts = {
                -- add any options here
            },
            lazy = false,
        },

        {
            'nvimdev/dashboard-nvim',
            event = 'VimEnter',
            config = function()
                require('dashboard').setup {
                    -- config
                }
            end,
            dependencies = { {'nvim-tree/nvim-web-devicons'}}
        }

       }})
