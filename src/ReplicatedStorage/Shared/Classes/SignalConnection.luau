--!strict
--[[
	@author William J. Horn (ScriptGuider@ROBLOX.com)
	@written 5/12/2026
	
	If you have any questions, email williamjosephhorn@gmail.com
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
local mergeTables = require(ReplicatedStorage.Shared.Util.Table.mergeTables)

--[[
	Class-specific type definitions
]]
export type ConnectionSettings<T = never> = {
	priority: number | T,
}

export type ConnectionStatus = "dead" | "listening" | "paused"

--[[
	PUBLIC Fields - Instance
]]
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {}

--[[
	PRIVATE Fields - Instance
]]
export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	_settings: ConnectionSettings,
	_status: ConnectionStatus,
	_handler: (...any) -> (),
}

--[[
	PUBLIC Methods - Instance
]]
export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	--[[
		Get the initial settings of the `SignalConnection` that
		was passed during instantiation

		<i>Inherited from:</i> [<b>SignalConnection</b>](#)

		<b>Example:</b>

		```luau
		local connection = SignalConnection.new(
			function(...) end,
			{ priority = 3 }
		)

		print(connection:getSettings()) --> { ..., priority = 3 }
		```

		@return `connectionSettings` <<b>ConnectionSettings</b>> The connection settings table
	]]
	getSettings: (self: any) -> ConnectionSettings,

	--[[
		Gets the dispatch priority of the `SignalConnection`. Priority
		represents which order SignalConnections are fired in.

		<i>Inherited from:</i> [<b>SignalConnection</b>](#)

		<b>Example:</b>

		```luau
		local conn = SignalConnection.new(f, { priority = 1 })
		print(conn:getPriority()) --> 1
		```

		@return `priority` <<b>number</b>> The `SignalConnection`'s priority.
	]]
	getPriority: (self: any) -> number,

	--[[
		Determines whether or not the `SignalConnection` is currently active
		and listening for dispatches.

		<i>Inherited from:</i> [<b>SignalConnection</b>](#)

		<b>Example</b>

		```luau
		local conn = SignalConnection.new(f)
		print(conn:isListening()) --> true
		conn:disconnect()
		print(conn:isListening()) --> false
		```

		@return `isListening` <<b>boolean</b>> `true` if the `SignalConnection` is active, otherwise `false`.
	]]
	isListening: (self: any) -> boolean,

	--[[
		Determines whether the `SignalConnection` is currently dead
		and no longer listening to dispatches.

		<i>Inherited from:</i> [<b>SignalConnection</b>](#)

		<b>Example:</b>

		```luau
		local conn = SignalConnection.new(f)
		print(conn:isDead()) --> false
		conn:disconnect()
		print(conn:isDead()) --> true
		```

		@return `isDead` <<b>boolean</b>> `true` if the `SignalConnection` has been disconnected, otherwise `false`.
	]]
	isDead: (self: any) -> boolean,

	--[[
		Determines whether the `SignalConnection` is currently alive, meaning
		any state but "dead".

		<i>Inherited from:</i> [<b>SignalConnection</b>](#)

		<b>Example:</b>

		```luau
		local conn = SignalConnection.new(f)
		print(conn:isAlive()) --> true
		conn:setStatus("paused")
		print(conn:isAlive()) --> true
		conn:disconnect()
		print(conn:isAlive()) --> false
		```

		@return `isAlive` <<b>boolean</b>> `true` if the `SignalConnection` is not dead, otherwise `false`.
	]]
	isAlive: (self: any) -> boolean,

	--[[
		Determines whether the `SignalConnection` is currently paused. Paused
		connections will not execute, but they are not dead, and can be resumed
		later.

		<i>Inherited from:</i> [<b>SignalConnection</b>](#)

		<b>Example:</b>

		```luau
		local conn = SignalConnection.new(f)
		conn:setStatus("paused")
		print(conn:isPaused()) --> true
		```

		@return `isPaused` <<b>boolean</b>> `true` if the `SignalConnection` is paused, otherwise `false`.
	]]
	isPaused: (self: any) -> boolean,

	--[[
		Sets the status of the `SignalConnection` instance. So far, the
		only status options are `dead`, `listening`, and `paused`.

		<i>Inherited from:</i> [<b>SignalConnection</b>](#)

		<b>Example:</b>

		```luau
		local conn = SignalConnection.new(f)
		conn:setStatus("paused")
		print(conn:getStatus()) --> "paused"
		```
	]]
	setStatus: (self: any, status: ConnectionStatus) -> (),

	--[[
		Gets the status of the `SignalConnection` instance. So far, the
		only status options are `dead`, `listening`, and `paused`.

		<i>Inherited from:</i> [<b>SignalConnection</b>](#)

		<b>Example:</b>

		```luau
		local conn = SignalConnection.new(f)
		print(conn:getStatus()) --> "listening"
		```

		@return `status` <<b>string</b>> The status of the `SignalConnection` instance.
	]]
	getStatus: (self: any) -> ConnectionStatus,

	--[[
		Runs the `SignalConnection`'s handler function directly.

		<i>Inherited from:</i> [<b>SignalConnection</b>](#)

		<b>Example:</b>

		```luau
		local conn = SignalConnection.new(function(...)
			print("Handler executed", ...)
		end)

		conn:runHandler(100) --> "Handler executed" 100
		```
	]]
	runHandler: (self: any, ...any) -> (),

	--[[
		Disconnects the `SignalConnection` and calls `destroy()` on itself.
		This will set the connection's status to `"dead"`

		<i>Inherited from:</i> [<b>SignalConnection</b>](#)

		<b>Example:</b>

		```luau
		local conn = SignalConnection.new(f)
		print(conn:getStatus()) --> "listening"
		conn:disconnect()
		print(conn:getStatus()) --> "dead"
		```
	]]
	disconnect: (self: any) -> (),
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
	--[[
		Create a new initialized instance of this class

		@param handler <<b>function</b>> A callback function to be executed when the SignalConnection is fired.
		@param connectionSettings <<b>ConnectionSettings</b>> A table of settings to modify connection signal behavior.

		```luau
		local connection = SignalConnection.new(
			function(...)
				print(...) 
			end, 
			{ priority = 1 }
		)
		```

		@return `SignalConnection` <<b>SignalConnection Instance</b>>
	]]
	new: (handler: (...any) -> (), connectionSettings: ConnectionSettings<nil>?) -> InstancePublic,

	--[[
		Create a new instance of this class with the option of 
		being initialized. If the instance is not initialized, it
		must be initialized manually to define the missing class
		fields: `_class`, `_className`, `_super`.

		@return `SignalConnection` <<b>SignalConnection Instance</b>>
	]]
	newWithInitialization: (
		withInitialization: boolean,
		handler: (...any) -> (),
		connectionSettings: ConnectionSettings<nil>?
	) -> InstancePublic,

	--[[
		A test method to write temporary test code for the class.
	]]
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
local SignalConnection = newClass({} :: InstancePublic, "SignalConnection", Super) :: ClassInternal

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
function SignalConnection.newWithInitialization(withInitialization, handler, connectionSettings)
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, SignalConnection)
	SignalConnection:__init__(self, withInitialization)

	--[[
		PRIVATE Fields - Instance
	]]
	self._settings = {
		priority = 0,
	}

	self:setStatus("listening")
	self._handler = handler

	if connectionSettings ~= nil then
		mergeTables(self._settings, connectionSettings)
	end

	--[[
		PUBLIC Fields - Instance
	]]

	-- Return new instance
	return self
end

function SignalConnection.new(...)
	return SignalConnection.newWithInitialization(true, ...)
end

--[[
	PUBLIC Static Methods - Class
]]

--[[
	PRIVATE Static Methods - Class
]]

--[[
	PRIVATE Methods - Instance
]]

--[[
	PUBLIC Methods - Instance
]]
function SignalConnection.getSettings(self: InstanceInternal)
	return self._settings
end

function SignalConnection.getPriority(self: InstanceInternal)
	return self._settings.priority
end

function SignalConnection.disconnect(self: InstanceInternal)
	self:setStatus("dead")
	self:destroy()
end

function SignalConnection.setStatus(self: InstanceInternal, status)
	self._status = status
end

function SignalConnection.getStatus(self: InstanceInternal)
	return self._status
end

function SignalConnection.isListening(self: InstanceInternal)
	return self:getStatus() == "listening"
end

function SignalConnection.isPaused(self: InstanceInternal)
	return self:getStatus() == "paused"
end

function SignalConnection.isDead(self: InstanceInternal)
	return self:getStatus() == "dead"
end

function SignalConnection.isAlive(self: InstanceInternal)
	return not self:isDead()
end

function SignalConnection.runHandler(self: InstanceInternal, ...: any)
	self._handler(...)
end

--[[
	TEST CODE:

	A class-level function which contains optional or temporary 
	test-code, ideally for testing class features.
]]
function SignalConnection.test() end

-- Export the final class with a public interface
return SignalConnection :: ClassPublic
