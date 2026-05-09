--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Stack class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Object = require(ReplicatedStorage.Shared.Classes.Object)
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local Table = require(ReplicatedStorage.Shared.Types.Table)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)

-- Non-static types
export type InstanceFieldsPublic = {
	-- public instance fields here
}

export type InstanceFieldsPrivate = {
	-- private instance fields here
	_stack: Table.ArrayOf<any>,
	_super: Super.ClassInternal, -- inheritance
}

export type InstanceMethodsPublic = {
	-- public instance methods here
	pop: (self: any) -> any,
	push: (self: any, item: any) -> (),
	peek: (self: any) -> any,
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

local Stack = newClass("Stack", Object) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function Stack.new()
	Stack:__init__()

	-- Init public & private fields
	local _self: InstanceFields = {
		_super = Super :: Super.ClassInternal,
		_stack = {},
	}

	-- If inheriting:
	local self = setmetatable((_self._super.new() :: any) :: InstanceInternal, Stack)
	-- local self = setmetatable(_self :: InstanceInternal, Stack)

	-- Assign private fields
	self._className = Stack:getClassName()
	self._stack = _self._stack
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
function Stack.push(self: InstanceInternal, item)
	self._stack[#self._stack + 1] = item
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

return Stack :: ClassPublic<InstancePublic>
