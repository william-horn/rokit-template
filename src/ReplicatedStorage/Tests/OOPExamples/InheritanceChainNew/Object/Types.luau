--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)
-- local SuperTypes = require(ReplicatedStorage.Shared.Classes.____.Types)

-- Non-static types
export type InstanceFieldsPublic = {
	-- public instance fields here
}

export type InstanceFieldsPrivate = {
	-- private instance fields here
	_serialId: number,
	_className: string,
	-- _super: SuperType.ClassInternal, -- inheritance
}

export type InstanceMethodsPublic = {
	toString: (self: any) -> string,
	objectMethod: (self: any) -> number,
	getSerialId: (self: any) -> number,
}

export type InstanceMethodsPrivate = {
	-- private instance methods
}

export type InstanceFields = InstanceFieldsPrivate & InstanceFieldsPublic
export type InstanceMethods = InstanceMethodsPrivate & InstanceMethodsPublic
export type InstancePublic = InstanceMethodsPublic & InstanceFieldsPublic -- & SuperType.InstancePublic
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
