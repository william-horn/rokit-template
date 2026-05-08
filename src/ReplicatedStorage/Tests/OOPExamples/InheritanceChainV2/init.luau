--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Grandparent = require(script.Grandparent)
local Object = require(ReplicatedStorage.Shared.Classes.Object)
local Stack = require(ReplicatedStorage.Shared.Classes.Stack)
local Parent = require(script:FindFirstChild("Parent"))

local InheritanceChainV2 = {}

function InheritanceChainV2:run()
	local o1 = Object.new()
	local p1 = Parent.new()
	local s = Stack.new()
	local g1 = Grandparent.new()

	-- print(p1:toString())
	-- print(o1.toString(g1))

	-- print(p1)
	-- print(Grandparent)

	print(Object:is(o1))
	print(Object:is(p1))

	print(Parent:is(p1))
end

return InheritanceChainV2
