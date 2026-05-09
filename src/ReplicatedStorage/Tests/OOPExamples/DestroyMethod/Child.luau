--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Child class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Super = require(script.Parent:FindFirstChild("Parent"))
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
	childMethod: (self: any) -> (),
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

export type ClassMethodsPublic = {
	-- public static methods here
	new: () -> InstancePublic,
	childConstructor: () -> (),
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

local Child = newClass({} :: InstancePublic, "Child", Super) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function Child.new()
	-- If inheriting:
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, Child)
	-- local self = setmetatable(_self :: InstanceInternal, Child)
	Child:__init__(self)

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
function Child.childMethod(self: InstanceInternal)
	print("Child method ran")
end
--

return Child :: ClassPublic
