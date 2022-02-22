local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local filename = {
	"filename",
	file_status = true,
	path = 1,
	symbols = {
        modified = '[+]',      -- Text to show when the file is modified.
        readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
        unnamed = '[No Name]', -- Text to show for unnamed buffers.
    }
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {
	"location",
	padding = 0,
}

local tabs = {
	"tabs",
	max_length = vim.o.columns / 3, -- Maximum width of tabs component.
									-- Note:
									-- It can also be a function that returns
									-- the value of `max_length` dynamically.
	mode = 2, -- 0: Shows tab_nr
			  -- 1: Shows tab_name
			  -- 2: Shows tab_nr + tab_name

	tabs_color = {
	    -- Same values as the general color option can be used here.
	    active = 'lualine_a_normal',     -- Color for active tab.
	    inactive = 'lualine_a_inactive', -- Color for inactive tab.
	},
}

local buffers = {
	'buffers',
	show_filename_only = true,   -- Shows shortened relative path when set to false.
	show_modified_status = true, -- Shows indicator when the buffer is modified.

	mode = 0, -- 0: Shows buffer name
			  -- 1: Shows buffer index (bufnr)
			  -- 2: Shows buffer name + buffer index (bufnr)

	max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
										-- it can also be a function that returns
										-- the value of `max_length` dynamically.
	filetype_names = {
	    TelescopePrompt = 'Telescope',
	    dashboard = 'Dashboard',
	    packer = 'Packer',
	    fzf = 'FZF',
	    alpha = 'Alpha'
	}, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

	buffers_color = {
	    -- Same values as the general color option can be used here.
	    active = 'lualine_z_normal',     -- Color for active buffer.
	    inactive = 'lualine_z_inactive', -- Color for inactive buffer.
	},
}

-- cool function for progress
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "molokai",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { branch, diagnostics },
		lualine_b = { mode },
		lualine_c = { filename },
		-- lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_x = { diff, spaces, "encoding", filetype },
		lualine_y = { location },
		lualine_z = { progress },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = { tabs },
		lualine_z = { buffers },
	},
	extensions = {},
})
