-- These are some default settings that I find comfortable. I tried to document
-- what each setting does. You can change these settings while working in Neovim
-- to try them out without having to change them in this file.
--
-- To do that, in Normal Mode (press Esc if you are unsure, if you're in normal
-- mode) and type `:lua vim.opt.<option name>=<option value>`
--
-- So, to set the `cursorline` setting to `false` (and disable the highlight of
-- the current line), you type `:lua vim.opt.cursorline=false`.
--
-- Try that and see what happens. If you don't like a change you made, you can
-- just type `:lua vim.opt.cursorline=true`.
--
-- If you want to check the value of a setting, the easiest way is to use
-- another command, which does not require `:lua`. You use `:set <setting name>?`.
-- To to see what the current value for `vim.opt.cursorline` is, you type `:set cursorline?`
--
-- This command may either show you the word `cursorline` or it will show
-- `nocursorline`. This is because this setting is either on, or off, and that's
-- how Vim shows it.
--
-- If you try another setting, let's say `:set colorcolumn`, you will see either
-- the current value — `colorcolumn=80` or it will show no value, if the option
-- is unset (so `colorcolumn=` is what you see if `colorcolumn` is unset)
--
-- To understand more, you can read `:h vim-opt` and `:h set-option`
--
local settings = {
	clipboard = "unnamedplus", -- make use of the system clipboard
	colorcolumn = "80", -- show a column at 80 chars (it must be a string)
	cursorline = true, -- show cursorline
	expandtab = true, -- convert tabs to spaces
	ignorecase = true, -- ignore case when searching
	smartcase = true, -- make search smarter. if all lowercase, ignore it, but if you add any uppercase letter, becomes case sensitive
	mouse = "a", -- allow the mouse to work
	showmode = false, -- don't show -- INSERT --  or other modes in the status bar
	number = true, -- show line numbers
	numberwidth = 4, -- set number column width to 4
	pumheight = 10, -- set the maximum number of items to show in the completion menu
	relativenumber = false, -- disable relative numbers by default
	scrolloff = 40, -- the amount of lines that surround the cursorline
	sidescrolloff = 8, -- same as above, but for horizontal movement
	shiftwidth = 2, -- use 2 spaces when indenting
	shortmess = {
		A = true, -- don't give the "ATTENTION" message when an existing swap file is found.
		F = true, -- don't give the file info when editing a file, like `:silent` was used for the command; note that this also affects messages from autocommands
		I = true, -- don't give the intro message when starting Vim |:intro|.
		O = true, -- message for reading a file overwrites any previous message. Also for quickfix message (e.g., ":cn").
		T = true, -- truncate other messages in the middle if they are too long to fit on the command line.  "..." will appear in the middle. Ignored in Ex mode.
		W = true, -- don't give "written" or "[w]" when writing a file
		a = true, -- same as applying `filmnrwx` to shortmess. See :h shortmess for more info
		c = true, -- don't give |ins-completion-menu| messages.  For example, "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
		o = true, -- overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when 'autowrite' on)
		t = true, -- truncate file message at the start if it is too long to fit on the command-line, "<" will appear in the left most column. Ignored in Ex mode.
	},
	signcolumn = "yes", -- always show the sign column to avoid text shifting
	smartcase = true, -- use smart case for searches
	smartindent = true, -- try to keep indentation correct when pressing enter/return
	splitbelow = true, -- new horizontal splits on the bottom
	splitright = true, -- new vertical splits on the right
	tabstop = 2, -- use 2 spaces for a tab
	termguicolors = true, -- use true colors
	textwidth = 80, -- wrap text at 80 chars
	undofile = true, -- undo persist even if you close the file
	wrap = false, -- don't wrap text, make it a long line
	wildmenu = true, -- enhanced tab completion for the ex command line
	wildmode = "full:longest,list,full", -- complete the longest common part of the word
	wildignore = { -- When completing a command, ignore files that are…
		".hg,.git,.svn", -- …from Version control
		"*.jpg,*.bmp,*.gif,*.png,*.jpeg", -- …binary images
		"*.o,*.obj,*.exe,*.dll,*.manifest", -- …compiled object files
		"*.spl", -- …compiled spelling word lists
		"*.sw?", -- …Vim swap files
		"*.DS_Store", -- …OSX bullshit
		"*.pyc", -- …Python byte code
		"*.orig", -- …merge resolution files
		"*.rbc,*.rbo,*.gem", -- …compiled stuff from Ruby
		"*/vendor/*,*/.bundle/*,*/.sass-cache/*", -- …vendor files
		"*/node_modules/*", -- …JavaScript modules
		"package-lock.json", -- …package-lock.json
		"tags", -- …(c)tags files
	},
}

return settings
