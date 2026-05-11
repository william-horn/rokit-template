--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Table = require(ReplicatedStorage.Shared.Types.Table)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
local Super = nil

-- Non-static types
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {
	-- public instance fields here
}

export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	-- private instance fields here
	_serialId: number,
	_className: string,
	_isDestroyed: boolean,
	_class: CI,
	_super: SCI,
}

export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	toString: (self: any) -> string,
	getId: (self: any) -> number,
	getClassName: (self: any) -> string,
	destroy: (self: any) -> (),
	isDestroyed: (self: any) -> boolean,
	getClass: (self: any) -> CP,
	getSuperClass: (self: any) -> SCP,
}

export type LocalInstanceMethodsPrivate<CI, II, SCI> = {
	-- private instance methods
	_getClass: (self: any) -> CI,
}

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
	newWithInitialization: (withInitialization: boolean) -> InstancePublic,
	test: () -> (),
}

-- We pass a generic type "O" in case a class method accepts any instance parameters
export type ClassMethodsPrivate = {
	-- private static methods here
}

export type ClassPublic = ClassFieldsPublic & ClassMethodsPublic & newClass.ClassTemplatePublic<InstancePublic, nil>

export type ClassInternal =
	ClassPublic
	& ClassMethodsPrivate
	& ClassFieldsPrivate
	& InstanceMethodsPrivate<ClassInternal, InstanceInternal, nil>
	& InstanceMethodsPublic<ClassPublic, InstancePublic, nil>
	& newClass.ClassTemplatePrivate<InstancePublic, nil>

local Object = newClass({} :: InstancePublic, "Object", Super) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function Object.newWithInitialization(withInitialization)
	-- If inheriting:
	-- local self = setmetatable((Super.new() :: any) :: InstanceInternal, Object)
	local self = setmetatable({} :: InstanceInternal, Object)
	Object:__init__(self, withInitialization)

	-- Assign private fields
	self._serialId = Object:getLifetimeInstanceCount()
	self._isDestroyed = false
	--

	-- Assign public fields
	--

	-- Return new instance
	return self
end

function Object.new(...)
	return Object.newWithInitialization(true, ...)
end

function Object.test()
	local o = Object.new()
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

function Object.destroy(self: InstanceInternal)
	self._isDestroyed = true

	local _class = self:_getClass() :: newClass.AnyClassInternal?

	-- ripple up the class hierarchy
	while _class ~= nil do
		local class = _class :: newClass.AnyClassInternal
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
--

return Object :: ClassPublic
