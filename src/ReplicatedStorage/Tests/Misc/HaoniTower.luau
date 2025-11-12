--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stack = require(ReplicatedStorage.Shared.Classes.Stack)
local Table = require(ReplicatedStorage.Shared.Types.Table)

local HaoniTower = {}

function HaoniTower:run()
	--[[
	Iterative solution to Haoni Tower problem by William J. Horn
	]]
	local function solveHaoniTower(disks: number, rods: number, fromRod: number, toRod: number)
		local availRods = rods - 1
		local rodStacks: Table.ArrayOf<Stack.InstancePublic> = {}

		for i = 1, rods do
			rodStacks[i] = Stack.new()
		end

		for i = disks, 1, -1 do
			rodStacks[fromRod]:push(i)
		end

		while true do
			if availRods > 0 then
				availRods -= 1
			end
		end
	end

	solveHaoniTower(3, 3, 1, 2)
end

return HaoniTower
