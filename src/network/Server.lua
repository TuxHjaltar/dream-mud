local socket = require "socket"

local Connection = require "network.Connection"


local Server = class(function(self, config)
	self.port = config.server_port

	print("Server starting on port " .. self.port)
	self._listener = socket.bind("*", self.port)
	
	self._connections = {}

	function self.onConnection() end
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
			local newConnection = Connection.new(newSocket)
			self._connections[newSocket] = newConnection

			-- invoke event
			self.onConnection(newConnection)
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

