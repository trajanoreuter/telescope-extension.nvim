# telescope-extension.nvim
Telescope extension plugin

This plugin is a extension for [nvim-telescope/telescope.nvim], where it provides additional functionality to the telescope.nvim plugin.
The purpose of this is to execute a command on the selected item in the telescope prompt.
This is only to study and learn how to create a telescope extension plugin and have fun with it.

```lua
M.execute_command({
	title = "Docker Images",
	maker = {
		value = "entry",
		display = "Repository",
		ordinal = "Repository",
	},
	command_generator = function()
		return { "docker", "images", "--format", "json" }
	end,
	command = "edit term://docker run -it",
})

```
Example to run docker image and open a terminal.
