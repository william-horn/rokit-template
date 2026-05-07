--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Object = require(ReplicatedStorage.Shared.Classes.Object)
local Stack = require(ReplicatedStorage.Shared.Classes.Stack)
local Parent = require(script:FindFirstChild("Parent"))

local InheritanceChainV2 = {}

function InheritanceChainV2:run()
	local o1 = Object.new()
	local p1 = Parent.new()
	local s = Stack.new()

	s:push("hello")
	print("Stack peek: ", s:peek())

	print(o1:toString())
	print(p1:toString())

	print("Object", Object:getInstanceCount(), o1:getId())
	print("Parent", Parent:getInstanceCount(), p1:getId())
	print("Stack", Stack:getInstanceCount(), s:getId())
	print("Total Object: ", Object:getInstanceCount())
end

return InheritanceChainV2
