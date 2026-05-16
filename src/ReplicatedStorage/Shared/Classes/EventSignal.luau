--!strict
--[[
	@author William J. Horn (ScriptGuider@ROBLOX.com)
	@written 5/12/2026

	EventSignal
	
	If you have any questions, email williamjosephhorn@gmail.com
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SignalConnection = require(script.Parent.SignalConnection)
local ValidationReport = require(script.Parent.ValidationReport)
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
local Table = require(ReplicatedStorage.Shared.Types.Table)
local mergeTables = require(ReplicatedStorage.Shared.Util.Table.mergeTables)

export type EventState = "listening" | "dispatch_limit_reached" | "cooldown" | "throttling" | "dead" | "paused"

export type EventSettings<T = never> = {
	--[[
		How many times the event can be dispatched before the event
		signal will disable itself. If the limit is reached, the event's 
		status will be set to `"dispatch_limit_reached"` until manually
		changed.
	]]
	dispatchLimit: number | T,

	--[[
		How long in seconds the event will reject dispatches for until
		the given time has elapsed. During this time, the event's status
		will be `"cooldown"`.
	]]
	dispatchCooldown: number | T,

	--[[
		The number of successful dispatches until the event will throttle
		new incoming dispatches. The duration of the throttle is determined
		by `throttleDuration`. When throttled, the event's status will be
		set to `"throttling"`
	]]
	throttleLimit: number | T,

	--[[
		How long in seconds until the event will stop throttling incoming
		dispatches, if the throttle limit has been reached.
	]]
	throttleDuration: number | T,

	--[[
		How long in seconds until the dispatch counter will reset before
		reaching the throttle limit.
	]]
	throttleResetInterval: number | T,

	--[[
		If true, incoming dispatches will be queued and executed as soon
		as the event's state is set back to `"listening"`
	]]
	queueThrottledDispatches: boolean | T,

	--[[
		If true, incoming dispatches
	]]
	queueCooldownDispatches: boolean | T,
}

export type EventAnalytics = {
	dispatches: {
		whileDispatchLimitReached: number,

		--[[
			Number of successful dispatches. Successful dispatches
			are any dispatches while the event is in the state of
			`"listening"`
		]]
		successful: number,

		--[[
			Number of dispatches while event was NOT in the state
			of `"listening"`
		]]
		failed: number,

		--[[
			Total number of times the event has been dispatched or
			attempted to dispatch.
		]]
		total: number,
	},
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
	_dispatchValidationReport: ValidationReport.InstancePublic,
	_state: EventState,
}

--[[
	PUBLIC Methods - Instance
]]
export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	--[[
		Connect a handler function to the event signal. The handler
		function is a callback that is executed when the event is
		dispatched.

		<i>Inherited from:</i> [<b>EventSignal</b>](#)

		<b>Example:</b>

		```luau
		local e = EventSignal.new()

		e:connect(function(payload)
			print(e:toString() .. "fired with payload: ", payload)
		end)
		```

		@param handler <<b>function</b>> The callback that is executed when the event is dispatched.
		@param connectionSettings <<b>ConnectionSettings</b>> Connection settings for the current connection.
		
		@return `signalConnection` <<b>SignalConnection</b>> The new signal connection bound to the event.
	]]
	connect: (
		self: any,
		handler: (payload: any) -> (),
		connectionSettings: SignalConnection.ConnectionSettings<nil>?
	) -> SignalConnection.InstancePublic,

	--[[
		Dispatch the event with a given payload. The event dispatch
		will only be triggered if it is in the state of `"Listening"`.
		All event handlers that match running criteria will fire.

		<i>Inherited from:</i> [<b>EventSignal</b>](#)

		<b>Example:</b>

		```luau
		local e = EventSignal.new()

		e:connect(function(event, payload)
			print("dispatched with payload: ", payload)
		end)
		
		e:dispatch("test") --> "dispatched with payload: test"
		```

		@param payload <<b>any</b>> The data passed to the event's connection handler function.
		@param dispatchSettings? <<b>DispatchSettings?</b>> A map of directives for configuring the dispatch.

		@return `dispatchValidationReport` <<b>ValidationReport</b>> A validation report of the dispatch attempt.
	]]
	dispatch: (
		self: any,
		payload: any,
		dispatchSettings: SignalConnection.DispatchSettings<nil>?
	) -> ValidationReport.InstancePublic,

	--[[
		Gets the parent event, if one is defined.

		<i>Inherited from:</i> [<b>EventSignal</b>](#)

		<b>Example:</b>

		```luau
		local parent = EventSignal.new()
		local child = EventSignal.new(parent)

		print(child:getParent())
		```

		@return `eventParent?` <<b>EventSignal?</b>> The parent of the event signal, or `nil` if none is defined.
	]]
	getParent: (self: any) -> IP?,

	--[[
		Get the event analytics -- a lifetime record table monitoring the behavior
		of the event.

		<i>Inherited from:</i> [<b>EventSignal</b>](#)

		<b>Example:</b>

		```luau
		local e = EventSignal.new()
		e:dispatch()
		print(e:getAnalytics().dispatches.total) --> 1
		```

		@return `eventAnalytics` <<b>EventAnalytics</b>> A table of lifetime event analytics
	]]
	getAnalytics: (self: any) -> EventAnalytics,

	getSettings: (self: any) -> EventSettings,
	getState: (self: any) -> EventState,
	setState: (self: any, state: EventState) -> (),
	isPropagating: (self: any) -> boolean,
}

--[[
	PRIVATE Methods - Instance
]]
export type LocalInstanceMethodsPrivate<CI, II, SCI> = {
	_dispatchWithSettings: (
		self: any,
		payload: any,
		dispatchSettings: SignalConnection.DispatchSettings
	) -> ValidationReport.InstancePublic,
}

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
export type ClassMethodsPrivate = {
	_dispatchValidationHandler: ValidationReport.ValidationHandler,
}

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
	self:setState("listening")

	self._eventSettings = {
		dispatchLimit = -1,
		dispatchCooldown = 0,

		throttleLimit = -1,
		throttleDuration = 0,
		throttleResetInterval = 0,

		queueThrottledDispatches = false,
		queueCooldownDispatches = false,
	}

	self._eventAnalytics = {
		dispatches = {
			whileDispatchLimitReached = 0,
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
	self._dispatchValidationReport = ValidationReport.new()

	--[[
		PUBLIC Fields - Instance
	]]

	-- Return new instance
	return self
end

function EventSignal.new(...)
	return EventSignal.newWithInitialization(true, ...)
end

--[[
	PUBLIC Static Methods - Class
]]

--[[
	PRIVATE Static Methods - Class
]]
function EventSignal._dispatchValidationHandler(validationReport, event: InstancePublic)
	local analytics = event:getAnalytics()
	local settings = event:getSettings()

	if settings.dispatchLimit > -1 and analytics.dispatches.successful >= settings.dispatchLimit then
		validationReport:addResult({
			result = "failed",
			message = "Dispatch limit of " .. settings.dispatchLimit .. " was reached",
			handler = function()
				analytics.dispatches.whileDispatchLimitReached += 1
				event:setState("dispatch_limit_reached")
			end,
		})
	end

	return validationReport
end

--[[
	PRIVATE Methods - Instance
]]
function EventSignal._dispatchWithSettings(self: InstanceInternal, payload, dispatchSettings)
	self._eventAnalytics.dispatches.total += 1

	local connections = self._connections
	local dispatchValidationReport = self._dispatchValidationReport

	--[[
		Clear the previous validation report before every dispatch
	]]
	dispatchValidationReport:clear()

	if dispatchSettings.withValidation then
		EventSignal._dispatchValidationHandler(dispatchValidationReport, self)
		dispatchValidationReport:runResultHandlers()

		if dispatchValidationReport:hasFailed() then
			self._eventAnalytics.dispatches.failed += 1
			return dispatchValidationReport
		end
	end

	--[[
		The dispatch has either passed validation or has opted out
		of validation by this point. The event is authorized to 
		fire connections.
	]]
	for index = #connections, 1, -1 do
		local connection = connections[index]
		connection:runHandlerWithSettings(payload, dispatchSettings)
	end

	self._eventAnalytics.dispatches.successful += 1
	return dispatchValidationReport
end

function EventSignal.dispatch(self: InstanceInternal, payload, dispatchSettings)
	local finalDispatchSettings: SignalConnection.DispatchSettings = {
		withValidation = true,
		withAsync = false,
		withPriority = 0,
	}

	if dispatchSettings ~= nil then
		mergeTables(finalDispatchSettings, dispatchSettings)
	end

	return self:_dispatchWithSettings(payload, finalDispatchSettings)
end

--[[
	PUBLIC Methods - Instance
]]
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

function EventSignal.getAnalytics(self: InstanceInternal)
	return self._eventAnalytics
end

function EventSignal.getSettings(self: InstanceInternal)
	return self._eventSettings
end

function EventSignal.getState(self: InstanceInternal)
	return self._state
end

function EventSignal.setState(self: InstanceInternal, state: EventState)
	self._state = state
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

	e:connect(function(payload)
		print("Event dispatched with: ", payload)
	end)

	e:dispatch("idk")
	e:dispatch("idk")
	e:dispatch("idk")

	print(e)
end

-- Export the final class with a public interface
return EventSignal :: ClassPublic
