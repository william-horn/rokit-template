--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventSignal = require(ReplicatedStorage.Shared.Classes.EventSignal)
local Object = require(ReplicatedStorage.Shared.Classes.Object)
local Parent = require(ReplicatedStorage.Shared.Classes:FindFirstChild("Parent"))
local StateValidator = require(ReplicatedStorage.Shared.Classes.StateValidator)
local ValidationReport = require(ReplicatedStorage.Shared.Classes.ValidationReport)
local ValidationResult = require(ReplicatedStorage.Shared.Classes.ValidationResult)

local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	EventSignal.test()
end

-- Super class
local Super = {}
Super.__index = Super

type SuperData = {
	--[[
		superclass method
	]]
	superName: string,
}

export type Super = typeof(setmetatable({} :: SuperData, Super))

--[[
	superclass method
]]
function Super:getSuperName(): string
	return self.superName
end

function Super.new(): Super
	local o = setmetatable({} :: SuperData, Super)
	o.superName = "super"
	return o
end

-- Subclass
local Class = setmetatable({}, Super)
Class.__index = Class

type ClassData = {
	--[[
		class method
	]]
	className: string,
} & SuperData

export type Class = typeof(setmetatable({} :: ClassData, Class))

--[[
	class method
]]
function Class:getClassName(): string
	return self.className
end

function Class.new(): ClassData
	local o = setmetatable({} :: ClassData, Class)
	o.superName = "super"
	o.className = "class"
	return o
end

return Server
