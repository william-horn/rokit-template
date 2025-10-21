--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Signal class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared

local Object = require(script.Parent.Object)
local TableType = require(Shared.Types.Table)

--[[
Public fields (internal & external)

This interface describes what the fields should look like for
an instance of this class
]]
type SignalPublicFields = {}

--[[
Public methods (internal & external)

This interface describes what the API should look like
for an instance of this class. It also describes what 
methods should be defined at the class level, and what
their types should be.
]]
type SignalPublicMethods = {
	toString: (self: Signal) -> string,
}

--[[
Public interface

This interface describes what the entire interface should
look like for an instance of this class including the public
fields and the public methods.
]]
type SignalPublicInterface = SignalPublicFields & SignalPublicMethods & TableType.Map<string, any>

--[[
Static interface (internal only)

We create an internal interface for the class in order to
ensure that the public method type definitions match up with
the methods that are defined internally. This is why we are
joining `___PublicMethods` with the general map type
]]
type SignalStaticInterface = SignalPublicMethods & TableType.Map<string, any>

--[[
Class

Create the class and assert that it follows the rules of the
static interface type, which describes what types the public
methods should be.
]]
local Signal = setmetatable({} :: SignalStaticInterface, Object)

--[[
Instance type

This type refers to the actual instance object that is created
upon instantiation.
]]
export type Signal = typeof(setmetatable({} :: SignalPublicInterface, Signal))

--[[
Private static fields/methods

These fields are defined at the class level and are hidden from
both the public and static interfaces. They are not accessible
in general from the class level unless specified in the class 
export object at the bottom of the module.

These fields are accessible at the instance level, but they
are hidden from the interface and their types are inferred
as `any`. Therefore, whenever accessing these fields, a type
assertion should always be used so that the type system knows
what they are.
]]
Signal.__index = Signal
-- Signal._count = 0

-- function Signal:_incrementCount()
-- 	self._count += 1
-- end

--[[
Public methods

These methods are available only to instances of this class.
Internally, they will be visible on the static class interface
of `_____StaticInterface`, but they will not be visible on 
such interface after the class is exported.
]]
function Signal:toString()
	return "Signal"
end

--[[
Public Static methods

These methods are constructor or utility functions available only
at the class level.
]]
local function new()
	-- Instance
	local self: Signal = setmetatable({} :: SignalPublicInterface, Signal)

	-- Public
	--

	-- Private
	--

	-- Signal:_incrementCount()
	return self
end

-- local function getCount()
-- 	local count: number = Signal._count
-- 	return count
-- end

local function is(object: any)
	return typeof(object) == "table" and getmetatable(object) == Signal
end

return {
	is = is,
	new = new,
	-- getCount = getCount,
}
