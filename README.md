# Nebula 🌌

> Nebula is a NeoVim configuration framework

### Disclaimer

Although I consider Nebula ready to use, I'm still experimenting with it. That
means that APIs might change and documentation might be lacking. Feel free to
[start a discussion](https://github.com/filipekiss/nebula/discussions) or [open an issue](https://github.com/filipekiss/nebula/issues)

## Why Nebula?

Nebula was born as Yet Another Neovim Configuration™, with it's own sets of
defaults and a bunch of plugins and some helper functions to help you configure
Neovim. After some feedback, I decided to separate the confiugration I was
building from all the functions I had written to do it so. Thus, Nebula was
reborn.

Nebula no longer ships with any configuration pre-made. It does still have some
code to "configure" Nebula, but all that does is look for specific user files to
load them. Nebula won't change mappings, won't add plugins, won't even add
colors.

Nebula is like training wheels on your bike. It should be there until you don't
need it anymore.

## Installing Nebula

Nebula is just a module with some functions to make things a bit easier. You
should add it to you `lua/` folder in you Neovim configuration directory (by
default that is `~/.config/nvim`).

Here's how you can do that using git:

```sh
cd ~/.config/nvim
# If you already have your configuration under version control you can ignore this  next command
git init
# Add Nebula as a submodule
git submodule add http://github.com/filipekiss/nebula.git lua/nebula
```

Now you can use the Nebula helpers to write your own configuration.

## Mappings

Let's do some mappings. You may think of them as 'shortcuts' coming from other
editors, but maps are a bit more powerful than that. If you want to know more
about how mapping workg in (Neo)vim, there are [some](https://learnvimscriptthehardway.stevelosh.com/chapters/03.html) [great](https://learnvimscriptthehardway.stevelosh.com/chapters/04.html) [writings](https://learnvimscriptthehardway.stevelosh.com/chapters/05.html) by
Steve Losh in [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/). I highly recommend it.

But if you're looking for a not-so-hard way to do it, let's writing some
mappings of our own.

I like to keep my configuration separate, so I'll create a file for the
mappings:

```lua
-- ~/.config/nvim/lua/user/mappings.lua
local nnoremap = require("nebula.helpers.mappings").nnoremap

nnoremap("H", "^")
```

The map above allows us to go to the beggining of the line by pressing
<kbd>Shift</kbd>+<kbd>h</kbd>. As you can see, the mappings are case-sensitive,
so <kbd>h</kbd> is not the same as <kbd>H</kbd> (<kbd>h</kbd> will move you
one-character to the left, <kbd>H</kbd>, by default, sends you to the most
top-line of the window. After we re-map it, it moves you to the first char on
the current line)

Now that we created the file, let's make sure it loads when Neovim initializes:

```lua
-- ~/.config/nvim/init.lua

require("user.mappings")
```

Now we are going to save the file and load it into Neovim. To do that, press
<kbd>Esc</kbd> to go into normal mode and type `:w | source %` and press enter.
This command will save the file and `source` it, which basically means that will
load and run the contents of the file.

When the `init.lua` file is sourced, it `requires` the `lua/user/mappings.lua`
file and runs it, making our mapping work. If you put your cursos at the end of
the line and press <kbd>H</kbd>, it should jump to the beggining of the line.

You can add different mappings for different modes. Nebula has helpers that
matches all the VimScript mapping commands (`nmap`, `nnoremap`, `imap` and so
on).

This is so if you see a mapping on someone elses Vim configuration you can
easily adapt to use in your on:

```vim
nnoremap L $
```

becomes

```lua
nnoremap("L", "$")
```

You only need to use the require statement one, at the beggining of you file, so
I left it out the second example.

> 🧑🏻‍💻 I promise I'll write documentation for all the APIs in Nebula, they are
> coming

---

**filipekiss/nebula** © 2022+, Released under the [Blue Oak License][license].

> Authored and maintained by Filipe Kiss with help from [contributors].

[license]: LICENSE.md
[contributors]: http://github.com/filipekiss/nebula/contributors
