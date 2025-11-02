--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local TableType = require(Shared.Types.Table)
local Object = require(script.Parent.Object)
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Signal class
]]

-- Non-static types
type SignalMethods<SignalInstance> = {}

type SignalFields = {}

type SignalFieldsPrivate = {}

type SignalMethodsPrivate = {}

export type SignalInstance = SignalMethods<SignalInstancePrivate> & SignalFields & Object.ObjectInstance -- inheritance
type SignalInstancePrivate = SignalInstance & SignalFieldsPrivate & SignalMethodsPrivate

-- Static types
export type SignalClass<SignalInstance> = {
	new: () -> SignalInstance,
	sigCount: number,
} & Object.ObjectClass<SignalInstance> -- inheritance

type SignalClassPrivate = SignalClass<SignalInstance> & SignalMethods<SignalInstancePrivate> & SignalMethodsPrivate & {
	__index: TableType.Map<string, any>,
}

local Signal = {} :: SignalClassPrivate

-- Private static fields
Signal.__index = setmetatable(Signal, Object)

-- Public static fields
Signal.sigCount = 10

-- Constructor
function Signal.new()
	-- Init public & private fields
	local _o: SignalFieldsPrivate & SignalFields = {
		_signalId = 0,
		signalKey = "",
	}

	-- Create instance
	local o = setmetatable(Object.new() :: SignalInstancePrivate, Signal)
	o._signalId = _o._signalId
	o.signalKey = _o.signalKey

	-- Return new instance
	return o
end

-- Public static methods

-- Private instance methods

-- Public instance methods
function Signal:signalTest()
	return "Signal test"
end

return Signal :: SignalClass<SignalInstance>
