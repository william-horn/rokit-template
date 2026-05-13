--!strict
--[[
	@author William J. Horn (ScriptGuider@ROBLOX.com)
	@written 5/12/2026

	If you have any questions, email williamjosephhorn@gmail.com
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)

--[[
	Merges table `withTable` into table `originalTable`. Returns the
	original table as type `withTable & originalTable`

	@param originalTable <<b>table</b>> The original table that is being updated
	@param withTable <<b>table</b>> The table who's entries are merged into `originalTable`

	@return `originalTable` <<b>withTable & originalTable</b>>
]]
local function mergeTables<A, B>(originalTable: A & Table.Map<any, any>, withTable: B & Table.Map<any, any>)
	local t = originalTable :: Table.Map<any, any>

	for key, value in next, withTable do
		t[key] = value
	end

	return (t :: any) :: B & A
end

return mergeTables
