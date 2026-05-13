--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventSignal = require(ReplicatedStorage.Shared.Classes.EventSignal)
local Object = require(ReplicatedStorage.Shared.Classes.Object)
local StateValidator = require(ReplicatedStorage.Shared.Classes.StateValidator)
local ValidationReport = require(ReplicatedStorage.Shared.Classes.ValidationReport)
local ValidationResult = require(ReplicatedStorage.Shared.Classes.ValidationResult)
local Parent = require(ReplicatedStorage.Tests.Misc:FindFirstChild("Parent"))

local Server = {}

--[[
Run all server start up processes
]]
function Server:run() end

return Server
