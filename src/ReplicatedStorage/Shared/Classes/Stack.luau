--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Stack class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)
local Super = require(script.Parent.Object)

-- Non-static types
export type InstanceFieldsPublic = {
	-- public instance fields here
}

export type InstanceFieldsPrivate = {
	-- private instance fields here
	_serialId: number,
	_className: string,
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
export type InstancePublic = InstanceMethodsPublic & InstanceFieldsPublic & Super.InstancePublic
export type InstanceInternal = InstancePublic & InstanceFieldsPrivate & InstanceMethodsPrivate

-- Static types
export type ClassFieldsPublic = {
	-- public static fields here
}

export type ClassFieldsPrivate = {
	-- private static fields here
	__index: Table.Map<string, any>,
	_instanceCount: number,
}

export type ClassMethodsPublic<O> = {
	-- public static methods here
	new: () -> O,
	getInstanceCount: () -> number,
}

export type ClassMethodsPrivate<O> = {
	-- private static methods here
	_incrementInstanceCount: () -> (),
}

export type ClassPublic<O> = ClassFieldsPublic & ClassMethodsPublic<O>

export type ClassInternal =
	ClassPublic<InstancePublic>
	& ClassMethodsPrivate<InstancePublic>
	& ClassFieldsPrivate
	& InstanceMethods

local Stack = {} :: ClassInternal

-- Private static fields
Stack.__index = setmetatable(Stack, Super)
Stack._instanceCount = 0
--

-- Public static fields
--

-- Constructors
function Stack.new() -- `T & { any }` included to force array type through valid intersection
	-- Init public & private fields
	local _self: InstanceFields = {
		_serialId = 0,
		_className = "",
		_super = Super :: Super.ClassInternal,
		_stack = {},
	}

	-- If inheriting:
	-- local self = setmetatable((_self._super.new() :: any) :: InstanceInternal, Stack)
	local self = setmetatable(_self :: InstanceInternal, Stack)

	-- Assign private fields
	self._serialId = Stack.getInstanceCount()
	self._className = "Stack"
	--

	-- Assign public fields
	--

	Stack._incrementInstanceCount()

	-- Return new instance
	return self
end
--

-- Public static methods
function Stack.getInstanceCount()
	return Stack._instanceCount
end
--

-- Private static methods
function Stack._incrementInstanceCount()
	Stack._instanceCount += 1
end
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
