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
	_class: ClassInternal,
	-- _super: SuperType.ClassInternal, -- inheritance
}

export type InstanceMethodsPublic = {
	toString: (self: InstanceInternal) -> string,
	getId: (self: InstanceInternal) -> number,
	getClassName: (self: InstanceInternal) -> string,
	destroy: (self: InstanceInternal) -> (),
	isDestroyed: (self: InstanceInternal) -> boolean,
	getClass: (self: InstanceInternal) -> ClassPublic<InstancePublic>,
}

export type InstanceMethodsPrivate = {
	-- private instance methods
	_getClass: (self: InstanceInternal) -> ClassInternal,
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

export type ClassMethodsPublic<O> = {
	-- public static methods here
	new: () -> O,
}

-- We pass a generic type "O" in case a class method accepts any instance parameters
export type ClassMethodsPrivate<O> = {
	-- private static methods here
}

export type ClassPublic<O> = ClassFieldsPublic & ClassMethodsPublic<O> & newClass.ClassTemplatePublic<O>

export type ClassInternal =
	ClassPublic<InstancePublic>
	& ClassMethodsPrivate<InstancePublic>
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
	-- local self = setmetatable((_self._super.new() :: any) :: InstanceInternal, Object)
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
--

-- Public instance methods
function Object.toString(self)
	return self._className .. "#" .. self:getId()
end

function Object.getId(self)
	return self._serialId
end

function Object.getClassName(self)
	return self._className
end

function Object.destroy(self)
	local _class = self:_getClass()
	_class:_decrementActiveInstanceCount()
	_class._activeInstances[self] = nil
	self._isDestroyed = true
end

function Object.isDestroyed(self)
	return self._isDestroyed
end
--

return Object :: ClassPublic<InstancePublic>
