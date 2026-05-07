--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Parent class
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
}

export type InstanceMethodsPublic = {
	--
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

local Parent = newClass("Parent", Super) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function Parent.new()
	-- Init public & private fields
	local _self: InstanceFields = {
		_super = Super :: Super.ClassInternal,
	}

	-- If inheriting:
	local self = setmetatable((_self._super.new() :: any) :: InstanceInternal, Parent)
	-- local self = setmetatable(_self :: InstanceInternal, Parent)

	Parent:_incrementInstanceCount()

	-- Assign private fields
	self._serialId = Object:getInstanceCount()
	self._className = "Parent"
	self._super = _self._super
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
-- function Parent.toString(self: InstanceInternal)
-- 	return self._className
-- end

-- function Parent.getSerialId(self: InstanceInternal)
-- 	return self._serialId
-- end
--

return Parent :: ClassPublic<InstancePublic>
