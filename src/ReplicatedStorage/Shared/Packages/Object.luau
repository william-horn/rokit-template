--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared

local TableType = require(Shared.Types.Table)

--[[
Public fields (internal & external)

This interface describes what the fields should look like for
an instance of this class
]]
type ObjectPublicFields = {}

--[[
Public methods (internal & external)

This interface describes what the API should look like
for an instance of this class. It also describes what 
methods should be defined at the class level, and what
their types should be.
]]
type ObjectPublicMethods = {
	toString: (self: Object) -> string,
}

--[[
Public interface

This interface describes what the entire interface should
look like for an instance of this class including the public
fields and the public methods.
]]
type ObjectPublicInterface = ObjectPublicFields & ObjectPublicMethods & TableType.Map<string, any>

--[[
Static interface (internal only)

We create an internal interface for the class in order to
ensure that the public method type definitions match up with
the methods that are defined internally. This is why we are
joining `___PublicMethods` with the general map type
]]
type ObjectStaticInterface = ObjectPublicMethods & TableType.Map<string, any>

--[[
Class

Create the class and assert that it follows the rules of the
static interface type, which describes what types the public
methods should be.
]]
local Object = {} :: ObjectStaticInterface

--[[
Instance type

This type refers to the actual instance object that is created
upon instantiation.
]]
export type Object = typeof(setmetatable({} :: ObjectPublicInterface, Object))

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
Object.__index = Object
Object._count = 0

function Object:_incrementCount()
	self._count += 1
end

--[[
Public methods

These methods are available only to instances of this class.
Internally, they will be visible on the static class interface
of `_____StaticInterface`, but they will not be visible on 
such interface after the class is exported.
]]
function Object:toString()
	return "Object"
end

--[[
Public Static methods

These methods are constructor or utility functions available only
at the class level.
]]
local function new()
	-- Instance
	local self: Object = setmetatable({} :: ObjectPublicInterface, Object)

	-- Public
	--

	-- Private
	--

	Object:_incrementCount()
	return self
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
