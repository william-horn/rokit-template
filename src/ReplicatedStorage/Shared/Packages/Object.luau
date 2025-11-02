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
	test: (self: ObjectInstance) -> number,
}

type ObjectFields = {
	key: string,
}

type ObjectFieldsPrivate = {
	_id: number,
}

type ObjectMethodsPrivate = {
	_private: (self: ObjectInstancePrivate) -> string,
}

export type ObjectInstance = ObjectMethods<ObjectInstancePrivate> & ObjectFields
type ObjectInstancePrivate = ObjectInstance & ObjectFieldsPrivate & ObjectMethodsPrivate

-- Static types
export type ObjectClass<ObjectInstance> = {
	new: () -> ObjectInstance,
	static: () -> number,
	className: string,
}

type ObjectClassPrivate = ObjectClass<ObjectInstance> & ObjectMethods<ObjectInstancePrivate> & ObjectMethodsPrivate & {
	__index: TableType.Map<string, any>,
	_count: number,
}

local Object = {} :: ObjectClassPrivate

-- Private static fields
Object.__index = Object
Object._count = 0

-- Public static fields
Object.className = "Object"

-- Constructor
function Object.new()
	-- Init public & private fields
	local _o: ObjectFieldsPrivate & ObjectFields = {
		_id = 0,
		key = "",
	}

	-- Create instance
	local o = setmetatable(_o :: ObjectInstancePrivate, Object)

	-- Return new instance
	return o
end

-- Public static methods
function Object.static()
	return Object._count
end

-- Private instance methods
function Object:_private()
	return "some data"
end

-- Public instance methods
function Object:test()
	print(self:_private())
	return self._id
end

return Object :: ObjectClass<ObjectInstance>
