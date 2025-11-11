--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Classes = ReplicatedStorage.Shared.Classes
local Object = require(Classes.Object)
local Grandparent = require(Classes.Grandparent)
local Parent = require(Classes:FindFirstChild("Parent"))

local InheritanceChainNew = {}

function InheritanceChainNew:run()
	local o1 = Object.new()
	local g1 = Grandparent.new()
	local p1 = Parent.new()

	print(o1:toString())
	print(g1:toString())
	print(p1:toString())

	print(Object.getInstanceCount())
	print(Grandparent.getInstanceCount())
	print(Parent.getInstanceCount())
end

return InheritanceChainNew
