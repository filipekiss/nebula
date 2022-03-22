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

## Changing plugin settings

Nebula ships with some plugins by default and has some settings to make it
usable out of the box. But since the goal is ultimate customization, I wanted to
make things easy to change. There are two ways to customize plugins, one which
is a little bit simpler but is very specific to Nebula, and a more advanced way
that allows you to customize anything about the plugin and you can re-use the
configuration if you ever decide to ditch Nebula.

### Changing Nebula Plugin Settings

These settings are loaded by Nebula (usually) during the `config` step of the
plugin. These options are **always** merged, so if you wish to change it in a
way that the plugin doesn't load any Nebula settings, see the [Advanced Plugin
Customization](#advanced-plugin-customization) section.

The plugins are customized using the `Nebula.plugin_options` table. You just
need to add a key with the plugin name. To change the `prompt_prefix` option
from Telescope, you can do the following:

```
--- init.lua
Nebula = require("nebula")
Nebula.plugin_options.telescope = {
    defaults = {
      prompt_prefix = "> "
    }
  }
Nebula.init()
```

As you can see, the table set in `Nebula.plugin_options.telescope` is the same
used by `telescope.setup()` function. I always try to keep Nebula customization
as close to the original plugin as possible, since that will allow you to easily
drop Nebula and re-use the configuration in your own setup.

I'll update the documentation with all the options for every plugin that ships
with Nebula in a later date.

### Advanced Plugin Customization

Since Nebula's goal is to get out of your way, when it comes to customize
plugins I tried to make it simple yet powerful. The `Nebula.plugin_options`
exists so people who are happy with Nebula default configuration can just change
one or two things, but if you wish to undo a lot of Nebula customization or do
some more advanced stuff, you should configure plugins using the advanced
configuration. 

Much like [adding a new plugin](#adding-a-new-plugin), customizing a plugin that ships with Nebula
works just the same. To customize Telescope, create a file in
`lua/user/plugins/telescope.lua`, which returns a table that can be used by
`packer.nvim`, much like adding a new plugin. This table will be merged with
Nebula default table and everything that you set on your table will override
Nebula's default table. So if you want to override the whole `config` for
Telescope, you can do the following:

```
--- lua/user/plugins/telescope.lua
return {
  config = function()
   --- ... your custom config function here
  end
}
```

This will merge your Telescope configuration with the one shipped with Nebula,
keeping  you `config` instead of the one we ship. 

This also allows you to use your own fork of any the shipped plugins. Let's say
you have your own fork of Telescope that you wish to use, but you wish to keep
Nebula's configuration. All you have to do is return a table with the first
element being the repository URL of your own fork:

```
--- lua/user/plugins/telescope.lua
return {
  "https://github.com/my-user/my-telescope-fork"
}
```

This will use the repository to install the telescope plugin from this URL, but
will still use Nebula configuration for it.
