local Server = require "network.Server"

local Game = class(function(self)
	self.config = dofile("../config.lua")
	
	self.server = Server.new(self.config)
end)

function Game:run()
	while true do
		self.server:readall()
	end
end

return Game
