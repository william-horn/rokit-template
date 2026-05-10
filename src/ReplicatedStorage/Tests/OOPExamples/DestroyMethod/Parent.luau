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
export type InstanceFieldsPublic<CP, IP, SCP> = {
	-- public instance fields here
}

export type InstanceFieldsPrivate<CI, II, SCI> = {
	-- private instance fields here
	-- _super: Super.ClassInternal, -- inheritance
}

export type InstanceMethodsPublic<CP, IP, SCP> = {
	-- public instance methods here
	parentMethod: (self: any) -> (),
}

export type InstanceMethodsPrivate<CI, II, SCI> = {
	-- private instance methods
}

export type InstancePublic =
	InstanceMethodsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
	& InstanceFieldsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
	& Super.InstanceMethodsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
	& Super.InstanceFieldsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
export type InstanceInternal =
	InstancePublic
	& InstanceMethodsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>
	& InstanceFieldsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>
	& Super.InstanceMethodsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>
	& Super.InstanceFieldsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>

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

export type ClassPublic =
	ClassFieldsPublic
	& ClassMethodsPublic
	& newClass.ClassTemplatePublic<InstancePublic, Super.ClassPublic>

export type ClassInternal =
	ClassPublic
	& ClassMethodsPrivate
	& ClassFieldsPrivate
	& InstanceMethodsPrivate<ClassInternal, InstanceInternal, nil>
	& InstanceMethodsPublic<ClassPublic, InstancePublic, nil>
	& newClass.ClassTemplatePrivate<InstancePublic, Super.ClassPublic>

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
