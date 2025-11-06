--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InheritanceChain = require(ReplicatedStorage.Tests.OOPExamples.InheritanceChain)
local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	InheritanceChain:run()

	-- local p = Signal.new({
	-- 	dispatchLimit = 5,
	-- })

	-- p:connect(f, { timeout = 5 })
end

return Server
