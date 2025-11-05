--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Shared.Interfaces.Class)

-- Non-static types
type InstanceFieldsPublic = Class.BaseInstanceFieldsPublic & {
	-- public instance fields here
}

type InstanceFieldsPrivate = Class.BaseInstanceFieldsPrivate & {
	-- private instance fields here
}

type InstanceMethodsPublic<I> = Class.BaseInstanceMethodsPublic<I> & {
	toString: (self: I) -> string,
	objectMethod: (self: I) -> number
}

type InstanceMethodsPrivate<I> = Class.BaseInstanceMethodsPrivate<I> & {
	-- private instance methods
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods<I> = InstanceMethodsPrivate<I> & InstanceMethodsPublic<I>
export type InstancePublic<I> = InstanceMethodsPublic<I> & InstanceFieldsPublic

export type InstanceInternal = 
	InstancePublic<InstanceInternal> 
	& InstanceFieldsPrivate 
	& InstanceMethodsPrivate<InstanceInternal> 

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
	ClassPublic<InstanceInternal>
	& ClassMethodsPrivate<InstanceInternal>
	& ClassFieldsPrivate
	& InstanceMethods<InstanceInternal>
	
local Object = {} :: ClassInternal

-- Private static fields
Object.__index = Object
Object._instancesCreated = 0

-- Public static fields

-- Constructor
function Object.new()
	-- Init public & private fields
	local _o: InstanceFields = {
		_serialId = 0,
		_className = ""
	}

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

-- Public static methods
function Object.getInstanceCount()
	return Object._instancesCreated
end

-- Private static methods
function Object._incrementInstanceCount()
	Object._instancesCreated += 1
end

-- Private instance methods
-- function Object:_private()
-- 	return "some data"
-- end

-- Public instance methods
function Object:toString()
	return self._className .. " - OBJECT"
end

return Object :: ClassPublic<InstancePublic<InstanceInternal>>
