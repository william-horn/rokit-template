--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local TableType = require(Shared.Types.Table)

-- Non-static types
type ObjectMethods<ObjectInstance> = {
	toString: (self: ObjectInstance) -> string,
}

type ObjectFields = {}

type ObjectFieldsPrivate = {
	_serialNumber: number,
}

type ObjectMethodsPrivate = {
	-- _private: (self: ObjectInstancePrivate) -> string,
}

export type ObjectInstance = ObjectMethods<ObjectInstancePrivate> & ObjectFields
type ObjectInstancePrivate = ObjectInstance & ObjectFieldsPrivate & ObjectMethodsPrivate

-- Static types
export type ObjectClass<ObjectInstance> = {
	new: () -> ObjectInstance,
	getInstanceCount: () -> number,
}

type ObjectClassPrivate = ObjectClass<ObjectInstance> & ObjectMethods<ObjectInstancePrivate> & ObjectMethodsPrivate & {
	__index: TableType.Map<string, any>,
	_instancesCreated: number,
	_instancesDestroyed: number,
	_className: string,
	_incrementInstanceCount: () -> (),
}

local Object = {} :: ObjectClassPrivate

-- Private static fields
Object.__index = Object
Object._instancesCreated = 0
Object._instancesDestroyed = 0
Object._className = "Object"

-- Public static fields

-- Constructor
function Object.new()
	-- Init public & private fields
	local _o: ObjectFieldsPrivate & ObjectFields = {
		_serialNumber = Object.getInstanceCount(),
	}

	-- Create instance
	local o = setmetatable(_o :: ObjectInstancePrivate, Object)

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
	return Object._className
end

return Object :: ObjectClass<ObjectInstance>
