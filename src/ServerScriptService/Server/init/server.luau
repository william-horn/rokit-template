--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventSignalTest = require(ReplicatedStorage.Tests.Misc.EventSignalTest)
local DestroyMethod = require(ReplicatedStorage.Tests.OOPExamples.DestroyMethod)
-- local InheritanceChainV2 = require(ReplicatedStorage.Tests.OOPExamples.InheritanceChainV2)

local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	DestroyMethod:run()
end

return Server
