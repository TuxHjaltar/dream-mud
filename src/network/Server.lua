local socket = require "socket"

local Connection = require "network.Connection"


local Server = class(function(self, config)
	self.port = config.server_port

	print("Server starting on port " .. self.port)
	self._listener = socket.bind("*", self.port)
	
	self._connections = {}
end)

function Server:readall()

	local sockets = { self._listener }
	for sock, conn in pairs(self._connections) do
		table.insert(sockets, sock)
	end

	print("Selecting on " .. #sockets .. " sockets...")

	local socketsReady = socket.select(sockets, {})	
	print("Sockets ready: " .. #socketsReady)
	
	for i, sock in ipairs(socketsReady) do
		if sock == self._listener then
			-- insert the new connection into the connection table
			local newSocket = sock:accept()
			self._connections[newSocket] = Connection.new(newSocket)
		else
			conn = self._connections[sock]
			if not conn:read() then
				-- remove from the connection table
				self._connections[sock] = nil
			end
		end
	end
end

return Server

