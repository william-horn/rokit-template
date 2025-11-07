--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local Object = {}

export type Instance = typeof(setmetatable(
	{} :: {
		_serialId: number,
		_className: string,
	},
	Object
))

-- Private static fields
Object.__index = Object
Object._instancesCreated = 0
--

-- Public static fields
--

-- Constructors
function Object.new(): Instance
	local self = setmetatable({}, Object)

	-- Assign private fields
	self._serialId = Object.getInstanceCount()
	self._className = "Object"
	--

	-- Assign public fields
	--

	Object._incrementInstanceCount()

	-- Return new instance
	return self
end
--

-- Public static methods
function Object.getInstanceCount()
	return Object._instancesCreated
end
--

-- Private static methods
function Object._incrementInstanceCount()
	Object._instancesCreated += 1
end
--

-- Private instance methods
--

-- Public instance methods
function Object:toString()
	return self._className
end

function Object:objectMethod()
	return 100
end
--

return Object
