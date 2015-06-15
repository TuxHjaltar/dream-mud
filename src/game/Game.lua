local Server = require "network.Server"
local PlayerManager = require "game.PlayerManager"
local World = require "world.World"

local Game = class(function(self)
	self.config = dofile("../config.lua")
	
	self.world = World.new(self.config)
	self.server = Server.new(self.config)
	self.playerManager = PlayerManager.new(self.world)
	
	function self.server.onConnection(connection)
		local player = self.playerManager:createPlayer(connection)

		function player.onLogin()
			print(player.name .. " logged in.")
			player:enterRoom(self.world:getRoom("d_gang"))
		end
		function player.onLogout()
			print(player.name .. " logged out.")
			self.playerManager:deletePlayer(player)
		end
	end
end)

function Game:run()
	while true do
		self.server:readall()
	end
end

return Game

