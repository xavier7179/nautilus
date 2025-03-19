local ft = require("guard.filetype")

ft("c"):fmt(function()
	---@diagnostic disable-next-line: undefined-field
	if vim.uv.fs_stat(".clang-format") then
		return {
			cmd = "clang-format",
			stdin = true,
		}
	else
		return {
			cmd = "clang-format",
			args = {
				("--style={BasedOnStyle: llvm, IndentWidth: %d, TabWidth: %d, UseTab: %s}"):format(
					vim.bo.shiftwidth,
					vim.bo.tabstop,
					vim.bo.expandtab and "Never" or "Always"
				),
			},
			stdin = true,
		}
	end
end):lint("clang-tidy")
