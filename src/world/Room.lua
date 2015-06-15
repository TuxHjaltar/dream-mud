local Room = class(function(self, name, links, textEnter, textExit, textLook)
	self.links = links
	self.name = name
	self.players = {}
	self.items = {}

	self.textEnter = textEnter or self.textEnter
	self.textExit = textExit or self.textExit
	self.textLook = textLook or self.textLook
end)

-- Return string that will be displayed when this room is entered
function Room:textEnter(from)
	return "Du går till " .. self.name .. "."
end

function Room:textExit(to)
	return ""
end

function Room:textLook()
	return "Du ser dig omkring men ser inget intressant."
end

function Room:getLink(name)
	return self.links[name]	
end

function Room:enter(player)
	table.insert(self.players, player)
end

function Room:resolveLinks(rooms)
	local resolved = {}
	for i, room in pairs(self.links) do
		table.insert(resolved, rooms[room])
	end
	self.links = resolved
end

return Room

