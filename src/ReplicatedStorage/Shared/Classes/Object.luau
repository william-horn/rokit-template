--!strict
--[[
	@author William J. Horn (ScriptGuider@ROBLOX.com)
	@written 5/12/2026

	The root-class of all classes. Rudimentary instance methods
	and fields that are shared with every class instance is
	defined in this file.

	If you have any questions, email williamjosephhorn@gmail.com
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
local Super = nil

--[[
	PUBLIC Fields - Instance
]]
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {}

--[[
	PRIVATE Fields - Instance
]]
export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	-- private instance fields here
	_serialId: number,
	_className: string,
	_isDestroyed: boolean,
	_class: CI,
	_super: SCI,
}

--[[
	PUBLIC Methods - Instance
]]
export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	--[[
		Represents the instance as a string.

		@return `name` <<b>string</b>> The stringified representation of the object (not serialized)
	]]
	toString: (self: any) -> string,

	--[[
		Get the unique instance id of the object's self. This id number
		directly corresponds to the total lifetime instance count of every
		Object subclass at the time of it's instantiation.

		@return `serialId` <<b>number</b>>
	]]
	getId: (self: any) -> number,

	--[[
		Get the class name of the object.

		@return `className` <<b>string</b>> The class name of the object.
	]]
	getClassName: (self: any) -> string,

	--[[
		Cleans up internal references to the object, freeing it in memory
		to be garbage collected. The object can still be used after it is 
		destroyed, but once all references to the object are gone, it will
		be eligible for garbage collection.

		```luau
		local o = Object.new()

		print(o:getActiveInstanceCount()) --> 1
		o:destroy()
		print(o:getActiveInstanceCount()) --> 0
		```

		@return `self` <<b>Object</b>> The object being destroyed.
	]]
	destroy: (self: any) -> IP,

	--[[
		Determines whether the object has already been destroyed or not.

		```luau
		local o = Object.new()

		print(o:isDestroyed()) --> false
		o:destroy()
		print(o:isDestroyed()) --> true
		```

		@return `isDestroyed` <<b>boolean</b>> `true` if the object has been destroyed, otherwise `false`.
	]]
	isDestroyed: (self: any) -> boolean,

	--[[
		Get the actual `Class` reference of an object.

		```luau
		Object.new():getClass().new()
		print(Object:getActiveInstanceCount()) --> 2
		```
		
		@return `Class` <<b>Class</b>> The `Class` reference that the object was instantiated from.
	]]
	getClass: (self: any) -> CP,

	--[[
		Get the super class reference to the object.

		@return `super` <<b>Class</b>> The super class of the object.
	]]
	getSuperClass: (self: any) -> SCP,
}

--[[
	PRIVATE Methods - Instance
]]
export type LocalInstanceMethodsPrivate<CI, II, SCI> = {
	-- private instance methods
	_getClass: (self: any) -> CI,
}

--[[
	Type inheritance intersections between local instance-interface
	definitions and superclass-instance definitions would take place
	here, but there is no super class of `Object`, so just local
	definitions are used.
]]
export type InstanceFieldsPublic<CP, IP, SCP> = LocalInstanceFieldsPublic<CP, IP, SCP> -- & Super.InstanceFieldsPublic<CP, IP, SCP>
export type InstanceMethodsPublic<CP, IP, SCP> = LocalInstanceMethodsPublic<CP, IP, SCP> -- & Super.InstanceMethodsPublic<CP, IP, SCP>
export type InstanceFieldsPrivate<CI, II, SCI> = LocalInstanceFieldsPrivate<CI, II, SCI> -- & Super.InstanceFieldsPrivate<CI, II, SCI>
export type InstanceMethodsPrivate<CI, II, SCI> = LocalInstanceMethodsPrivate<CI, II, SCI> -- & Super.InstanceMethodsPrivate<CI, II, SCI>
export type InstancePublic =
	InstanceFieldsPublic<ClassPublic, InstancePublic, nil>
	& InstanceMethodsPublic<ClassPublic, InstancePublic, nil>
export type InstanceInternal =
	InstancePublic
	& InstanceFieldsPrivate<ClassInternal, InstanceInternal, nil>
	& InstanceMethodsPrivate<ClassInternal, InstanceInternal, nil>

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

		@return `NewClass` <<b>NewClass Instance</b>>
	]]
	new: () -> InstancePublic,

	--[[
		Create a new instance of this class with the option of 
		being initialized. If the instance is not initialized, it
		must be initialized manually to define the missing class
		fields: `_class`, `_className`, `_super`.

		@return `NewClass` <<b>NewClass Instance</b>>
	]]
	newWithInitialization: (withInitialization: boolean) -> InstancePublic,

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
export type ClassPublic = ClassFieldsPublic & ClassMethodsPublic & newClass.ClassTemplatePublic<InstancePublic, nil>

export type ClassInternal =
	ClassPublic
	& ClassMethodsPrivate
	& ClassFieldsPrivate
	& InstanceMethodsPrivate<ClassInternal, InstanceInternal, nil>
	& InstanceMethodsPublic<ClassPublic, InstancePublic, nil>
	& newClass.ClassTemplatePrivate<InstancePublic, nil>

--[[
	Class definition
]]
local Object = newClass({} :: InstancePublic, "Object", Super) :: ClassInternal

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
function Object.newWithInitialization(withInitialization)
	local self = setmetatable({} :: InstanceInternal, Object)
	Object:__init__(self, withInitialization)

	--[[
		PRIVATE Fields - Instance
	]]
	self._serialId = Object:getLifetimeInstanceCount()
	self._isDestroyed = false

	--[[
		PUBLIC Fields - Instance
	]]

	-- Return new instance
	return self
end

function Object.new(...)
	return Object.newWithInitialization(true, ...)
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
function Object._getClass(self: InstanceInternal)
	return self._class
end

--[[
	PUBLIC Methods - Instance
]]
function Object.toString(self: InstanceInternal)
	return self._className .. "#" .. self:getId()
end

function Object.getId(self: InstanceInternal)
	return self._serialId
end

function Object.destroy(self: InstanceInternal)
	if self._isDestroyed then
		warn("Attempt to call destroy() on Object '" .. self:getClassName() .. "' (Object has already been destroyed")
		return self
	end

	self._isDestroyed = true
	local _class = self:_getClass() :: newClass.AnyClassInternal?

	-- ripple up the class hierarchy and remove references
	-- to the instance
	while _class ~= nil do
		local class = _class :: newClass.AnyClassInternal
		class:_decrementActiveInstanceCount()
		class._activeInstances[self] = nil
		_class = class:getSuperClass()
	end

	return self
end

function Object.isDestroyed(self: InstanceInternal)
	return self._isDestroyed
end

function Object.getClass(self: InstanceInternal)
	return self._class
end

--[[
	TEST CODE:

	A class-level function which contains optional or temporary 
	test-code, ideally for testing class features.
]]
function Object.test() end

-- Export the final class with a public interface
return Object :: ClassPublic
