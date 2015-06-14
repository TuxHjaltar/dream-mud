#!/usr/bin/lua

-- global includes :3
class = require "util.Class"
require "pl"

-- start this goshdarn game thing
local Game = require "game.Game"

local game = Game.new()
game:run()

