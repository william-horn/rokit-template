local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Object = require(ReplicatedStorage.Shared.Packages.Object)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	local s = Signal.new()
	print(s:toString())
end

return Server
