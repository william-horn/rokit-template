--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Signal class
]]
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Shared = ReplicatedStorage.Shared
-- local TableType = require(Shared.Types.Table)
local Object = require(script.Parent.Object)

export type PublicStaticFields = {}

export type PrivateStaticFields = {
	__index: InternalClassInterface,
}

export type PublicFields = {
	type: string,
}

export type PrivateFields = {}

export type PublicStaticMethods<I> = {
	new: () -> I,
}

export type PrivateStaticMethods = {}

export type PublicMethods<I> = {
	toString: (self: I) -> string,
	signalMethod: (self: I) -> number,
}

export type PrivateMethods<I> = {}

--[[
Public interface
]]
export type InstanceInterface = PublicFields & PublicMethods<Instance>
export type InternalInstanceInterface = InstanceInterface & PrivateFields & PrivateMethods<InternalInstance>

--[[
Class interface (internal only)
]]
export type ClassInterface =
	typeof(setmetatable(
		{} :: PublicStaticFields & PublicStaticMethods<Instance> & Object.PublicStaticFields & Object.PublicStaticMethods<Instance>,
		Object
	))
export type InternalClassInterface =
	PublicStaticFields
	& PublicStaticMethods<Instance>
	& PrivateStaticFields
	& PrivateStaticMethods
	& PublicMethods<Instance>
	& PrivateMethods<InternalInstance>
	& Object.PublicStaticFields
	& Object.PublicStaticMethods<Instance>

--[[
Class

Create the class and assert that it follows the rules of the
static interface type, which describes what types the public
methods should be.
]]
local Signal = setmetatable({} :: InternalClassInterface, Object)
--[[
Public static fields
]]

--[[
Private static fields
]]
Signal.__index = Signal

--[[
Instance type
]]
export type Instance = typeof(setmetatable({} :: InstanceInterface, Signal))
export type InternalInstance = typeof(setmetatable({} :: InternalInstanceInterface, Signal))

--[[
Public static method
]]

--[[
Private static method definitions
]]

--[[
Private method definitions
]]

--[[
Public static method definitions
]]
function Signal.new()
	-- Instance
	local self: InternalInstance = setmetatable({} :: InternalInstanceInterface, Signal)
	self.type = "signal"

	-- Public
	--

	-- Private
	--

	return self :: Instance
end

return Signal :: ClassInterface
