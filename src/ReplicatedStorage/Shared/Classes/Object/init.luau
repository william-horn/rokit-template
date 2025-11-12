--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local Super = nil
local Types = require(script.Types)

local Object = {} :: Types.ClassInternal

-- Private static fields
Object.__index = setmetatable(Object, Super)
Object._instanceCount = 0
--

-- Public static fields
--

-- Constructors
function Object.new()
	-- Init public & private fields
	local _self: Types.InstanceFields = {
		_serialId = 0,
		_className = "",
		--_super = Super :: Super.ClassInternal
	}

	-- If inheriting:
	-- local self = setmetatable((_self._super.new() :: any) :: InstanceInternal, Object)
	local self = setmetatable(_self :: Types.InstanceInternal, Object)

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
	return Object._instanceCount
end
--

-- Private static methods
function Object._incrementInstanceCount()
	Object._instanceCount += 1
end
--

-- Private instance methods
--

-- Public instance methods
function Object.toString(self: Types.InstanceInternal)
	return self._className
end

function Object.getSerialId(self: Types.InstanceInternal)
	return self._serialId
end
--

return Object :: Types.ClassPublic<Types.InstancePublic>
