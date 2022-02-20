# Nebula 🌌

> Nebula is a customizable Neovim configuration with friendly defaults for new comers

## Why Nebula?

Nebula is a project looking to provide a Neovim configuration that is fast,
easily customizable but also allows you to learn and understand what's happening
and how the configuration works.

I started working on Nebula when I was rewriting my Neovim configuration to make
use of the great Lua api. I came across a lot of other configuration sets that
provide very good defaults, but nothing that taught me how to write my own
configuration. So I decided to make a configuration that would try to not get in
your way and would allow you to slowly fully replace it.

The ultimate goal of Nebula is to allow you to have a starting point for your
configuration that's documented enough so you can understand what it does and
easily customize it, override it and finally remove it.

## Installing Nebula

Unlike many other Neovim configurations out there, Nebula works as a module.
This is to align with Nebula's philosophy of not being in the way and to be
easily removable. The recommended way to use Nebula is to use it as a submodule
to your own Neovim configuration.

```sh
cd ~/.config/nvim
# If you already have your configuration under version control you can ignore this  next command
git init
# Add Nebula as a submodule
git submodule add http://github.com/filipekiss/nebula.git lua/nebula
```

This will clone Nebula into the `lua/nebula` folder. To enable Nebula, edit your
`init.lua` file to require Nebula:

```lua
-- init.lua
require("nebula")
```

Restart Neovim and Nebula should be enabled.

## Customizing Nebula

Nebula aims to be a easily extendable configuration. To achieve that, Nebula
tries to be as transparent as possible, allowing you to work closely to the Lua
API as possible. Everything Nebula lives in the `lua/nebula/` folder and these
files should not be changed. Whenever Nebula is updated, these files might be
overwritten with the latest configuration, so you might lose your
customizations.

Nebula when loading it's own settings, will look for some special files to
either extend or override. These files need to be in the folder `lua/user/`,
otherwise Nebula won't find them. Below you'll find a list of all the files that
Nebula loads when doing it's setup and how you can use that to customize your
own setup.

By default, when Nebula finds a file in the `lua/user` folder that exports a
table with the options, it will extend Nebula settings. That way, you can just
add the options you want to change instead of having to write everything on your
own.

On the other hand, if you find yourself always undoing the defaults and would
rather skip Nebula for some of the default settings, you can add a special key
to the file in your `lua/user` folder, named `nebula_override` with the value
`true`. Having this key set, Nebula will completely ignore the options that are
shipped with with and will use only what you have provided.

#### settings.lua

|        Nebula File        |        User File        |
| :-----------------------: | :---------------------: |
| `lua/nebula/settings.lua` | `lua/user/settings.lua` |

The first file loaded by Nebula is the settings file. This file is responsible
for changing some behaviours from Neovim to things that make the usage a bit
easier. You can check the file located in `lua/nebula/settings.lua` to see what
changes are being applied.

To customize your own settings, you can create a file in
`lua/user/settings.lua`. This file must return a table with the settings you
wish to change.

##### Example

```lua
-- lua/user/settings.lua
local settings = {
    cursorline = false, -- disable current line highlght (enabled by default)
    colorcolumn = "80,120", -- add a guide line at 80 and 120 chars (80 by default)
}

return settings
```

## Other projects

You can check out these other configurations that offer a similar experience to
Nebula and served as inspiration to create this project

- [AstroVim](https://github.com/kabinspace/AstroVim) - AstroVim is an aesthetic and feature-rich neovim config that is extensible and easy to use with a great set of plugins

- [LunarVim](https://github.com/LunarVim/LunarVim/) - An IDE layer for Neovim with sane defaults. Completely free and community driven.

- [NvChad](https://github.com/NvChad/NvChad) - An attempt to make neovim cli as functional as an IDE while being very beautiful, blazing fast startuptim

---

**filipekiss/nebula** © 2022+, Released under the [Blue Oak License][license].

> Authored and maintained by Filipe Kiss with help from [contributors].

[license]: LICENSE.md
[contributors]: http://github.com/filipekiss/nebula/contributors