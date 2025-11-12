--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stack = require(ReplicatedStorage.Shared.Classes.Stack)

local HaoniTower = {}

function HaoniTower:run()
	--[[
	Iterative solution to Haoni Tower problem by William J. Horn
	]]
	local function solveHaoniTower(disks: number, rods: number, fromRod: number, toRod: number)
		local _availRods = rods - 1
		local _rodStacks: { Stack.InstancePublic } = { Stack.new() }
	end

	solveHaoniTower(3, 3, 1, 2)
end

return HaoniTower
