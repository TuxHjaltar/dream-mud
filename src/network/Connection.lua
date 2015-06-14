local BUFFER_SIZE = 10

local Connection = class(function(self, socket)
	print("new connection from " .. socket:getsockname())

	self.socket = socket
	self.socket:settimeout(0)

	self._buffer = ""
	
	function self.onReceivedLine() end
	function self.onDisconnect() end

	self.open = true
end)

function Connection:read()
	local data, err, partial = self.socket:receive(BUFFER_SIZE)
	if data then
		self._buffer = self._buffer .. data
	elseif err == "timeout" then
		self._buffer = self._buffer .. partial
	elseif err == "closed" then
		print("<closed>")
		self:_handleConnectionClosed()
		return false -- dead; remove from connection list
	else
		print("<unknown error>")
	end

	self:_checkBuffer()

	return true -- still alive
end

function Connection:_handleConnectionClosed()
	self.open = false
	self.onDisconnect()
end

function Connection:_checkBuffer()
	local lines = utils.split(self._buffer, "\r\n", true)
	while #lines > 0 and (#lines > 1 or self._buffer:sub(-2) == "\r\n") do
		-- please forgive me; I was tired and hungry
		self.onReceivedLine(table.remove(lines, 1))
	end
	
	self._buffer = #lines > 0 and lines[1] or ""
end

function Connection:write(data)
	self.socket:send(data)
end

return Connection

