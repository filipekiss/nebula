# Nebula - Plugins

Nebula uses [packer.nvim](https://github.com/wbthomason/packer.nvim) to manage plugins and colorschemes. If you have
doubts of what some keys might mean, please, check their documentation. All
custom keys that are used by Nebula will be explained in this document.

## What is a plugin?

Nebula considers a plugin anything that can be used to extend or change Neovim's
behavior or appearance. That means that, for Nebula, colorschemes (also known as
"themes" for other editors) are also considered plugins.

## Disabling Nebula plugins

If you wish to disable any plugin that ships with Nebula, you can use the
`Nebula` configuration object during the call to `Nebula.init()`:

```lua
-- init.lua
require("nebula")
Nebula.init({
    active_plugins = {
        autopairs = false
      }
  })
```

The key is the filename of the plugin in `lua/nebula/plugins/` folder, so the
above code disables `lua/nebula/plugins/autopairs.lua`

## Loading plugin files

Nebula makes it quite easy to add plugins. It has a few helper functions that
allow you to organize your plugins the way you think it's best, so unlike other
options like `mappings` and `settings`, Nebula will almost never load anything
automatically when it comes to plugins. The only case where Nebula will try to
load something from `lua/user/plugins` is when you wish to override the settings
for plugins that are shipped with Nebula.

## Adding a new plugin

Adding a plugin is done in your `init.lua` file, right before you require
Nebula. There is a helper function from Nebula that registers the plugins to be
used when Nebula does it setup, and that's what you should use.

If you need examples, you can take a look at the files in `lua/nebula/plugins/`,
except for the `init.lua` in that folder, which is responsible for bootstraping
the plugins themselves.

Here's an example on how to add the [better-escape.nvim](https://github.com/max397574/better-escape.nvim) plugin:

```lua
-- lua/user/plugins/better_escape.lua

local better_escape = {
"https://github.com/max397574/better-escape.nvim",
config = function()
require("better_escape").setup()
  }

return better_escape
```

The file must return a table that can be used by `packer.use` to load and
configure the plugin. For more information on what that looks like, please check
[packer's README](https://github.com/wbthomason/packer.nvim#specifying-plugins).

And in your `init.lua`, you add the plugin before calling `Nebula.init()`:

```lua
-- init.lua

Nebula = require("nebula")

Nebula.plugin("better_escape")

Nebula.init()
```

## Adding new colorschemes

Even though colorschemes are technically plugins, we chose to keep them in a
separate folder for convenience.

Here's an example of how to add the [Rose Pine](https://github.com/rose-pine/neovim/) theme and set Nebula to use it:

```lua
-- lua/user/colorschemes/rosepine.lua

local rosepine = {
  "https://github.com/rose-pine/neovim/",
  as = "rose-pine"
  }

return rosepine
```

And in your `init.lua`:

```lua
-- init.lua
-- ...
Nebula = require("nebula")

Nebula.colorscheme("rosepine")

Nebula.init({ colorscheme = "rose-pine" })
```

Restart your Neovim and run `:PackerInstall` and you're done!
