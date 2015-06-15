local command = require "game.Command"

local CommandParser = class(function(self, player)
	self._lookupTable = {}
	self.player = player

	--TODO: implement
	self._lookupTable["ta"] = function()
		player:writeln("pickup")
	end

	self._lookupTable["gå"] = function()
		player:writeln("go")
	end

	self._lookupTable["prata"] = function()
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

