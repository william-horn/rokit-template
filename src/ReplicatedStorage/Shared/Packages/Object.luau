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
	test: number,
}

export type PrivateStaticFields = {
	__index: ClassInterface,
	_count: number,
}

export type PublicFields = {}

export type PrivateFields = {
	_privateField: string,
}

export type PublicStaticMethods = {}

export type PrivateStaticMethods = {
	_incrementCount: (self: ClassInterface) -> (),
}

export type PublicMethods = {
	toString: (self: Object) -> string,
}

export type PrivateMethods = {
	_privateMethod: (self: InternalInstanceInterface) -> (),
}

--[[
Public interface
]]
export type InstanceInterface = PublicFields & PublicMethods
export type InternalInstanceInterface = InstanceInterface & PrivateFields & PrivateMethods

--[[
Class interface (internal only)
]]
type ClassInterface =
	PublicMethods
	& PrivateMethods
	& PublicStaticMethods
	& PrivateStaticMethods
	& PrivateStaticFields
	& PublicStaticFields

--[[
Class

Create the class and assert that it follows the rules of the
static interface type, which describes what types the public
methods should be.
]]
local Object = {} :: ClassInterface

--[[
Instance type
]]
export type Instance = typeof(setmetatable({} :: InstanceInterface, Object))
export type InternalInstance = typeof(setmetatable({} :: InternalInstanceInterface, Object))

--[[
Public static field definitions
]]
Object.test = 10

--[[
Private static field definitions
]]
Object.__index = Object
Object._count = 0

--[[
Private static method definitions
]]
function Object:_incrementCount()
	self._count += 1
end

function Object:_privateMethod() end

--[[
Public method definitions
]]
function Object:toString()
	return "Object"
end

--[[
Public static method definitions
]]
local function new()
	-- Instance
	local self: InternalInstance = setmetatable({} :: InternalInstanceInterface, Object)

	-- Public
	--

	-- Private
	--

	Object:_incrementCount()
	return self :: InstanceInterface
end

local function getCount()
	local count: number = Object._count
	return count
end

local function is(object: any)
	return typeof(object) == "table" and getmetatable(object) == Object
end

return {
	is = is,
	new = new,
	getCount = getCount,
}
