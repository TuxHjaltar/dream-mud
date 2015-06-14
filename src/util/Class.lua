local function Class(constructor)
	local class = {}
	class.__index = class

	function class.new(...)
		local object = {}
		setmetatable(object, class)
		constructor(object, ...)
		return object
	end

	return class
end

return Class
