--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventSignalTest = require(ReplicatedStorage.Tests.Misc.EventSignalTest)
-- local InheritanceChainV2 = require(ReplicatedStorage.Tests.OOPExamples.InheritanceChainV2)

local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	EventSignalTest:run()
end

return Server
