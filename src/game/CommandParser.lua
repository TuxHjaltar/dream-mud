local command = require "game.Command"

local CommandParser = class(function(self, player)
	self._lookupTable = {}
	self.player = player

	--TODO: implement
	self._lookupTable["ta"] = function(args)
		player:writeln("pickup")
	end

	self._lookupTable["gå"] = function(args)
		local to = player.room:getLink(tonumber(args))
		if to then
			player:enterRoom(to)
		else
			player:writeln("Dit kan du ju inte gå, din fjant!")
		end
	end

	self._lookupTable["prata"] = function(args)
		player:writeln("talk")
	end
end)

function CommandParser:parse(line)
	local cmd, args = unpack(utils.split(line, "%s+", false, 2))

	local cmdFunc = self._lookupTable[cmd]
	if not cmdFunc then 
		return nil
	else
		return command.new(cmdFunc, args)
	end
end

return CommandParser

