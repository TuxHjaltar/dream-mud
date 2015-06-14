local BUFFER_SIZE = 10

local Connection = class(function(self, socket)
	print("new connection from " .. socket:getsockname())

	self.socket = socket
	self.socket:settimeout(0)

	self._buffer = ""
	
	self.open = true
end)

function Connection:receive()
	local data, err, partial = self.socket:receive(BUFFER_SIZE)
	if data then
		self._buffer = self._buffer .. data
	elseif err == "timeout" then
		self._buffer = self._buffer .. partial
	elseif err == "closed" then
		print("<closed>")
		self.open = false
		return false -- dead; remove from connection list
	else
		print("<unknown error>")
	end

	self:_checkBuffer()

	return true -- still alive
end

function Connection:_checkBuffer()
	local lines = utils.split(self._buffer, "\n", true)
	while #lines > 0 and (#lines > 1 or self._buffer:sub(-1) == "\n") do
		-- please forgive me; I was tired and hungry
		print("line from " .. self.socket:getsockname() .. ": " .. table.remove(lines, 1))
	end
	
	self._buffer = #lines > 0 and lines[1] or ""
end

function Connection:send(data)
	self.socket:send(data)
end

return Connection
