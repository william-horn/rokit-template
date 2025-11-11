--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Grandparent class
]]
local Classes = script.Parent

local Types = require(script.Types)
local Super = require(Classes.Object) -- inheriting from
local SuperTypes = require(Classes.Object.Types)

local Grandparent = {} :: Types.ClassInternal

-- Private static fields
Grandparent.__index = setmetatable(Grandparent, Super) -- inheritance
Grandparent._instancesCreated = 0
--

-- Public static fields
--

-- Constructors
function Grandparent.new()
	-- Init public & private fields
	local _self: Types.InstanceFields = {
		_serialId = Grandparent.getInstanceCount(),
		_className = "Grandparent",
		_super = Super :: SuperTypes.ClassInternal, -- inheritance
	}

	local self = setmetatable((_self._super.new() :: any) :: Types.InstanceInternal, Grandparent)

	-- Assign private fields
	self._serialId = _self._serialId
	self._className = _self._className
	self._super = _self._super
	--

	-- Assign public fields
	--

	Grandparent._incrementInstanceCount()

	-- Return new instance
	return self
end
--

-- Public static methods
function Grandparent.getInstanceCount()
	return Grandparent._instancesCreated
end
--

-- Private static methods
function Grandparent._incrementInstanceCount()
	Grandparent._instancesCreated += 1
end
--

-- Private instance methods
--

-- Public instance methods
function Grandparent.objectMethod(self: Types.InstanceInternal)
	return self._super.objectMethod(self) == 100
end
--

return Grandparent :: Types.ClassPublic<Types.InstancePublic>
