--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	EventSignal class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SignalConnection = require(script.Parent.SignalConnection)
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
	_parent: InstancePublic?,
	_eventSettings: EventSettings,
	_propagating: boolean,
	_connections: Table.ArrayOf<SignalConnection.InstancePublic>,
}

export type InstanceMethodsPublic = {
	-- public instance methods here
	connect: (self: any, handler: (...any) -> (), connectionSettings: SignalConnection.ConnectionSettings?) -> (),
	getParent: (self: any) -> InstancePublic?,
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
}

export type ClassMethodsPublic<O> = {
	-- public static methods here
	new: (parent: O? | EventSettings?, eventSettings: EventSettings?) -> O,
}

export type ClassMethodsPrivate<O> = {
	-- private static methods here
}

export type ClassPublic<O> = ClassFieldsPublic & ClassMethodsPublic<O> & newClass.ClassTemplatePublic

export type ClassInternal =
	ClassPublic<InstancePublic>
	& ClassMethodsPrivate<InstancePublic>
	& ClassFieldsPrivate
	& InstanceMethods
	& newClass.ClassTemplatePrivate

-- EventSignal interfaces --
export type EventSettings = {
	dispatchLimit: number?,
	dispatchInterval: number?,

	throttleLimit: number?,
	throttleDuration: number?,
	throttleResetInterval: number?,

	queueThrottledDispatches: boolean?,
}

local EventSignal = newClass("EventSignal", Object) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function EventSignal.new(inputParent, inputEventSettings)
	EventSignal:__init__()
	local readEventSettings: EventSettings = inputEventSettings or {}

	-- Init public & private fields
	local hasParent = EventSignal:is(inputParent)
	local parent: InstancePublic? = inputParent :: InstancePublic?
	local eventSettings: EventSettings = {}

	if inputParent ~= nil and hasParent == false then
		readEventSettings = inputParent :: EventSettings
		parent = nil
	end

	eventSettings.dispatchInterval = readEventSettings.dispatchInterval or 0
	eventSettings.dispatchLimit = readEventSettings.dispatchLimit or 0
	eventSettings.throttleLimit = readEventSettings.throttleLimit or 0
	eventSettings.throttleDuration = readEventSettings.throttleDuration or 0
	eventSettings.throttleResetInterval = readEventSettings.throttleResetInterval or 0

	local _self: InstanceFields = {
		_super = Super :: Super.ClassInternal,
		_parent = parent,
		_eventSettings = eventSettings :: EventSettings,
		_connections = {},
		_propagating = false,
	}

	-- If inheriting:
	local self = setmetatable((_self._super.new() :: any) :: InstanceInternal, EventSignal)
	-- local self = setmetatable(_self :: InstanceInternal, EventSignal)

	-- Assign private fields
	self._className = EventSignal:getClassName()
	self._parent = _self._parent
	self._eventSettings = _self._eventSettings
	self._connections = _self._connections
	self._propagating = _self._propagating
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
function EventSignal.connect(self: InstanceInternal, handler, inputConnectionSettings)
	local readConnectionSettings = (inputConnectionSettings or {}) :: SignalConnection.ConnectionSettings
	local connectionSettings = {} :: SignalConnection.ConnectionSettings

	connectionSettings.priority = readConnectionSettings.priority or 0

	local signalConnection = SignalConnection.new(connectionSettings)

	if #self._connections == 0 then
		self._connections[1] = signalConnection
	else
		for index = 1, #self._connections do
			local connection = self._connections[index]
			if signalConnection:getPriority() <= connection:getPriority() then
				table.insert(self._connections, index, signalConnection)
				break
			end
		end
	end
end

function EventSignal.getParent(self: InstanceInternal)
	return self._parent
end
--

return EventSignal :: ClassPublic<InstancePublic>
