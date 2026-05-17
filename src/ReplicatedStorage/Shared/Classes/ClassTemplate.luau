--!strict
--[[
	@author William J. Horn (ScriptGuider@ROBLOX.com)
	@written 5/12/2026

	If you have any questions, email williamjosephhorn@gmail.com
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)

--[[
	PUBLIC Static Methods & Fields - Class

	Public base class attributes that are applied to every 
	newly created class. Both fields and method signatures
	are defined here, and will be displayed publicly.
]]
export type ClassTemplatePublic<IP, SCP> = {
	--[[
		Gets the current active instance count in a class. The
		active instance count increments by 1 every time a 
		constructor is called with object initialization.

		<b>Example:</b>

		```luau
		print(Object:getActiveInstanceCount()) --> 0
		local o = Object.new()
		print(Object:getActiveInstanceCount()) --> 1
		```

		Without initialization, `_activeInstanceCount` is not
		incremented:

		```luau
		print(Object:getActiveInstanceCount()) --> 0
		local o = Object.newWithInitialization(false)
		print(Object:getActiveInstanceCount()) --> 0
		```

		@return `activeInstanceCount` <<b>number</b>> The current active
		instance count in the class.
	]]
	getActiveInstanceCount: (class: any) -> number,

	--[[
		Get the class name of the class. This is exactly identical
		to calling `getClassName()` on an instance of the class, since
		they share the same function.

		<b>Example:</b>

		```luau
		print(Object:getClassName()) --> "Object"
		```

		@return `className` <<b>string</b>> The class name of the class.
	]]
	getClassName: (class: any) -> string,

	--[[
		Checks to see if some instance `obj` is of the same 
		class as the current class. Does <b>not</b> account for 
		sub-classes.

		<b>Example:</b>

		```luau
		local o = Object.new()
		local c = Car.new()

		print(Car.is(c)) --> true
		print(Car.is(o)) --> false
		```

		@param obj <<b>Instance</b>> The object to compare the class of.
	]]
	is: (class: any, obj: any) -> boolean,

	--[[
		Get the super class of the current class. This method
		is exactly identical to calling `getSuperClass()` on an 
		instance, since they share the same function.

		<b>Example:</b>

		```luau
		local toyota_super = Toyota:getSuperClass()
		print(toyota_super:getClassName()) --> "Car"
		```

		@return `Class` <<b>Class</b>> The super class of the current class, or `nil` if there is none.
	]]
	getSuperClass: (class: any) -> SCP,

	--[[
		Get the total lifetime instance count of the class. This method
		returns the internal tracking of how many times the class constructor
		was called with initialization over the runtime of the program. 

		<b>Example:</b>

		```luau
		local o = Object.new()
		print(Object:getLifetimeInstanceCount()) --> 1

		o = Object.new()
		o:destroy()
		print(Object:getLifetimeInstanceCount()) --> 2
		```

		@return `lifetimeInstanceCount` <<b>number</b>> The total number of past and present instances created with initialization.
	]]
	getLifetimeInstanceCount: (class: any) -> number,
}

--[[
	PRIVATE Static Methods & Fields - Class

	Private base class attributes that are applied to every 
	newly created class. Both fields and method signatures
	are defined here, but are reserved privately for internal
	class use.
]]
export type ClassTemplatePrivate<IP, SCP> = {
	--[[
		Tracks the total number of instances that have
		been created by the class constructor with initialization. 
		Calling `destroy()` on an instance will not decrement this
		counter, unlike with `_activeInstanceCount`
	]]
	_lifetimeInstanceCount: number,

	--[[
		Increments the `_lifetimeInstanceCount` field, usually when
		a new instance is created with initialization.

		<b>Example:</b>

		```luau
		print(Object:getLifetimeInstanceCount()) --> 0
		Object.new()
		print(Object:getLifetimeInstanceCount()) --> 1
		```

		If object is not initialized, this will not increment the
		field:

		```luau
		print(Object:getLifetimeInstanceCount()) --> 0
		Object.newWithInitialization(false)
		print(Object:getLifetimeInstanceCount()) --> 0
		```
	]]
	_incrementLifetimeInstanceCount: (self: any) -> (),

	--[[
		The class name of the current class.
	]]
	_className: string,

	--[[
		<<b>number</b>> Tracks the total number of currently active
		instances in the program. This means instances that were created
		with initialization, and have not yet had `destroy()` called on them.

		If this number is less than the size of `_memorizedInstances`, that
		is cause for concern of a memory leak.
	]]
	_activeInstanceCount: number,

	--[[
		Stores every new instance that has been created with 
		initialization and holds it's reference. This is mainly for tracking 
		memory leaks, or flagging situations where an  instance should have 
		been destroyed but wasn't.
	]]
	_activeInstances: Table.Map<IP, true>,

	--[[
		A weak table (array) which stores all instances that have been created 
		with initialization. Similar to `_activeInstances`, this will hold the 
		instance in a table during it's lifetime.

		Unlike `_activeInstances`, this is a weak array which will automatically
		drop the object once it becomes eligible for garbage collection.
	]]
	_memorizedInstances: typeof(setmetatable({} :: Table.ArrayOf<IP>, { __mode = "v" })),

	--[[
		Increments the active instance count in a class. This usually
		occurs when a new instance of a class has been created.

		<b>Example:</b>

		```luau
		-- somewhere in the class file
		print(self:getActiveInstanceCount()) --> 1
		self:_incrementActiveInstanceCount()
		print(self:getActiveInstanceCount()) --> 2
		```
	]]
	_incrementActiveInstanceCount: (class: any) -> (),

	--[[
		Decrements the active instance count in a class. This usually
		occurs when `destroy()` is called on an instance.

		<b>Example:</b>

		```luau
		-- somewhere in the class file
		print(self:getActiveInstanceCount()) --> 2
		self:_decrementActiveInstanceCount()
		print(self:getActiveInstanceCount()) --> 1

		-- `destroy()` will also call this method internally
		self:destroy()
		print(self:getActiveInstanceCount()) --> 0
		```
	]]
	_decrementActiveInstanceCount: (class: any) -> (),

	--[[
		The super class of the current class, using the internal
		class interface.
	]]
	_super: SCP,

	--[[
		The default initialization method that is called inside the
		constructor of every class. The line of code calling this
		method can be omitted if default initialization is not 
		desired for the class, or you can use 
		`newWithInitialization(false)`

		By default, this method increments internal instance tracking
		fields such as `_activeInstanceCount`, assigns fields to the
		instance relevant to it's class such as `_className`, and
		stores the instance internally until it is destroyed.
	]]
	__init__: (class: any, instance: IP, withInitialization: boolean) -> (),

	--[[
		The metamethod pointing to the class's super class.
	]]
	__index: ClassTemplate<IP, SCP>,
}

--[[
	Define an intersection between public and private class
	attribute domains to represent the entire internal class 
	interface.
]]
export type ClassTemplate<IP, SCP> = ClassTemplatePublic<IP, SCP> & ClassTemplatePrivate<IP, SCP>
export type AnyClassPublic = ClassTemplatePublic<any, any>
export type AnyClassInternal = ClassTemplate<any, any>

local function _incrementActiveInstanceCount(class: AnyClassInternal)
	class._activeInstanceCount += 1
end

local function _decrementActiveInstanceCount(class: AnyClassInternal)
	class._activeInstanceCount -= 1
end

local function getActiveInstanceCount(class: AnyClassInternal)
	return class._activeInstanceCount
end

local function getClassName(class: AnyClassInternal)
	return class._className
end

local function is(class: AnyClassInternal, obj: any)
	return typeof(obj) == "table" and getmetatable(obj) == class
end

local function getSuperClass(class: AnyClassInternal)
	return class._super
end

local function getLifetimeInstanceCount(class: AnyClassInternal)
	return class._lifetimeInstanceCount
end

local function _incrementLifetimeInstanceCount(class: AnyClassInternal)
	class._lifetimeInstanceCount += 1
end

local function __init__(class: AnyClassInternal, instance, withInitialization: boolean)
	if withInitialization == false then
		return
	end

	class:_incrementActiveInstanceCount()
	class:_incrementLifetimeInstanceCount()

	--! problem
	class._activeInstances[instance] = instance
	class._memorizedInstances[#class._memorizedInstances + 1] = instance

	instance._class = class
	instance._className = class:getClassName()
	instance._super = class._super
end

local function newClass<IP, _, SCP>(_: IP, className: string, superClass: SCP)
	local class = {} :: ClassTemplate<IP, SCP>
	class.__index = setmetatable(class, superClass)

	-- public fields
	--

	-- private fields
	class._super = superClass
	class._className = className
	class._activeInstanceCount = 0
	class._lifetimeInstanceCount = 0
	class._activeInstances = {}
	class._memorizedInstances = setmetatable({}, { __mode = "v" })

	-- public methods
	class.getActiveInstanceCount = getActiveInstanceCount
	class.getLifetimeInstanceCount = getLifetimeInstanceCount
	class.getClassName = getClassName
	class.getSuperClass = getSuperClass
	class.is = is

	-- private methods
	class._incrementActiveInstanceCount = _incrementActiveInstanceCount
	class._decrementActiveInstanceCount = _decrementActiveInstanceCount
	class._incrementLifetimeInstanceCount = _incrementLifetimeInstanceCount

	-- default constructor
	class.__init__ = __init__

	return class
end

return newClass
