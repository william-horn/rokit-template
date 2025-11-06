--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Shared.Interfaces.Class)

local Super = nil

-- Non-static types
type InstanceFieldsPublic = Class.BaseInstanceFieldsPublic & {
	-- public instance fields here
}

type InstanceFieldsPrivate = Class.BaseInstanceFieldsPrivate & {
	-- private instance fields here
	-- _super: Super.ClassInternal, -- inheritance
}

type InstanceMethodsPublic = Class.BaseInstanceMethodsPublic & {
	toString: (self: any) -> string,
	objectMethod: (self: any) -> number
}

type InstanceMethodsPrivate = Class.BaseInstanceMethodsPrivate & {
	-- private instance methods
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods = InstanceMethodsPrivate & InstanceMethodsPublic
export type InstancePublic = InstanceMethodsPublic & InstanceFieldsPublic -- & Super.InstancePublic
export type InstanceInternal = InstancePublic & InstanceFieldsPrivate & InstanceMethodsPrivate

-- Static types
export type ClassFieldsPublic = Class.BaseClassFieldsPublic & {
	-- public static fields here
}

export type ClassFieldsPrivate = Class.BaseClassFieldsPrivate & {
	-- private static fields here
}

export type ClassMethodsPublic<O> = Class.BaseClassMethodsPublic<O> & {
	-- public static methods here
}

export type ClassMethodsPrivate<O> = Class.BaseClassMethodsPrivate<O> & {
	-- private static methods here
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
Object._instancesCreated = 0
--

-- Public static fields
--

-- Constructors
function Object.new()
	-- Init public & private fields
	local _o: InstanceFields = {
		_serialId = 0,
		_className = "",
		--_super = Super :: Super.ClassInternal
	}

	-- If inheriting:
	-- local o = setmetatable((_o._super.new() :: any) :: InstanceInternal, Object)
	local o = setmetatable(_o :: InstanceInternal, Object)

	-- Assign private fields
	o._serialId = Object.getInstanceCount()
	o._className = "Object"
	--

	-- Assign public fields
	--

	Object._incrementInstanceCount()

	-- Return new instance
	return o
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
function Object.toString(self: InstanceInternal)
	return self._className .. " - OBJECT"
end

function Object.objectMethod(self: InstanceInternal)
	return 100
end
--

return Object :: ClassPublic<InstancePublic>
