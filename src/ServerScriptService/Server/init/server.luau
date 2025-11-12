--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Object = require(ReplicatedStorage.Shared.Classes.Object)
local InheritanceChainNew = require(ReplicatedStorage.Tests.OOPExamples.InheritanceChainNew)

local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	-- InheritanceChainNew:run()
	Object.new()
	Object.new()
	Object.new()
	Object.new()
	Object.new()
	local o1 = Object.new()

	print(o1:getSerialId())
	print(Object.getInstanceCount())
end

return Server
