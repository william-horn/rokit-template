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
	_count: number,
}

export type PublicFields = {
	publicField: string,
}

export type PrivateFields = {
	_privateField: string,
}

export type PublicStaticMethods = {
	publicStaticMethod: (self: StaticDomain) -> (),
	new: () -> InstanceInterface,
	getCount: () -> number,
	is: (object: any) -> boolean,
}

export type PrivateStaticMethods = {
	_incrementCount: (self: StaticDomain) -> (),
}

export type PublicMethods = {
	toString: (self: NonStaticDomain) -> string,
}

export type PrivateMethods = {
	_privateMethod: (self: NonStaticDomain) -> (),
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
export type InternalClassInterface = {
	staticDomain: StaticDomain,
	nonStaticDomain: NonStaticDomain,
}

--[[
Class

Create the class and assert that it follows the rules of the
static interface type, which describes what types the public
methods should be.
]]
local Object = {} :: InternalClassInterface
Object.staticDomain = {} :: StaticDomain
Object.nonStaticDomain = {} :: NonStaticDomain

--[[
Instance type
]]
export type Instance = typeof(setmetatable({} :: InstanceInterface, { __index = Object.nonStaticDomain }))
export type InternalInstance = typeof(setmetatable(
	{} :: InternalInstanceInterface,
	{ __index = Object.nonStaticDomain }
))

--[[
Public static field definitions
]]
Object.staticDomain.test = 10

--[[
Private static field definitions
]]
Object.staticDomain._count = 0

--[[
Public static method
]]
function Object.staticDomain:publicStaticMethod() end

--[[
Private static method definitions
]]
function Object.staticDomain:_incrementCount()
	self._count += 1
end

--[[
Private method definitions
]]
function Object.nonStaticDomain:_privateMethod() end

--[[
Public static method definitions
]]
function Object.staticDomain.new()
	-- Instance
	local self: InternalInstance = setmetatable({} :: InternalInstanceInterface, { __index = Object.nonStaticDomain })

	-- Public
	--

	-- Private
	--

	Object.staticDomain:_incrementCount()
	return self :: InstanceInterface
end

function Object.staticDomain.getCount()
	return Object.staticDomain._count
end

function Object.staticDomain.is(object: any)
	return typeof(object) == "table" and getmetatable(object).__index == Object.nonStaticDomain
end

return Object.staticDomain :: ClassInterface
