--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Parent class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local Classes = Shared.Classes

local Types = require(script.Types)
local Super = require(Classes.Grandparent) -- inheriting from
local SuperTypes = require(Classes.Grandparent.Types)

local Parent = {} :: Types.ClassInternal

-- Private static fields
Parent.__index = setmetatable(Parent, Super) -- inheritance
Parent._instancesCreated = 0
--

-- Public static fields
--

-- Constructors
function Parent.new()
	-- Init public & private fields
	local _self: Types.InstanceFields = {
		_serialId = Parent.getInstanceCount(),
		_className = "Parent",
		_super = Super :: SuperTypes.ClassInternal, -- inheritance
	}

	local self = setmetatable((_self._super.new() :: any) :: Types.InstanceInternal, Parent)

	-- Assign private fields
	self._serialId = _self._serialId
	self._className = _self._className
	self._super = _self._super
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
	return Parent._instancesCreated
end
--

-- Private static methods
function Parent._incrementInstanceCount()
	Parent._instancesCreated += 1
end
--

-- Private instance methods
--

-- Public instance methods
--

return Parent :: Types.ClassPublic<Types.InstancePublic>
