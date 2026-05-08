--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	EventSignal class
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
	_parent: InstancePublic?,
	_eventSettings: EventSettings,
	_propagating: boolean,
	_connections: Table.ArrayOf<{}>,
}

export type InstanceMethodsPublic = {
	-- public instance methods here
	connect: (self: any, handler: ConnectionHandler, connectionSettings: ConnectionSettings?) -> (),
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
	new: (O? | EventSettings?, EventSettings?) -> O,
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

export type ConnectionSettings = {
	priority: number?,
}

export type EventSettings = {
	dispatchLimit: number?,
	dispatchInterval: number?,

	throttleLimit: number?,
	throttleDuration: number?,
	throttleResetInterval: number?,

	queueThrottledDispatches: boolean?,
}

export type ConnectionHandler = (event: InstancePublic, ...any) -> ()

local EventSignal = newClass("EventSignal", Object) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function EventSignal.new(parent: InstancePublic? | EventSettings?, eventSettings: EventSettings?)
	-- Init public & private fields
	local _eventSettings: EventSettings = eventSettings or {
		dispatchLimit = 0,
		dispatchInterval = 0,
	}

	local _self: InstanceFields = {
		_super = Super :: Super.ClassInternal,
		_parent = EventSignal:is(parent) and parent :: InstancePublic or nil,
		_eventSettings = _eventSettings,
		_connections = {},
		_propagating = false,
	}

	-- If inheriting:
	local self = setmetatable((_self._super.new() :: any) :: InstanceInternal, EventSignal)
	-- local self = setmetatable(_self :: InstanceInternal, EventSignal)

	EventSignal:_incrementInstanceCount()

	-- Assign private fields
	self._serialId = Object:getInstanceCount()
	self._className = "EventSignal"
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
function EventSignal.connect(self: InstanceInternal, handler: ConnectionHandler, connectionSettings) end

function EventSignal.getParent(self: InstanceInternal)
	return self._parent
end
--

return EventSignal :: ClassPublic<InstancePublic>
