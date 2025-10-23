--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Object class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local TableType = require(Shared.Types.Table)

local function Class(className: string, _super: TableType.Map<string, any>?)
	local super = _super or {}
	local class = setmetatable({}, super or {})

	class._className = className
	class.__index = class

	return function<Public, Private>(public: Public, private: Private)
		class.new = function() end
		return class
	end
end

export type Public = {
	keyOne: string,
	keyTwo: number,
	methodOne: () -> (),
}

export type Private = {}

export type PublicStatic = {
	staticOne: string,
	staticMethodOne: () -> (),
}

export type PrivateStatic = {}

local Object = Class("Object", {})({} :: Public, {} :: Private)
