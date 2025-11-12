--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)
local Super = nil

-- Non-static types
export type InstanceFieldsPublic = {
	-- public instance fields here
}

export type InstanceFieldsPrivate = {
	-- private instance fields here
	_serialId: number,
	_className: string,
	-- _super: SuperType.ClassInternal, -- inheritance
}

export type InstanceMethodsPublic = {
	toString: (self: any) -> string,
	getSerialId: (self: any) -> number,
}

export type InstanceMethodsPrivate = {
	-- private instance methods
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods = InstanceMethodsPrivate & InstanceMethodsPublic
export type InstancePublic = InstanceMethodsPublic & InstanceFieldsPublic -- & SuperType.InstancePublic
export type InstanceInternal = InstancePublic & InstanceFieldsPrivate & InstanceMethodsPrivate

-- Static types
export type ClassFieldsPublic = {
	-- public static fields here
}

export type ClassFieldsPrivate = {
	-- private static fields here
	__index: Table.Map<string, any>,
	_instanceCount: number,
}

export type ClassMethodsPublic<O> = {
	-- public static methods here
	new: () -> O,
	getInstanceCount: () -> number,
}

export type ClassMethodsPrivate<O> = {
	-- private static methods here
	_incrementInstanceCount: () -> (),
}

export type ClassPublic<O> = ClassFieldsPublic & ClassMethodsPublic<O>

export type ClassInternal =
	ClassPublic<InstancePublic>
	& ClassMethodsPrivate<InstancePublic>
	& ClassFieldsPrivate
	& InstanceMethods

local Object = {} :: ClassInternal

-- Private static fields
Object.__index = setmetatable(Object, Super)
Object._instanceCount = 0
--

-- Public static fields
--

-- Constructors
function Object.new()
	-- Init public & private fields
	local _self: InstanceFields = {
		_serialId = 0,
		_className = "",
		--_super = Super :: Super.ClassInternal
	}

	-- If inheriting:
	-- local self = setmetatable((_self._super.new() :: any) :: InstanceInternal, Object)
	local self = setmetatable(_self :: InstanceInternal, Object)

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
function Object.toString(self: InstanceInternal)
	return self._className
end

function Object.getSerialId(self: InstanceInternal)
	return self._serialId
end
--

return Object :: ClassPublic<InstancePublic>
