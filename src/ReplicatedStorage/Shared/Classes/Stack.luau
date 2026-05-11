--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Stack class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local Table = require(ReplicatedStorage.Shared.Types.Table)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)

-- Non-static types
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {
	-- public instance fields here
}

export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	-- private instance fields here
	_stack: Table.ArrayOf<any>,
}

export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	-- public instance methods here
	pop: (self: any) -> any,
	push: (self: any, item: any) -> any,
	peek: (self: any) -> any,
}

export type LocalInstanceMethodsPrivate<CI, II, SCI> = {
	-- private instance methods
}

export type InstanceFieldsPublic<CP, IP, SCP> =
	LocalInstanceFieldsPublic<CP, IP, SCP>
	& Super.InstanceFieldsPublic<CP, IP, SCP>
export type InstanceMethodsPublic<CP, IP, SCP> =
	LocalInstanceMethodsPublic<CP, IP, SCP>
	& Super.InstanceMethodsPublic<CP, IP, SCP>
export type InstanceFieldsPrivate<CI, II, SCI> =
	LocalInstanceFieldsPrivate<CI, II, SCI>
	& Super.InstanceFieldsPrivate<CI, II, SCI>
export type InstanceMethodsPrivate<CI, II, SCI> =
	LocalInstanceMethodsPrivate<CI, II, SCI>
	& Super.InstanceMethodsPrivate<CI, II, SCI>
export type InstancePublic =
	InstanceFieldsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
	& InstanceMethodsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
export type InstanceInternal =
	InstancePublic
	& InstanceFieldsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>
	& InstanceMethodsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>

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
	& InstanceMethodsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>
	& InstanceMethodsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
	& newClass.ClassTemplatePrivate<InstancePublic, Super.ClassPublic>

local Stack = newClass({} :: InstancePublic, "Stack", Super) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function Stack.newWithInitialization(withInitialization)
	-- If inheriting:
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, Stack)
	-- local self = setmetatable(_self :: InstanceInternal, Stack)
	Stack:__init__(self, withInitialization)

	-- Assign private fields
	self._stack = {}
	--

	-- Assign public fields
	--

	-- Return new instance
	return self
end

function Stack.new()
	return Stack.newWithInitialization(true)
end
--

-- Public static methods
--

-- Private static methods
--

-- Private instance methods
--

-- Public instance methods
function Stack.push(self: InstanceInternal, item)
	self._stack[#self._stack + 1] = item
	return item
end

function Stack.pop(self: InstanceInternal)
	local stack = self._stack
	local item = stack[#stack]
	stack[#stack] = nil
	return item
end

function Stack.peek(self: InstanceInternal)
	return self._stack[#self._stack]
end
--

return Stack :: ClassPublic
