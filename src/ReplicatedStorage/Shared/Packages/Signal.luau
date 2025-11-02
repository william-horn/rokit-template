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

type SignalMethods<SignalInstance> = {
	signalTest: (self: SignalInstance) -> string,
}

type SignalFields = {
	signalKey: string,
}

type SignalFieldsPrivate = {
	_signalId: number,
}

type SignalMethodsPrivate = {}

type SignalInstance = SignalMethods<SignalInstancePrivate> & SignalFields & Object.ObjectInstance -- inheritance
type SignalInstancePrivate = SignalInstance & SignalFieldsPrivate & SignalMethodsPrivate

export type SignalClass<SignalInstance> = {
	new: () -> SignalInstance,
} & Object.ObjectClass<SignalInstance> -- inheritance

type SignalClassPrivate = SignalClass<SignalInstance> & SignalMethods<SignalInstancePrivate> & SignalMethodsPrivate & {
	__index: TableType.Map<string, any>,
}

local Signal = {} :: SignalClassPrivate
Signal.__index = setmetatable(Signal, Object)

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

function Signal:signalTest()
	return "Signal test"
end

return Signal :: SignalClass<SignalInstance>
