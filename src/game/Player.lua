local PlayerState = {
	Connected = 1,
	LoggedIn = 2,
	Disconnected = 3
}

local Player = class(function(self, id, connection)
	self.name = "Unknown"
	self.connection = connection
	self.id = id

	self.state = PlayerState.Connected

	function self.connection.onReceivedLine(line)
		if self.state == PlayerState.Connected then
			self.name = line
			print(self.name .. " connected")
			self:writeln("Välkommen, " .. line .. "! Du har ID " .. self.id .. ".")
			self.state = PlayerState.LoggedIn
			
			self.onLogin()
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

