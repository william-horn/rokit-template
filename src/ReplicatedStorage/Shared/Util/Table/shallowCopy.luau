--!strict
--[[
	@author William J. Horn (ScriptGuider@ROBLOX.com)
	@written 5/12/2026
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Table = require(ReplicatedStorage.Shared.Types.Table)

--[[
	note:

    `T & Table.Map<any, any>` ensures that `t` must have a valid intersection
    with a table, meaning the type must be a table. This workaround is due to 
    the fact that we can't create type-safe parameters while using generics, 
    since Luau unfortunately does not support type extensions yet.
]]

--[[
	Creates a shallow copy of table `t` and returns the new table, 
	retaining the original table's type.

	@param t <<b>table</b>> The table to copy
	
	@return `copy` <<b>table</b>> A new table with the same type as `t`
]]
local function shallowCopy<T>(t: T & Table.Map<any, any>): T
	local copy = {}

	for k, v in t :: Table.Map<any, any> do
		copy[k] = v
	end

	return (copy :: any) :: T
end

return shallowCopy
