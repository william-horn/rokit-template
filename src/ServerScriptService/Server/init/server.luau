--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InheritanceChainNew = require(ReplicatedStorage.Tests.OOPExamples.InheritanceChainNew)

local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	InheritanceChainNew:run()
end

return Server
