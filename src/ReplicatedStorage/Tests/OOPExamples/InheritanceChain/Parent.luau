--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Parent class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Shared.Interfaces.Class)

local Super = require(script.Parent.Grandparent) -- inheriting from

-- Non-static types
type InstanceFieldsPublic = Class.BaseInstanceFieldsPublic & {
	-- public instance fields here
}

type InstanceFieldsPrivate = Class.BaseInstanceFieldsPrivate & {
	-- private instance fields here
	_super: Super.ClassInternal, -- inheritance
}

type InstanceMethodsPublic = Class.BaseInstanceMethodsPublic & {
}

type InstanceMethodsPrivate = Class.BaseInstanceMethodsPrivate & {
	-- private instance methods
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods = InstanceMethodsPrivate & InstanceMethodsPublic
export type InstancePublic = InstanceMethodsPublic & InstanceFieldsPublic & Super.InstancePublic -- inheritance
export type InstanceInternal = InstancePublic & InstanceFieldsPrivate & InstanceMethodsPrivate

-- Static types
export type ClassFieldsPublic = Class.BaseClassFieldsPublic & {
	-- public static fields here
}

export type ClassFieldsPrivate = Class.BaseClassFieldsPrivate & {
	-- private static fields here
}

export type ClassMethodsPublic<O> = Class.BaseClassMethodsPublic<O> & {
	-- public static methods here
}

export type ClassMethodsPrivate<O> = Class.BaseClassMethodsPrivate<O> & {
	-- private static methods here
}

export type ClassPublic<O> = ClassFieldsPublic & ClassMethodsPublic<O>

export type ClassInternal =
	ClassPublic<InstancePublic>
	& ClassMethodsPrivate<InstancePublic>
	& ClassFieldsPrivate
	& InstanceMethods

local Parent = {} :: ClassInternal

-- Private static fields
Parent.__index = setmetatable(Parent, Super) -- inheritance
Parent._instancesCreated = 0
--

-- Public static fields
--

-- Constructors
function Parent.new()
	-- Init public & private fields
	local _o: InstanceFields = {
		_serialId = Parent.getInstanceCount(),
		_className = "Parent",
		_super = Super :: Super.ClassInternal, -- inheritance
	}

	local o = setmetatable((_o._super.new() :: any) :: InstanceInternal, Parent)

	-- Assign private fields
	o._serialId = _o._serialId
	o._className = _o._className
	o._super = _o._super
	--

	-- Assign public fields
	--

	Parent._incrementInstanceCount()

	-- Return new instance
	return o
end
--

-- Public static methods
function Parent.getInstanceCount()
	return Parent._instancesCreated
end
--

-- Private static methods
function Parent._incrementInstanceCount()
	Parent._instancesCreated += 1
end
--

-- Private instance methods
--

-- Public instance methods
--

return Parent :: ClassPublic<InstancePublic>
