--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)

export type ClassTemplatePublic<IP, SCP> = {
	getActiveInstanceCount: (class: any) -> number,
	getClassName: (class: any) -> string,
	is: (class: any, obj: any) -> boolean,
	getSuperClass: (class: any) -> SCP?,
}

export type ClassTemplatePrivate<IP, SCP> = {
	_className: string,
	_activeInstanceCount: number,
	_activeInstances: Table.Map<IP, true>,
	_memorizedInstances: typeof(setmetatable({} :: Table.ArrayOf<IP>, { __mode = "v" })),
	_incrementActiveInstanceCount: (class: any) -> (),
	_decrementActiveInstanceCount: (class: any) -> (),
	_super: SCP?,
	__init__: (class: any, instance: IP) -> (),
	__index: ClassTemplate<IP, SCP>, --Table.Map<string, any>,
}

export type ClassTemplate<IP, SCP> = ClassTemplatePublic<IP, SCP> & ClassTemplatePrivate<IP, SCP>
export type AnyClassUnknown = ClassTemplatePublic<any, any> | ClassTemplate<any, any>
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

local function __init__(class: AnyClassInternal, instance)
	class:_incrementActiveInstanceCount()

	class._activeInstances[instance] = true
	class._memorizedInstances[#class._memorizedInstances + 1] = instance

	instance._class = class
	instance._className = class:getClassName()
	instance._super = class._super
end

local function newClass<IP, _, SCP>(_: IP, className: string, superClass: SCP?)
	local class = {} :: ClassTemplate<IP, SCP>
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
