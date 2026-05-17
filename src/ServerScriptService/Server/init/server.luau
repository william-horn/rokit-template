--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventSignal = require(ReplicatedStorage.Shared.Classes.EventSignal)
local Object = require(ReplicatedStorage.Shared.Classes.Object)
local SignalConnection = require(ReplicatedStorage.Shared.Classes.SignalConnection)
local ValidationReport = require(ReplicatedStorage.Shared.Classes.ValidationReport)

local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	EventSignal.test()
end

return Server
