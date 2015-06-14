local Command = class(function(self, command, args)
	self.command = command
	self.args = args
end)

function Command:execute()
	self.command(self.args)
end

return Command
