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
	getActiveInstanceCount: (class: any) -> number,
	getClassName: (class: any) -> string,
	is: (class: any, obj: any) -> boolean,
	getSuperClass: (class: any) -> SCP,
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
	_lifetimeInstanceCount: number,
	_incrementLifetimeInstanceCount: (self: any) -> (),
	_className: string,
	_activeInstanceCount: number,
	_activeInstances: Table.Map<IP, true>,
	_memorizedInstances: typeof(setmetatable({} :: Table.ArrayOf<IP>, { __mode = "v" })),
	_incrementActiveInstanceCount: (class: any) -> (),
	_decrementActiveInstanceCount: (class: any) -> (),
	_super: SCP,
	__init__: (class: any, instance: IP, withInitialization: boolean) -> (),
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

--[[
	Increments the active instance count in a class. This usually
	occurs when a new instance of a class has been created.
]]
local function _incrementActiveInstanceCount(class: AnyClassInternal)
	class._activeInstanceCount += 1
end

--[[
	Decrements the active instance count in a class. This usually
	occurs when `destroy()` is called on an instance.
]]
local function _decrementActiveInstanceCount(class: AnyClassInternal)
	class._activeInstanceCount -= 1
end

--[[
	Gets the current active instance count in a class.

	@return `activeInstanceCount` <<b>number</b>> The current active
	instance count in the class.
]]
local function getActiveInstanceCount(class: AnyClassInternal)
	return class._activeInstanceCount
end

--[[
	Gets the class name.

	@return `className` <<b>string</b>> The class name.
]]
local function getClassName(class: AnyClassInternal)
	return class._className
end

--[[
	Checks to see if some instance `obj` is of the same 
	class as the current class. Does not account for 
	sub-classes.

	@param obj <<b>Instance</b>> The object to compare the class of.
]]
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

	class._activeInstances[instance] = true
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
