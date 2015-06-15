local command = require "game.Command"

local CommandParser = class(function(self, player)
	self._lookupTable = {}

	--TODO: implement
	self._lookupTable["plocka_upp"] = function()
		print("pickup")
	end

	self._lookupTable["gå_till"] = function()
		print("go")
	end

	self._lookupTable["prata_med"] = function()
		print("talk")
	end
end)

function CommandParser:parse(line)
	local start, finish, cmd = string.find(line, "(.- .-) ")
	if cmd == nil then
		print "cw command"
		return nil
	end

	local args = string.sub(line, finish+1)
	cmd = string.gsub(cmd, "%s", "_")
	cmd = string.sub(cmd, 1, -1)

	local cmdFunc = self._lookupTable[cmd]
	if not cmdFunc then 
		print "Invalid command"
		return nil
	else
		return command.new(cmdFunc, args)
	end
end

return CommandParser
