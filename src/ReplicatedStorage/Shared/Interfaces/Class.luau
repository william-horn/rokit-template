local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local TableType = require(Shared.Types.Table)

export type BaseInstanceFieldsPublic = {}

export type BaseInstanceFieldsPrivate = {
	_serialId: number,
	_className: string,
}

export type BaseInstanceMethodsPublic<I> = {}

export type BaseInstanceMethodsPrivate<I> = {}

export type BaseInstanceFields = BaseInstanceFieldsPublic & BaseInstanceFieldsPrivate
export type BaseInstanceMethods<I> = BaseInstanceMethodsPublic<I> & BaseInstanceMethodsPrivate<I>
export type BaseInstance<I> = BaseInstanceFields & BaseInstanceMethods<I>

export type BaseClassFieldsPublic = {}

export type BaseClassFieldsPrivate = {
	__index: TableType.Map<string, any>,
	_instancesCreated: number,
}

export type BaseClassMethodsPublic<O> = {
	new: (...any) -> O,
	getInstanceCount: () -> number,
}

export type BaseClassMethodsPrivate<O> = {
	_incrementInstanceCount: () -> (),
}

export type BaseClassFields = BaseClassFieldsPublic & BaseClassFieldsPrivate
export type BaseClassMethods<O> = BaseClassMethodsPublic<O> & BaseClassMethodsPrivate<O>
export type BaseClass<O> = BaseClassFields & BaseClassMethods<O>

return nil
