local Room = require "world.Room"

local World = class(function(self, config)
	local worldFile, err = loadfile(config.world_file, "text", { Room = Room })
	if not worldFile then
		print("World loading error: " .. err)
		return
	end

	self.rooms = worldFile()

	-- resolve links
	for identifier, room in pairs(self.rooms) do
		room:resolveLinks(self.rooms)
	end
end)

function World:getRoom(name)
	return self.rooms[name]
end

return World

