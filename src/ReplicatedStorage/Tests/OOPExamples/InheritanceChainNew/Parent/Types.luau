--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)
local SuperTypes = require(script.Parent.Parent.Grandparent.Types)

-- Non-static types
type InstanceFieldsPublic = {
	-- public instance fields here
}

type InstanceFieldsPrivate = {
	-- private instance fields here
	_super: SuperTypes.ClassInternal, -- inheritance
	_serialId: number,
	_className: string,
}

type InstanceMethodsPublic = {
	objectMethod: (self: any) -> boolean, -- override (polymorphism)
	grandparentMethod: (self: any) -> number,
}

type InstanceMethodsPrivate = {
	-- private instance methods
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods = InstanceMethodsPrivate & InstanceMethodsPublic
export type InstancePublic = InstanceMethodsPublic & InstanceFieldsPublic & SuperTypes.InstancePublic -- inheritance
export type InstanceInternal = InstancePublic & InstanceFieldsPrivate & InstanceMethodsPrivate

-- Static types
export type ClassFieldsPublic = {
	-- public static fields here
}

export type ClassFieldsPrivate = {
	-- private static fields here
	__index: Table.Map<string, any>,
	_instancesCreated: number,
}

export type ClassMethodsPublic<O> = {
	-- public static methods here
	new: (...any) -> O,
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

return nil
