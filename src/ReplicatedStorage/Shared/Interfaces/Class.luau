local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local TableType = require(Shared.Types.Table)

export type ObjectPrivateInterface = {
	_serialNumber: number,
	_className: string,
}

export type ObjectPublicInterface = {}

export type ClassPrivateInterface = {
	__index: TableType.Map<string, any>,
	_instancesCreated: number,
	_instancesDestroyed: number,
	_incrementInstanceCount: () -> (),
}

export type ClassPublicInterface<Instance> = {
	new: () -> Instance,
	getInstanceCount: () -> number,
}

return nil
