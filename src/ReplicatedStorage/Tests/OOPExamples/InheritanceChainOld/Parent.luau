--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Parent class
]]
local Super = require(script.Parent.Grandparent) -- inheriting from

local Parent = {}

export type Instance = typeof(setmetatable(
	{} :: {
		_serialId: number,
		_className: string,
		_super: typeof(Super),
	},
	Parent
))

-- Private static fields
Parent.__index = setmetatable(Parent, Super) -- inheritance
Parent._instanceCount = 0
--

-- Public static fields
--

-- Constructors
function Parent.new(): Instance
	-- Init public & private fields
	local self = setmetatable(Super.new() :: any, Parent) :: Instance

	-- Assign private fields
	self._serialId = Parent.getInstanceCount()
	self._className = "Parent"
	self._super = Super
	--

	-- Assign public fields
	--

	Parent._incrementInstanceCount()

	-- Return new instance
	return self
end
--

-- Public static methods
function Parent.getInstanceCount()
	return Parent._instanceCount
end
--

-- Private static methods
function Parent._incrementInstanceCount()
	Parent._instanceCount += 1
end
--

-- Private instance methods
--

-- Public instance methods
function Parent:parentMethod()
	return true
end
--

return Parent
