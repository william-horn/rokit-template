--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Object = require(ReplicatedStorage.Shared.Packages.Object)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	local o = Object.new()
	local s = Signal.new()

	Object.new()
	Object.new()
	Object.new()

	Signal.new()
	print(Signal.getInstanceCount())
	print(Object.getInstanceCount())
end

return Server
