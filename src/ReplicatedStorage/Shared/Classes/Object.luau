--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Table = require(ReplicatedStorage.Shared.Types.Table)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
-- local Super = nil

-- Non-static types
export type InstanceFieldsPublic = {
	-- public instance fields here
}

export type InstanceFieldsPrivate = {
	-- private instance fields here
	_serialId: number,
	_className: string,
	_isDestroyed: boolean,
	_class: ClassInternal, --newClass.UnknownClass<InstanceInternal>,
	_super: newClass.UnknownClass<any>?,
	-- _super: SuperType.ClassInternal, -- inheritance
}

export type InstanceMethodsPublic = {
	toString: (self: any) -> string,
	getId: (self: any) -> number,
	getClassName: (self: any) -> string,
	destroy: (self: any) -> (),
	isDestroyed: (self: any) -> boolean,
	getClass: (self: any) -> ClassPublic, --newClass.UnknownClass<InstanceInternal>,
	getSuperClass: (self: any) -> newClass.UnknownClass<any>?,
}

export type InstanceMethodsPrivate = {
	-- private instance methods
	_getClass: (self: any) -> ClassInternal, --newClass.UnknownClass<InstanceInternal>,
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods = InstanceMethodsPrivate & InstanceMethodsPublic
export type InstancePublic = InstanceMethodsPublic & InstanceFieldsPublic
export type InstancePrivate = InstanceMethodsPrivate & InstanceFieldsPrivate
export type InstanceInternal = InstancePublic & InstancePrivate

-- Static types
export type ClassFieldsPublic = {
	-- public static fields here
}

export type ClassFieldsPrivate = {
	-- private static fields here
}

export type ClassMethodsPublic = {
	-- public static methods here
	new: () -> InstancePublic,
	objectConstructor: () -> (),
}

-- We pass a generic type "O" in case a class method accepts any instance parameters
export type ClassMethodsPrivate = {
	-- private static methods here
}

export type ClassPublic = ClassFieldsPublic & ClassMethodsPublic & newClass.ClassTemplatePublic<InstancePublic>

export type ClassInternal =
	ClassPublic
	& ClassMethodsPrivate
	& ClassFieldsPrivate
	& InstanceMethods
	& newClass.ClassTemplatePrivate<InstancePublic>

local Object = newClass({} :: InstancePublic, "Object") :: ClassInternal

-- Private static fields
-- Object._foo = "bar"
--

-- Public static fields
--

-- Constructors
function Object.new()
	-- If inheriting:
	-- local self = setmetatable((Super.new() :: any) :: InstanceInternal, Object)
	local self = setmetatable({} :: InstanceInternal, Object)
	Object:__init__(self)

	-- Assign private fields
	self._serialId = Object:getActiveInstanceCount()
	self._isDestroyed = false
	--

	-- Assign public fields
	--

	-- Return new instance
	return self
end
--

-- Public static methods
--

-- Private static methods
--

-- Private instance methods
function Object._getClass(self: InstanceInternal)
	return self._class
end
--

-- Public instance methods
function Object.toString(self: InstanceInternal)
	return self._className .. "#" .. self:getId()
end

function Object.getId(self: InstanceInternal)
	return self._serialId
end

function Object.getClassName(self: InstanceInternal)
	return self._className
end

function Object.destroy(self: InstanceInternal)
	self._isDestroyed = true

	local _class = self:_getClass() :: newClass.UnknownClass<any>?

	while _class ~= nil do
		local class = _class :: newClass.AnyClass
		class:_decrementActiveInstanceCount()
		class._activeInstances[self] = nil
		_class = class:getSuperClass()
	end
end

function Object.isDestroyed(self: InstanceInternal)
	return self._isDestroyed
end

function Object.getClass(self: InstanceInternal)
	return self._class
end

function Object.getSuperClass(self: InstanceInternal)
	return self._super
end
--

return Object :: ClassPublic
