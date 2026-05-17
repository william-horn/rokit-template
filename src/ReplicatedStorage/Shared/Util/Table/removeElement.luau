--!strict
--[[
	@author William J. Horn (ScriptGuider@ROBLOX.com)
	@written 5/12/2026

	If you have any questions, email williamjosephhorn@gmail.com
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)

--[[
	Removes a given element from an array.
]]
local function removeElement(array: Table.ArrayOf<any>, element: any): boolean
	for index = 1, #array do
		if array[index] == element then
			table.remove(array, index)
			return true
		end
	end

	return false
end

return removeElement
