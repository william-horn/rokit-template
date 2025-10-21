--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Shared = ReplicatedStorage.Shared
-- local TableType = require(Shared.Types.Table)

export type PublicStaticFields = {
	publicStaticField: string,
}

export type PrivateStaticFields = {
	__index: InternalClassInterface,
	_count: number,
}

export type PublicFields = {
	publicField: string,
}

export type PrivateFields = {
	_privateField: string,
}

export type PublicStaticMethods = {
	publicStaticMethod: () -> (),
	new: () -> InstanceInterface,
	getCount: () -> number,
	is: (object: any) -> boolean,
}

export type PrivateStaticMethods = {
	_incrementCount: () -> (),
}

export type PublicMethods = {
	toString: (self: NonStaticDomain) -> string,
}

export type PrivateMethods = {
	_privateMethod: (self: InternalInstance) -> (),
}

export type StaticDomain = PrivateStaticMethods & PrivateStaticFields & PublicStaticFields & PublicStaticMethods
export type NonStaticDomain = PublicFields & PrivateFields & PublicMethods & PrivateMethods

--[[
Public interface
]]
export type InstanceInterface = PublicFields & PublicMethods
export type InternalInstanceInterface = InstanceInterface & PrivateFields & PrivateMethods

--[[
Class interface (internal only)
]]
export type ClassInterface = PublicStaticFields & PublicStaticMethods
export type InternalClassInterface =
	ClassInterface
	& PrivateStaticFields
	& PrivateStaticMethods
	& PublicMethods
	& PrivateMethods

--[[
Class

Create the class and assert that it follows the rules of the
static interface type, which describes what types the public
methods should be.
]]
local Object = {} :: InternalClassInterface

--[[
Public static fields
]]
Object.publicStaticField = "test"

--[[
Private static fields
]]
Object.__index = Object
Object._count = 0

--[[
Instance type
]]
export type Instance = typeof(setmetatable({} :: InstanceInterface, Object))
export type InternalInstance = typeof(setmetatable({} :: InternalInstanceInterface, Object))

--[[
Public static method
]]
function Object.publicStaticMethod() end

--[[
Private static method definitions
]]
function Object._incrementCount()
	Object._count += 1
end

--[[
Private method definitions
]]
function Object:_privateMethod() end

--[[
Public static method definitions
]]
function Object.new()
	-- Instance
	local self: InternalInstance = setmetatable({} :: InternalInstanceInterface, Object)

	-- Public
	--

	-- Private
	--

	Object._incrementCount()
	return self :: InstanceInterface
end

function Object.getCount()
	return Object._count
end

function Object.is(object: any)
	return typeof(object) == "table" and getmetatable(object) == Object
end

return Object :: ClassInterface
