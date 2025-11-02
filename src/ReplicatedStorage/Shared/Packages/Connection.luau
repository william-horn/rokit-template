--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local Signal = require(script.Parent.Signal)
local TableType = require(Shared.Types.Table)
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Connection class
]]

type ConnectionMethods<ConnectionInstance> = {
	connTest: (self: ConnectionInstance) -> string,
}

type ConnectionFields = {
	connKey: string,
}

type ConnectionFieldsPrivate = {
	_connId: number,
}

type ConnectionMethodsPrivate = {}

export type ConnectionInstance = ConnectionMethods<ConnectionInstancePrivate> & ConnectionFields & Signal.SignalInstance -- inheritance
type ConnectionInstancePrivate = ConnectionInstance & ConnectionFieldsPrivate & ConnectionMethodsPrivate

export type ConnectionClass<ConnectionInstance> = {
	new: () -> ConnectionInstance,
	connCount: number,
} & Signal.SignalClass<ConnectionInstance> -- inheritance

type ConnectionClassPrivate =
	ConnectionClass<ConnectionInstance>
	& ConnectionMethods<ConnectionInstancePrivate>
	& ConnectionMethodsPrivate
	& {
		__index: TableType.Map<string, any>,
	}

local Connection = {} :: ConnectionClassPrivate
Connection.__index = setmetatable(Connection, Signal)

Connection.connCount = 0

function Connection.new()
	-- Init public & private fields
	local _o: ConnectionFieldsPrivate & ConnectionFields = {
		_connId = 0,
		connKey = "",
	}

	-- Create instance
	local o = setmetatable(Signal.new() :: ConnectionInstancePrivate, Connection)
	o._connId = _o._connId
	o.connKey = _o.connKey

	-- Return new instance
	return o
end

function Connection:connTest()
	return "Connection test"
end

return Connection :: ConnectionClass<ConnectionInstance>
