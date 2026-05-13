--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	SignalConnection class
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

export type ConnectionStatus = "dead" | "listening"

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
	getSettings: (self: any) -> ConnectionSettings,
	getPriority: (self: any) -> number,
	isListening: (self: any) -> boolean,
	isDead: (self: any) -> boolean,
	isAlive: (self: any) -> boolean,
	getStatus: (self: any) -> ConnectionStatus,
	runHandler: (self: any, ...any) -> (),
	disconnect: (self: any) -> (),
	runHandlerWithValidation: (self: any, validationSettings: any) -> (),
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
	-- public static methods here
	new: (handler: (...any) -> (), connectionSettings: ConnectionSettings<nil>?) -> InstancePublic,
	newWithInitialization: (
		withInitialization: boolean,
		handler: (...any) -> (),
		connectionSettings: ConnectionSettings<nil>?
	) -> InstancePublic,
	test: () -> (),
}

--[[
	PRIVATE Static Methods - Class
]]
export type ClassMethodsPrivate = {
	-- private static methods here
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

	self._status = "listening"
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
--

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
