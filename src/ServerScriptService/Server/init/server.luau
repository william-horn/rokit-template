--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InheritanceChainV2 = require(ReplicatedStorage.Tests.OOPExamples.InheritanceChainV2)

local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	InheritanceChainV2:run()
end

return Server
