--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	EventSignal class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SignalConnection = require(script.Parent.SignalConnection)
local StateValidator = require(script.Parent.StateValidator)
local ValidationReport = require(script.Parent.ValidationReport)
local ValidationResult = require(script.Parent.ValidationResult)
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
local Table = require(ReplicatedStorage.Shared.Types.Table)
local mergeTables = require(ReplicatedStorage.Shared.Util.Table.mergeTables)

--[[
	Class-specific type definitions

	`T = never` allows the interface to switch it's fields to becoming
	optional, via the `value | T` disjunction. `never` indicates that 
	no alternative type is used.
]]
export type EventSettings<T = never> = {
	dispatchLimit: number | T,
	dispatchInterval: number | T,

	throttleLimit: number | T,
	throttleDuration: number | T,
	throttleResetInterval: number | T,

	queueThrottledDispatches: boolean | T,
}

export type EventAnalytics = {
	dispatches: {
		successful: number,
		failed: number,
		total: number,
	},
}

export type DispatchHeaders = {
	withPriority: number,
	async: boolean,
}

--[[
	PUBLIC Fields - Instance
]]
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {}

--[[
	PRIVATE Fields - Instance
]]
export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	_parent: II?,
	_propagating: boolean,
	_connections: typeof(setmetatable({} :: Table.ArrayOf<SignalConnection.InstancePublic>, { __mode = "v" })),
	_eventSettings: EventSettings,
	_eventAnalytics: EventAnalytics,
	_eventSettingsValidator: StateValidator.InstancePublic,
}

--[[
	PUBLIC Methods - Instance
]]
export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	connect: (
		self: any,
		handler: (headers: DispatchHeaders, event: IP, payload: any) -> (),
		connectionSettings: SignalConnection.ConnectionSettings<nil>?
	) -> SignalConnection.InstancePublic,
	dispatch: (self: any, payload: any) -> (),
	dispatchWithHeaders: (self: any, headers: DispatchHeaders, event: IP, payload: any) -> (),
	getParent: (self: any) -> IP?,
}

--[[
	PRIVATE Methods - Instance
]]
export type LocalInstanceMethodsPrivate<CI, II, SCI> = {}

--[[
	Type inheritance intersections between local instance-interface
	definitions and superclass-instance definitions.
]]
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

--[[
	PUBLIC Static Fields - Class
]]
export type ClassFieldsPublic = {}

--[[
	PRIVATE Static Fields - Class
]]
export type ClassFieldsPrivate = {}

--[[
	PUBLIC Static Methods - Class
]]
export type ClassMethodsPublic = {
	new: (parent: InstancePublic? | EventSettings<nil>?, eventSettings: EventSettings<nil>?) -> InstancePublic,
	newWithInitialization: (
		withInitialization: boolean,
		parent: InstancePublic? | EventSettings<nil>?,
		eventSettings: EventSettings<nil>?
	) -> InstancePublic,
	test: () -> (),
}

--[[
	PRIVATE Static Methods - Class
]]
export type ClassMethodsPrivate = {}

--[[
	Type intersections for combining all static definitions into
	a single class interface. One for internal use, and one for
	exported external use.
]]
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

--[[
	Class definition
]]
local EventSignal = newClass({} :: InstancePublic, "EventSignal", Super) :: ClassInternal

--[[
	PUBLIC Static Fields - Class

	Public fields that are assigned directly on the class object, such
	as `NewClass.foo = "bar"` for example.
]]

--[[
	PRIVATE Static Fields - Class

	Private fields that are assigned directly on the class object, such
	as `NewClass._foo = "bar"` for example. All private fields are prefaced
	with an underscore `_` as convention.
]]

--[[
	CONSTRUCTORS

	Class constructors - responsible for creating class instances
]]
function EventSignal.newWithInitialization(withInitialization, parent, eventSettings)
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, EventSignal)
	EventSignal:__init__(self, withInitialization)

	--[[
		PRIVATE Fields - Instance
	]]
	self._connections = setmetatable({}, { __mode = "v" })
	self._propagating = false

	self._eventSettings = {
		dispatchInterval = 0,
		dispatchLimit = 0,

		throttleDuration = 0,
		throttleLimit = 0,
		throttleResetInterval = 0,

		queueThrottledDispatches = false,
	}

	self._eventAnalytics = {
		dispatches = {
			successful = 0,
			failed = 0,
			total = 0,
		},
	}

	--[[
		Assign correct parameter values based on order they
		were received in.
	]]
	do
		local parentIsParent = EventSignal:is(parent)

		if parent ~= nil and not parentIsParent then
			mergeTables(self._eventSettings, parent)
		elseif eventSettings ~= nil then
			mergeTables(self._eventSettings, eventSettings)
		end
	end

	self._parent = parent :: InstanceInternal?
	self._eventSettingsValidator = StateValidator.new(self._eventSettings, self)

	--[[
		PUBLIC Fields - Instance
	]]

	-- Return new instance
	return self
end

function EventSignal.new(...)
	return EventSignal.newWithInitialization(true, ...)
end

-- Public static methods
--

-- Private static methods
--

-- Private instance methods
--

-- Public instance methods
function EventSignal.connect(self: InstanceInternal, handler, connectionSettings)
	local signalConnection = SignalConnection.new(handler, connectionSettings)
	local connectionCount = #self._connections

	-- special case placement for connection signals
	if connectionCount == 0 then
		self._connections[1] = signalConnection
		return signalConnection
	elseif signalConnection:getPriority() < 0 then
		self._connections[connectionCount + 1] = signalConnection
		return signalConnection
	end

	-- insert connection signal in event connections in order of given priority
	for index = 1, connectionCount do
		local connection = self._connections[index]

		if
			connection:isListening() and signalConnection:getPriority() <= connection:getPriority()
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

function EventSignal.dispatchWithHeaders(self: InstanceInternal, headers, payload)
	local connections = self._connections

	local eventValidator = self._eventSettingsValidator
	local eventValidationReport = eventValidator:validate()

	if eventValidationReport:hasFailed() then
		return eventValidationReport
	end

	for index = #connections, 1, -1 do
		local connection = connections[index]
		connection:runHandler(self, payload)
	end

	return eventValidationReport
end

function EventSignal.dispatch(self: InstanceInternal, payload)
	return self:dispatchWithHeaders({
		withPriority = 0,
		async = false,
	}, payload)
end

--[[
	TEST CODE:

	A class-level function which contains optional or temporary 
	test-code, ideally for testing class features.
]]
function EventSignal.test()
	local e = EventSignal.new({
		dispatchLimit = 1,
	})

	e:connect(function(headers, event, payload)
		print("Fired: ", event)
	end)

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

	e:dispatch("something")
end

-- Export the final class with a public interface
return EventSignal :: ClassPublic
