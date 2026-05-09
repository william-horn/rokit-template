--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Grandparent class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Object = require(ReplicatedStorage.Shared.Classes.Object)
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)

-- Non-static types
export type InstanceFieldsPublic = {
	-- public instance fields here
}

export type InstanceFieldsPrivate = {
	-- private instance fields here
	_super: Super.ClassInternal, -- inheritance
	_age: number,
	_name: string,
}

export type InstanceMethodsPublic = {
	--
	getAge: (self: any) -> number,
	getName: (self: any) -> string,
	toString: (self: any) -> string, -- @Override
	grandparentMethod: (self: any) -> string,
}

export type InstanceMethodsPrivate = {
	-- private instance methods
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods = InstanceMethodsPrivate & InstanceMethodsPublic
export type InstancePublic = InstanceMethodsPublic & InstanceFieldsPublic & Super.InstancePublic -- inherit
export type InstancePrivate = InstanceMethodsPrivate & InstanceFieldsPrivate & Super.InstancePrivate -- inherit
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

export type ClassMethodsPrivate<O> = {
	-- private static methods here
}

export type ClassPublic<O> = ClassFieldsPublic & ClassMethodsPublic<O> & newClass.ClassTemplatePublic

export type ClassInternal =
	ClassPublic<InstancePublic>
	& ClassMethodsPrivate<InstancePublic>
	& ClassFieldsPrivate
	& InstanceMethods
	& newClass.ClassTemplatePrivate

local Grandparent = newClass("Grandparent", Super) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function Grandparent.new()
	Grandparent:__init__()

	-- Init public & private fields
	local _self: InstanceFields = {
		_super = Super :: Super.ClassInternal,
		_age = 80,
		_name = "Larry",
	}

	-- If inheriting:
	local self = setmetatable((_self._super.new() :: any) :: InstanceInternal, Grandparent)
	-- local self = setmetatable(_self :: InstanceInternal, Grandparent)

	-- Assign private fields
	self._className = Grandparent:getClassName()
	self._age = _self._age
	self._name = _self._name
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
function Grandparent.getAge(self: InstanceInternal)
	return self._age
end

function Grandparent.getName(self: InstanceInternal)
	return self._name
end

function Grandparent.toString(self: InstanceInternal)
	return self._name .. " is " .. self._age .. " years old"
end

function Grandparent.grandparentMethod(self: InstanceInternal)
	return "Some grandparent thing"
end
--

return Grandparent :: ClassPublic<InstancePublic>
