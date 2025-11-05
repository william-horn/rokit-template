--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Shared.Interfaces.Class)

-- Non-static types
type ObjectMethods<O> = {
	toString: (self: O) -> string,
	objectMethod: (self: O) -> number
}

type ObjectFields = {}

type ObjectFieldsPrivate = {
	-- private instance fields
}

type ObjectMethodsPrivate<O> = {
	-- private instance methods
}

export type ObjectInstance<O> = ObjectMethods<O> & ObjectFields
export type ObjectInstancePrivate = 
	ObjectInstance<ObjectInstancePrivate> 
	& ObjectFieldsPrivate 
	& ObjectMethodsPrivate<ObjectInstancePrivate> 
	& Class.ObjectPrivateInterface<ObjectInstancePrivate>

-- Static types
export type ObjectClass<O> = Class.ClassPublicInterface<O> & {
	-- public static types here
}

export type ObjectClassPrivate =
	ObjectClass<ObjectInstance<ObjectInstancePrivate>>
	& ObjectMethods<ObjectInstancePrivate>
	& ObjectMethodsPrivate<ObjectInstancePrivate>
	& Class.ClassPrivateInterface<ObjectInstancePrivate>
	& {
		-- private static types here
	}

local Object = {} :: ObjectClassPrivate

-- Private static fields
Object.__index = Object
Object._instancesCreated = 0
Object._instancesDestroyed = 0

-- Public static fields

-- Constructor
function Object.new()
	-- Init public & private fields
	local o = setmetatable({} :: ObjectInstancePrivate, Object)
	o._serialNumber = Object.getInstanceCount()
	o._className = "Object"

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
	return self._className
end

return Object :: ObjectClass<ObjectInstance<ObjectInstancePrivate>>
