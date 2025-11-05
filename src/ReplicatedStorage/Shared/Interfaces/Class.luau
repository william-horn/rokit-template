local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local TableType = require(Shared.Types.Table)

export type ObjectPrivateInterface<O> = {
	_serialNumber: number,
	_className: string,
}

export type ObjectPublicInterface<O> = {}

export type ClassPrivateInterface<O> = {
	__index: TableType.Map<string, any>,
	_instancesCreated: number,
	_instancesDestroyed: number,
	_incrementInstanceCount: () -> (),
}

export type ClassPublicInterface<O> = {
	new: (...any) -> O,
	getInstanceCount: () -> number,
}

return nil
