local CommandParser = require "game.CommandParser"

local PlayerState = {
	Connected = 1,
	LoggedIn = 2,
	Disconnected = 3
}

local Player = class(function(self, id, world, connection)
	self.name = "Unknown"
	self.connection = connection
	self.world = world
	self.id = id
	self.commandParser = CommandParser.new(self)

	self.state = PlayerState.Connected

	function self.connection.onReceivedLine(line)
		if self.state == PlayerState.Connected then
			self.name = line
			print(self.name .. " connected")
			self:writeln("Välkommen, " .. line .. "! Du har ID " .. self.id .. ".")
			self.state = PlayerState.LoggedIn
			
			self.onLogin()
		elseif self.state == PlayerState.LoggedIn then
			local cmd = self.commandParser:parse(line)
			if cmd then cmd:execute()
			else self:writeln("Ja fattar ente :(") end
		end
		self:write("> ")
	end

	function self.connection.onDisconnect()
		print(self.name .. " disconnected.")
		self.onLogout()
	end
	
	function self.onLogin() end
	function self.onLogout() end

	self:write("Namn: ")
end)

function Player:write(text)
	self.connection:write(text)
end

function Player:writeln(text)
	self.connection:write(text .. "\n")
end

function Player:enterRoom(room)
	local oldRoom = self.room
	if oldRoom then
		self:writeln(oldRoom:textExit(room))
	end

	self.room = room
	self:writeln(self.room:textEnter(oldRoom))
	
	-- list links
	self:writeln("Du kan gå till: ")
	for i, linkedRoom in ipairs(room.links) do
		self:writeln(i .. ". " .. linkedRoom.name)
	end
end

return Player

