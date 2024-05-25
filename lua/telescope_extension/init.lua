local pickers = require("telescope.pickers")
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local utils = require("telescope.previewers.utils")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local M = {}

M.execute_command = function(opts)
	pickers
		.new(opts, {
			finder = finders.new_async_job({
				command_generator = opts.command_generator,
				entry_maker = function(entry)
					local parsed = vim.json.decode(entry)
					if opts.maker.value == "entry" then
						return {
							value = parsed,
							display = parsed.Repository,
							ordinal = parsed.Repository,
						}
					end
					return {
						value = parsed[opts.maker.value],
						display = parsed[opts.maker.display],
						ordinal = parsed[opts.maker.ordinal],
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = previewers.new_buffer_previewer({
				title = opts.title,
				define_preview = function(self, entry)
					vim.api.nvim_buf_set_lines(
						self.state.bufnr,
						0,
						0,
						true,
						-- #TODO: Fix this because is deprecated
						vim.tbl_flatten({
							"",
							"```lua",
							vim.split(vim.inspect(entry.value), "\n"),
							"```",
						})
					)
					utils.highlighter(self.state.bufnr, "markdown")
				end,
			}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local selection = actions_state.get_selected_entry()
					actions.close(prompt_bufnr)
					local command = opts.command .. " " .. selection.value[opts.maker.display]
					vim.cmd(command)
				end)
				return true
			end,
		})
		:find()
end

return M
