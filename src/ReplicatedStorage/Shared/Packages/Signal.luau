--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local TableType = require(Shared.Types.Table)
local Object = require(script.Parent.Object)
local Class = require(ReplicatedStorage.Shared.Interfaces.Class)
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Signal class
]]
-- Non-static types
type InstanceFieldsPublic = Class.BaseInstanceFieldsPublic & {
	-- public instance fields here
}

type InstanceFieldsPrivate = Class.BaseInstanceFieldsPrivate & {
	-- private instance fields here
	_super: Object.ClassInternal,
}

type InstanceMethodsPublic = Class.BaseInstanceMethodsPublic & {
	-- public instance methods here
	toString: (self: any) -> string,
}

type InstanceMethodsPrivate = Class.BaseInstanceMethodsPrivate & {
	-- private instance methods
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods = InstanceMethodsPrivate & InstanceMethodsPublic
export type InstancePublic = InstanceFieldsPublic & InstanceMethodsPublic & Object.InstancePublic -- inherit

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
	& InstanceMethods
	& ClassFieldsPrivate
	& ClassMethodsPrivate<InstancePublic>

local Signal = {} :: ClassInternal

-- Private static fields
Signal.__index = setmetatable(Signal, Object)
Signal._instancesCreated = 0

-- Public static fields

-- Constructor
function Signal.new()
	-- Init public & private fields
	local _o: InstanceFields = {
		_className = "",
		_serialId = 0,
		_super = {} :: Object.ClassInternal,
	}

	local o = setmetatable((Object.new() :: any) :: InstanceInternal, Signal)

	-- Assign private fields
	o._className = "Signal"
	o._super = Object :: Object.ClassInternal
	--

	-- Assign public fields
	--

	Signal._incrementInstanceCount()

	-- Return new instance
	return o
end

-- Public static methods
function Signal.getInstanceCount()
	return Signal._instancesCreated
end

-- Private static methods
function Signal._incrementInstanceCount()
	Signal._instancesCreated += 1
end

-- Private instance methods

-- Public instance methods
function Signal.toString(self: InstanceInternal)
	return self._super.toString(self) .. " - ADDED"
end

return Signal :: ClassPublic<InstancePublic>
