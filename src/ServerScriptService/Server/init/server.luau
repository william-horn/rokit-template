local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Connection = require(ReplicatedStorage.Shared.Packages.Connection)
local Object = require(ReplicatedStorage.Shared.Packages.Object)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Server = {}

--[[
Run all server start up methods
]]
function Server:run()
	local s = Signal.new()
	local c = Connection.new()
	print(Signal.getInstanceCount())
end

return Server
