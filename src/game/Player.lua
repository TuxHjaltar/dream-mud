local CommandParser = require "game.CommandParser"

local PlayerState = {
	Connected = 1,
	LoggedIn = 2,
	Disconnected = 3
}

local Player = class(function(self, id, connection)
	self.name = "Unknown"
	self.connection = connection
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
			else self:writeln("Vad fan vill du?") end
		end
	end

	function self.connection.onDisconnect()
		print(self.name .. " disconnected.")
		self.onLogout()
	end
	
	function self.onLogin() end
	function self.onLogout() end

	self:write("VA HETER DU?\nNamn: ")
end)

function Player:write(text)
	self.connection:write(text)
end

function Player:writeln(text)
	self.connection:write(text .. "\n")
end


return Player

