--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)

export type ClassTemplatePublic<O> = {
	getActiveInstanceCount: (self: any) -> number,
	getClassName: (self: any) -> string,
	is: (self: any, obj: any) -> boolean,
}

export type ClassTemplatePrivate<O> = {
	_className: string,
	_activeInstanceCount: number,
	_activeInstances: Table.Map<O, true>,
	_memorizedInstances: typeof(setmetatable({} :: Table.ArrayOf<O>, { __mode = "v" })),
	_incrementActiveInstanceCount: (self: any) -> (),
	_decrementActiveInstanceCount: (self: any) -> (),
	_super: Table.Map<string, any>?,
	__init__: (self: any, instance: O) -> (),
	__index: Table.Map<string, any>,
}

export type ClassTemplate<O> = ClassTemplatePublic<O> & ClassTemplatePrivate<O>

local function _incrementActiveInstanceCount(self: ClassTemplate<any>)
	self._activeInstanceCount += 1
end

local function _decrementActiveInstanceCount(self: ClassTemplate<any>)
	self._activeInstanceCount -= 1
end

local function getActiveInstanceCount(self: ClassTemplate<any>)
	return self._activeInstanceCount
end

local function getClassName(self: ClassTemplate<any>)
	return self._className
end

local function is(self: ClassTemplate<any>, obj: any)
	return typeof(obj) == "table" and getmetatable(obj) == self
end

local function __init__(self: ClassTemplate<any>, instance: any)
	self:_incrementActiveInstanceCount()

	instance._className = self:getClassName()

	self._activeInstances[instance] = true
	self._memorizedInstances[#self._memorizedInstances + 1] = instance
end

local function newClass<O>(_: O, className: string, superClass: Table.Map<string, any>?)
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
	class.is = is

	-- private methods
	class._incrementActiveInstanceCount = _incrementActiveInstanceCount
	class._decrementActiveInstanceCount = _decrementActiveInstanceCount

	-- default constructor
	class.__init__ = __init__

	return class
end

return newClass
