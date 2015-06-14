local Room = class(function(self, name, links)
	self.links = links
	self.name = name
	self.players = {}
	self.items = {}
end)

-- Return string that will be displayed when this room is entered
function Room:onEnter()
	return "Välkommen till " .. self.name
end

function Room:onExit()
	return ""
end

function Room:getLink(name)
	return self.links[name]	
end

function Room:enter(player)
	table.insert(self.players, player)
end

return Room
