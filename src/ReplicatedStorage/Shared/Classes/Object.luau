--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Table = require(ReplicatedStorage.Shared.Types.Table)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
-- local Super = nil

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
	getId: (self: any) -> number,
	getClassName: (self: any) -> string,
}

export type InstanceMethodsPrivate = {
	-- private instance methods
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods = InstanceMethodsPrivate & InstanceMethodsPublic
export type InstancePublic = InstanceMethodsPublic & InstanceFieldsPublic
export type InstancePrivate = InstanceMethodsPrivate & InstanceFieldsPrivate
export type InstanceInternal = InstancePublic & InstancePrivate

-- Static types
export type ClassFieldsPublic = {
	-- public static fields here
}

export type ClassFieldsPrivate = {
	-- private static fields here
}

export type ClassMethodsPublic<O> = {
	-- public static methods here
	new: () -> O,
}

-- We pass a generic type "O" in case a class method accepts any instance parameters
export type ClassMethodsPrivate<O> = {
	-- private static methods here
}

export type ClassPublic<O> = ClassFieldsPublic & ClassMethodsPublic<O> & newClass.ClassTemplatePublic

export type ClassInternal =
	ClassPublic<InstancePublic>
	& ClassMethodsPrivate<InstancePublic>
	& ClassFieldsPrivate
	& InstanceMethods
	& newClass.ClassTemplatePrivate

local Object = newClass("Object") :: ClassInternal

-- Private static fields
-- Object._foo = "bar"
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

	Object:_incrementInstanceCount()

	-- Assign private fields
	self._serialId = Object:getInstanceCount()
	self._className = Object:getClassName()
	--

	-- Assign public fields
	--

	-- Return new instance
	return self
end
--

-- Public static methods
--

-- Private static methods
--

-- Private instance methods
--

-- Public instance methods
function Object.toString(self: InstanceInternal)
	return self._className .. "#" .. self:getId()
end

function Object.getId(self: InstanceInternal)
	return self._serialId
end

function Object.getClassName(self: InstanceInternal)
	return self._className
end
--

return Object :: ClassPublic<InstancePublic>
