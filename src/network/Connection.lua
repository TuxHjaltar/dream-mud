
local Connection = class(function(self, socket)
	print("new connection from " .. socket:getsockname())

	self.socket = socket
	self.socket:settimeout(0)
	
	self.open = true
end)

function Connection:read()
	print("received from " .. self.socket:getsockname() .. ": ")
	local data, err, partial = self.socket:receive(10)
	if data then
		print(data)
	elseif err == "timeout" then
		print(partial)
	elseif err == "closed" then
		print("<closed>")
		self.open = false
		return false -- dead; remove from connection list
	else
		print("<unknown error>")
	end
	return true -- still alive
end

return Connection
