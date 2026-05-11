--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	SignalConnection class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)

-- Non-static types
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {
	-- public instance fields here
}

export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	-- private instance fields here
	_settings: ConnectionSettings,
	_status: ConnectionStatus,
}

export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	-- public instance methods here
	getSettings: (self: any) -> ConnectionSettings,
	getPriority: (self: any) -> number,
	isListening: (self: any) -> boolean,
	isDead: (self: any) -> boolean,
	isAlive: (self: any) -> boolean,
	getStatus: (self: any) -> ConnectionStatus,
	disconnect: (self: any) -> (),
}

export type LocalInstanceMethodsPrivate<CI, II, SCI> = {
	-- private instance methods
}

export type InstanceFieldsPublic<CP, IP, SCP> =
	LocalInstanceFieldsPublic<CP, IP, SCP>
	& Super.InstanceFieldsPublic<CP, IP, SCP>
export type InstanceMethodsPublic<CP, IP, SCP> =
	LocalInstanceMethodsPublic<CP, IP, SCP>
	& Super.InstanceMethodsPublic<CP, IP, SCP>
export type InstanceFieldsPrivate<CI, II, SCI> =
	LocalInstanceFieldsPrivate<CI, II, SCI>
	& Super.InstanceFieldsPrivate<CI, II, SCI>
export type InstanceMethodsPrivate<CI, II, SCI> =
	LocalInstanceMethodsPrivate<CI, II, SCI>
	& Super.InstanceMethodsPrivate<CI, II, SCI>
export type InstancePublic =
	InstanceFieldsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
	& InstanceMethodsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
export type InstanceInternal =
	InstancePublic
	& InstanceFieldsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>
	& InstanceMethodsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>

-- Static types
export type ClassFieldsPublic = {
	-- public static fields here
}

export type ClassFieldsPrivate = {
	-- private static fields here
}

export type ClassMethodsPublic = {
	-- public static methods here
	new: (connectionSettings: ConnectionSettings) -> InstancePublic,
}

export type ClassMethodsPrivate = {
	-- private static methods here
}

export type ClassPublic =
	ClassFieldsPublic
	& ClassMethodsPublic
	& newClass.ClassTemplatePublic<InstancePublic, Super.ClassPublic>

export type ClassInternal =
	ClassPublic
	& ClassMethodsPrivate
	& ClassFieldsPrivate
	& InstanceMethodsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>
	& InstanceMethodsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
	& newClass.ClassTemplatePrivate<InstancePublic, Super.ClassPublic>

export type ConnectionSettings = {
	priority: number,
}

export type ConnectionStatus = "dead" | "listening"

local SignalConnection = newClass({} :: InstancePublic, "SignalConnection", Super) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function SignalConnection.new(connectionSettings)
	-- If inheriting:
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, SignalConnection)
	-- local self = setmetatable(_self :: InstanceInternal, SignalConnection)
	SignalConnection:__init__(self)

	-- Assign private fields
	self._settings = connectionSettings
	self._status = "listening"
	--

	-- Assign public fields
	--

	-- Return new instance
	return self
end
--

-- Public static methods
--

-- Private static methods
--

-- Private instance methods
--

-- Public instance methods
function SignalConnection.getSettings(self: InstanceInternal)
	return self._settings
end

function SignalConnection.getPriority(self: InstanceInternal)
	return self._settings.priority
end

function SignalConnection.disconnect(self: InstanceInternal)
	self._status = "dead"
	self:destroy()
end

function SignalConnection.getStatus(self: InstanceInternal)
	return self._status
end

function SignalConnection.isListening(self: InstanceInternal)
	return self:getStatus() == "listening"
end

function SignalConnection.isDead(self: InstanceInternal)
	return self:getStatus() == "dead"
end

function SignalConnection.isAlive(self: InstanceInternal)
	return not self:isDead()
end
--

return SignalConnection :: ClassPublic
