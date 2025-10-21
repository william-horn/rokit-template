--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Signal class
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
local Signal = {} :: InternalClassInterface

--[[
Public static fields
]]
Signal.publicStaticField = "test"

--[[
Private static fields
]]
Signal.__index = Signal
Signal._count = 0

--[[
Instance type
]]
export type Instance = typeof(setmetatable({} :: InstanceInterface, Signal))
export type InternalInstance = typeof(setmetatable({} :: InternalInstanceInterface, Signal))

--[[
Public static method
]]
function Signal.publicStaticMethod() end

--[[
Private static method definitions
]]
function Signal._incrementCount()
	Signal._count += 1
end

--[[
Private method definitions
]]
function Signal:_privateMethod() end

--[[
Public static method definitions
]]
function Signal.new()
	-- Instance
	local self: InternalInstance = setmetatable({} :: InternalInstanceInterface, Signal)

	-- Public
	--

	-- Private
	--

	Signal._incrementCount()
	return self :: InstanceInterface
end

function Signal.getCount()
	return Signal._count
end

function Signal.is(object: any)
	return typeof(object) == "table" and getmetatable(object) == Signal
end

return Signal :: ClassInterface
