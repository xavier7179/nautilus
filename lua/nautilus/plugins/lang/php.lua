local lang = require("nautilus.custom.lang")

return {
	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("php"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

		opts.servers.intelephense = vim.tbl_deep_extend("force", opts.servers.intelephense or {}, {
			init_options = {
				globalStoragePath = vim.fn.stdpath("data") .. "/intelephense",
				licenceKey = nil,
				clearCache = false,
			},
			settings = {
				intelephense = {
					files = {
						maxSize = 1000000,
					},
					-- PHP version for accurate version-specific analysis.
					-- Update this if the project targets a different version.
					environment = {
						phpVersion = "8.2",
					},
					-- Stubs to load. Extend this list per-project as needed.
					stubs = {
						"apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core",
						"ctype", "curl", "date", "dba", "dom", "enchant", "exif",
						"FFI", "fileinfo", "filter", "fpm", "ftp", "gd", "gettext",
						"gmp", "hash", "iconv", "imap", "intl", "json", "ldap",
						"libxml", "mbstring", "meta", "mysqli", "mysqlnd", "oci8",
						"odbc", "openssl", "pcntl", "pcre", "PDO", "pdo_ibm",
						"pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar",
						"posix", "pspell", "random", "readline", "Reflection",
						"session", "shmop", "SimpleXML", "snmp", "soap", "sockets",
						"sodium", "SPL", "sqlite3", "standard", "superglobals",
						"sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer",
						"xml", "xmlreader", "xmlrpc", "xmlwriter", "xsl", "Zend OPcache",
						"zip", "zlib",
						-- Common framework stubs — uncomment as needed:
						-- "wordpress", "laravel", "symfony",
					},
					-- Individual diagnostic categories (all off by default upstream).
					diagnostics = {
						enable = true,
						undefinedSymbols = true,
						undefinedVariables = true,
						undefinedTypes = true,
						undefinedFunctions = true,
						undefinedConstants = true,
						undefinedClassConstants = true,
						undefinedMethods = true,
						undefinedProperties = true,
						unusedSymbols = true,
						typeErrors = true,
						implementationErrors = true,
					},
					completion = {
						triggerParameterHints = true,
						maxItems = 100,
					},
					format = {
						enable = false, -- handled by conform + php-cs-fixer
					},
				},
			},
		})

			return opts
		end,
	},

	{
		"mfussenegger/nvim-dap",
		optional = true,
		ft = lang.ft("php"),
		config = function()
			local dap = require("dap")
			if dap.adapters.php then return end

			local path = vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter"
			dap.adapters.php = {
				type = "executable",
				command = "node",
				args = { path .. "/extension/out/phpDebug.js" },
			}

			dap.configurations.php = {
				{
					type = "php",
					request = "launch",
					name = "Listen for Xdebug",
					port = 9003,
				},
				{
					type = "php",
					request = "launch",
					name = "Run current script",
					program = "${file}",
					cwd = "${fileDirname}",
					port = 9003,
					runtimeExecutable = "php",
				},
			}
		end,
	},
	{
		"olimorris/neotest-phpunit",
		ft = lang.ft("php"),
	},
}
