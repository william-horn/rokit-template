--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Parent class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)

-- Non-static types
export type InstanceFieldsPublic = {
	-- public instance fields here
}

export type InstanceFieldsPrivate = {
	-- private instance fields here
	-- _super: Super.ClassInternal, -- inheritance
}

export type InstanceMethodsPublic = {
	-- public instance methods here
	parentMethod: (self: any) -> (),
}

export type InstanceMethodsPrivate = {
	-- private instance methods
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods = InstanceMethodsPrivate & InstanceMethodsPublic
export type InstancePublic =
	InstanceMethodsPublic
	& InstanceFieldsPublic
	& Super.InheritedInstancePublic<ClassPublic, InstancePublic, Super.ClassPublic>
export type InstancePrivate = InstanceMethodsPrivate & InstanceFieldsPrivate & Super.InstancePrivate
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
	parentConstructor: () -> (),
}

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

local Parent = newClass({} :: InstancePublic, "Parent", Super) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function Parent.new()
	-- If inheriting:
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, Parent)
	-- local self = setmetatable(_self :: InstanceInternal, Parent)
	Parent:__init__(self)

	-- Assign private fields
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
function Parent.parentMethod(self: InstanceInternal)
	print("Parent method", self:getClassName())
end
--

return Parent :: ClassPublic
