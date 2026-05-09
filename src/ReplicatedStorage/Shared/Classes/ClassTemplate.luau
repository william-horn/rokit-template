--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)

export type ClassTemplatePublic<O> = {
	getActiveInstanceCount: (class: any) -> number,
	getClassName: (class: any) -> string,
	is: (class: any, obj: any) -> boolean,
	getSuperClass: (class: any) -> UnknownClass<O>?,
}

export type ClassTemplatePrivate<O> = {
	_className: string,
	_activeInstanceCount: number,
	_activeInstances: Table.Map<O, true>,
	_memorizedInstances: typeof(setmetatable({} :: Table.ArrayOf<O>, { __mode = "v" })),
	_incrementActiveInstanceCount: (class: any) -> (),
	_decrementActiveInstanceCount: (class: any) -> (),
	_super: UnknownClass<O>?,
	__init__: (class: any, instance: O) -> (),
	__index: ClassTemplate<O>, --Table.Map<string, any>,
}

export type ClassTemplate<O> = ClassTemplatePublic<O> & ClassTemplatePrivate<O>
export type UnknownClass<O> = ClassTemplatePublic<O> | ClassTemplate<O>
export type AnyClass = ClassTemplate<any>

local function _incrementActiveInstanceCount(class: AnyClass)
	class._activeInstanceCount += 1
end

local function _decrementActiveInstanceCount(class: AnyClass)
	class._activeInstanceCount -= 1
end

local function getActiveInstanceCount(class: AnyClass)
	return class._activeInstanceCount
end

local function getClassName(class: AnyClass)
	return class._className
end

local function is(class: AnyClass, obj: any)
	return typeof(obj) == "table" and getmetatable(obj) == class
end

local function getSuperClass(class: AnyClass)
	return class._super
end

local function __init__(class: AnyClass, instance)
	class:_incrementActiveInstanceCount()

	class._activeInstances[instance] = true
	class._memorizedInstances[#class._memorizedInstances + 1] = instance

	instance._class = class
	instance._className = class:getClassName()
	instance._super = class._super
end

local function newClass<O>(_: O, className: string, superClass: UnknownClass<any>?)
	local class = {} :: ClassTemplate<O>
	class.__index = setmetatable(class, superClass)

	-- public fields
	--

	-- private fields
	class._super = superClass
	class._className = className
	class._activeInstanceCount = 0
	class._activeInstances = {}
	class._memorizedInstances = setmetatable({}, { __mode = "v" })

	-- public methods
	class.getActiveInstanceCount = getActiveInstanceCount
	class.getClassName = getClassName
	class.getSuperClass = getSuperClass
	class.is = is

	-- private methods
	class._incrementActiveInstanceCount = _incrementActiveInstanceCount
	class._decrementActiveInstanceCount = _decrementActiveInstanceCount

	-- default constructor
	class.__init__ = __init__

	return class
end

return newClass
