--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	SignalConnection class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Object = require(ReplicatedStorage.Shared.Classes.Object)
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
local Table = require(ReplicatedStorage.Shared.Types.Table)

-- Non-static types
export type InstanceFieldsPublic = {
	-- public instance fields here
}

export type InstanceFieldsPrivate = {
	-- private instance fields here
	_super: Super.ClassInternal, -- inheritance
	_settings: ConnectionSettings,
}

export type InstanceMethodsPublic = {
	-- public instance methods here
	getSettings: (self: any) -> ConnectionSettings,
	getPriority: (self: any) -> number,
}

export type InstanceMethodsPrivate = {
	-- private instance methods
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods = InstanceMethodsPrivate & InstanceMethodsPublic
export type InstancePublic = InstanceMethodsPublic & InstanceFieldsPublic & Super.InstancePublic -- inherit
export type InstancePrivate = InstanceMethodsPrivate & InstanceFieldsPrivate & Super.InstancePrivate -- inherit
export type InstanceInternal = InstancePublic & InstancePrivate

-- Static types
export type ClassFieldsPublic = {
	-- public static fields here
}

export type ClassFieldsPrivate = {
	-- private static fields here
	_instancePool: Table.ArrayOf<InstancePublic>,
}

export type ClassMethodsPublic<O> = {
	-- public static methods here
	new: (connectionSettings: ConnectionSettings) -> O,
}

export type ClassMethodsPrivate<O> = {
	-- private static methods here
	_addInstance: (self: any, signalConnection: InstancePublic) -> (),
}

export type ClassPublic<O> = ClassFieldsPublic & ClassMethodsPublic<O> & newClass.ClassTemplatePublic

export type ClassInternal =
	ClassPublic<InstancePublic>
	& ClassMethodsPrivate<InstancePublic>
	& ClassFieldsPrivate
	& InstanceMethods
	& newClass.ClassTemplatePrivate

export type ConnectionSettings = {
	priority: number,
}

local SignalConnection = newClass("SignalConnection", Object) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function SignalConnection.new(connectionSettings)
	SignalConnection:__init__()

	-- Init public & private fields
	local _self: InstanceFields = {
		_super = Super :: Super.ClassInternal,
		_settings = connectionSettings,
	}

	-- If inheriting:
	local self = setmetatable((_self._super.new() :: any) :: InstanceInternal, SignalConnection)
	-- local self = setmetatable(_self :: InstanceInternal, SignalConnection)

	-- Assign private fields
	self._className = SignalConnection:getClassName()
	self._settings = _self._settings
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
function SignalConnection._addInstance(self: ClassInternal, signalConnection: InstancePublic)
	self._instancePool[#self._instancePool + 1] = signalConnection
end
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
--

return SignalConnection :: ClassPublic<InstancePublic>
