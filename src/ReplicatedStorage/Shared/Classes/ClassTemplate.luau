--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)

export type ClassTemplatePublic = {
	getInstanceCount: (self: any) -> number,
	getClassName: (self: any) -> string,
}

export type ClassTemplatePrivate = {
	_instanceCount: number,
	_incrementInstanceCount: (self: any) -> (),
	_className: string,
	__index: Table.Map<string, any>,
}

export type ClassTemplate = ClassTemplatePrivate & ClassTemplatePublic

local function _incrementInstanceCount(self: ClassTemplate)
	self._instanceCount += 1
end

local function getInstanceCount(self: ClassTemplate)
	return self._instanceCount
end

local function getClassName(self: ClassTemplate)
	return self._className
end

local function newClass(_className: string?, superClass: Table.Map<string, any>?)
	local className: string = _className or "Class"

	local class = {} :: ClassTemplate
	class.__index = setmetatable(class, superClass)

	-- public fields
	--

	-- private fields
	class._className = className
	class._instanceCount = 0

	-- public methods
	class.getInstanceCount = getInstanceCount
	class.getClassName = getClassName

	-- private methods
	class._incrementInstanceCount = _incrementInstanceCount

	return class
end

return newClass
