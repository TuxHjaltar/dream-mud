local Server = require "network.Server"
local PlayerManager = require "game.PlayerManager"

local Game = class(function(self)
	self.config = dofile("../config.lua")
	
	self.server = Server.new(self.config)
	self.playerManager = PlayerManager.new()
	
	function self.server.onConnection(connection)
		local player = self.playerManager:createPlayer(connection)

		function player.onLogin()
			print(player.name .. " logged in.")
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

