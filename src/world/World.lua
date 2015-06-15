local World = class(function(self, config)
	self.rooms = dofile(config.world_file)

	-- resolve links
	for identifier, room in pairs(self.rooms) do
		room:resolveLinks(self.rooms)
	end
end)


