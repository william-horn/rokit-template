--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	EventSignal class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SignalConnection = require(script.Parent.SignalConnection)
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
local Table = require(ReplicatedStorage.Shared.Types.Table)

-- Non-static types
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {
	-- public instance fields here
}

export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	-- private instance fields here
	_parent: II?,
	_propagating: boolean,
	_connections: typeof(setmetatable({} :: Table.ArrayOf<SignalConnection.InstancePublic>, { __mode = "v" })),
	_eventSettings: EventSettings,
}

export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	-- public instance methods here
	connect: (
		self: any,
		handler: (headers: DispatchHeaders, payload: any) -> (),
		connectionSettings: SignalConnection.ConnectionSettings?
	) -> SignalConnection.InstancePublic,
	dispatch: (self: any, payload: any) -> (),
	dispatchWithHeaders: (self: any, headers: DispatchHeaders, payload: any) -> (),
	getParent: (self: any) -> IP?,
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
	new: (parent: InstancePublic? | EventSettings?, eventSettings: EventSettings?) -> InstancePublic,
	newWithInitialization: (
		withInitialization: boolean,
		parent: InstancePublic? | EventSettings?,
		eventSettings: EventSettings?
	) -> InstancePublic,
	test: () -> (),
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

-- EventSignal interfaces --
export type EventSettings = {
	dispatchLimit: number?,
	dispatchInterval: number?,

	throttleLimit: number?,
	throttleDuration: number?,
	throttleResetInterval: number?,

	queueThrottledDispatches: boolean?,
}

export type DispatchHeaders = {
	withPriority: number,
	async: boolean,
}

local EventSignal = newClass({} :: InstancePublic, "EventSignal", Super) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function EventSignal.newWithInitialization(withInitialization, inputParent, inputEventSettings)
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

	-- If inheriting:
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, EventSignal)
	EventSignal:__init__(self, withInitialization)
	-- local self = setmetatable(_self :: InstanceInternal, EventSignal)

	-- Assign private fields
	self._parent = parent :: InstanceInternal
	self._eventSettings = eventSettings
	self._connections = setmetatable({}, { __mode = "v" })
	self._propagating = false
	--

	-- Assign public fields
	--

	-- Return new instance
	return self
end

function EventSignal.new(...)
	return EventSignal.newWithInitialization(true, ...)
end

function EventSignal.test()
	local e = EventSignal.new()

	e:connect(function()
		print("priority [0] - 1")
	end)
	e:connect(function()
		print("priority [0] - 2")
	end)
	e:connect(function()
		print("priority [1] - 1")
	end, { priority = 1 })
	e:connect(function()
		print("priority [2] - 1")
	end, { priority = 2 })
	e:connect(function()
		print("priority [1] - 2")
	end, { priority = 1 })
	e:connect(function()
		print("priority [-1] - 1")
	end, { priority = -1 }):destroy()
	e:connect(function()
		print("priority [3] - 1")
	end, { priority = 3 })
	e:connect(function()
		print("priority [2] - 2")
	end, { priority = 2 })
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
	local connectionCount = #self._connections

	if connectionCount == 0 then
		self._connections[1] = signalConnection
		return signalConnection
	elseif connectionSettings.priority < 0 then
		self._connections[connectionCount + 1] = signalConnection
		return signalConnection
	end

	for index = 1, connectionCount do
		local connection = self._connections[index]

		if
			connection:isAlive() and connectionSettings.priority < connection:getPriority()
			or connection:getPriority() < 0
		then
			-- type solver bug: can't insert into a metatable; have to force cast
			table.insert(self._connections :: any, index, signalConnection)
			return signalConnection
		end
	end

	self._connections[connectionCount + 1] = signalConnection
	return signalConnection
end

function EventSignal.getParent(self: InstanceInternal)
	return self._parent
end

function EventSignal.dispatchWithHeaders(self: InstanceInternal, headers: DispatchHeaders, payload: any)
	local connections = self._connections
end
--

return EventSignal :: ClassPublic
