--!strict
local Object = require(script.Object)
local Grandparent = require(script.Grandparent)
local Parent = require(script:FindFirstChild("Parent"))

local InheritanceChainNew = {}

function InheritanceChainNew:run()
	local o1 = Object.new()
	local g1 = Grandparent.new()
	local p1 = Parent.new()

	print(o1:toString())
	print(g1:toString())
	print(p1:toString())

	print("Object", Object.getInstanceCount())
	print("Grandparent", Grandparent.getInstanceCount())
	print("Parent", Parent.getInstanceCount())

	print(p1:getSerialId())
end

return InheritanceChainNew
