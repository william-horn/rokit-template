--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local TableType = require(Shared.Types.Table)
local Object = require(script.Parent.Object)
local Class = require(ReplicatedStorage.Shared.Interfaces.Class)
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Signal class
]]

-- Non-static types
type SignalMethods<O> = {
	toString: (self: O) -> string
}

type SignalFields = {}

type SignalFieldsPrivate = {
	-- _super: Object.ObjectInstance<Object.ObjectInstancePrivate>
}

type SignalMethodsPrivate<O> = {}

export type SignalInstance<O> = 
	SignalMethods<O> 
	& SignalFields 
	& Object.ObjectInstance<O> -- inheritance

type SignalInstancePrivate =
	SignalInstance<SignalInstancePrivate>
	& SignalFieldsPrivate
	& SignalMethodsPrivate<SignalInstancePrivate>
	& Class.ObjectPrivateInterface<SignalInstancePrivate>

-- Static types
export type SignalClass<O> =
	Class.ClassPublicInterface<O>
	& Object.ObjectClass<O> -- inheriting
	& {
		-- public static types here
	}

type SignalClassPrivate =
	SignalClass<SignalInstance<SignalInstancePrivate>>
	& SignalMethods<SignalInstancePrivate>
	& SignalMethodsPrivate<SignalInstancePrivate>
	& Class.ClassPrivateInterface<SignalInstancePrivate>
	& {
		-- private static types here
	}

local Signal = {} :: SignalClassPrivate

-- Private static fields
Signal.__index = setmetatable(Signal, Object)

-- Public static fields

-- Constructor
function Signal.new()
	-- Init public & private fields
	local o = setmetatable(Object.new() :: SignalFieldsPrivate & Object.ObjectInstancePrivate, Signal)
	o._className = "Signal"

	-- Return new instance
	return o
end

-- Public static methods

-- Private instance methods

-- Public instance methods

return Signal :: SignalClass<SignalInstance<SignalInstancePrivate>>
