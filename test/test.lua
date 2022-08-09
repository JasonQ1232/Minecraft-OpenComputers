local shell = require "shell"
local os = require("os")
local term = require("term")

local t = shell.execute("echo hello world.")
term.write("t = " ..  t)