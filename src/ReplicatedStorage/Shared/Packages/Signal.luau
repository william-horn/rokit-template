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

type SignalMethods = {
	signalTest: (self: SignalInstancePrivate) -> string,
}

type SignalFields = {
	signalKey: string,
}

type SignalFieldsPrivate = {
	_signalId: number,
}

type SignalMethodsPrivate = {}

type SignalInstance = SignalMethods & SignalFields
type SignalInstancePrivate = SignalInstance & SignalFieldsPrivate & SignalMethodsPrivate

export type SignalClass = {
	new: () -> SignalInstance,
}

type SignalClassPrivate = SignalClass & SignalMethods & SignalMethodsPrivate & {
	__index: TableType.Map<string, any>,
}

local Signal = {} :: SignalClassPrivate
Signal.__index = Signal

function Signal.new()
	-- Init public & private fields
	local _o: SignalFieldsPrivate & SignalFields = {
		_signalId = 0,
		signalKey = "",
	}

	-- Create instance
	local o = setmetatable(_o :: SignalInstancePrivate, Signal)

	-- Return new instance
	return o :: SignalInstance
end

function Signal:signalTest()
	return "Signal test"
end

return Signal
