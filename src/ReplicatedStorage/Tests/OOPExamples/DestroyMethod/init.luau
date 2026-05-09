--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Object = require(ReplicatedStorage.Shared.Classes.Object)
local Child = require(script.Child)
local Parent = require(script:FindFirstChild("Parent"))

local DestroyMethod = {}

function DestroyMethod:run()
	local o = Object.new()
	local p = Parent.new()
	local c = Child.new()

	-- print(Object:getActiveInstanceCount())
	print(Object)
	print(Child)
	c:destroy()
	print(Object)
	print(Child)
end

return DestroyMethod
