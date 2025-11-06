--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Object = require(ReplicatedStorage.Shared.Packages.Object)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Server = {}

--[[
Run all server start up processes
]]
function Server:run()
	local t1 = coroutine.running()
	local t2

	local c = coroutine.create(function(...)
		print("coro: ", ...)
		t2 = coroutine.running()
		local y = coroutine.yield("returned")
	end)
	local b, r = coroutine.resume(c, 1, 2, 3)
	print("resume args: ", b, r)
	print(coroutine.resume(c))
	print(coroutine.resume(c))
	print(coroutine.status(c))

	-- local p = Signal.new({
	-- 	dispatchLimit = 5,
	-- })

	-- p:connect(f, { timeout = 5 })
end

return Server
