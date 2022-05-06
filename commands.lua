local add_command = require("nebula.helpers.nvim").add_user_command

add_command("ReloadPlugins", Nebula.load_plugins)
