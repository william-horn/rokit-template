--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Object = require(ReplicatedStorage.Shared.Classes.Object)
local HaoniTower = require(ReplicatedStorage.Tests.Misc.HaoniTower)
local InheritanceChainNew = require(ReplicatedStorage.Tests.OOPExamples.InheritanceChainNew)

local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	HaoniTower:run()
end

return Server
