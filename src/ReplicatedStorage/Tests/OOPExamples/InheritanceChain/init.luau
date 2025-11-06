--!strict
local Grandparent = require(script.Grandparent)
local Object = require(script.Object)
local Parent = require(script:FindFirstChild("Parent"))

local InheritanceChain = {}

function InheritanceChain:run()
	local o1 = Object.new()
	local g1 = Grandparent.new()
	local p1 = Parent.new()

	print(o1:toString())
	print(g1:toString())
	print(p1:toString())

	print(Object.getInstanceCount())
	print(Grandparent.getInstanceCount())
	print(Parent.getInstanceCount())

	print(g1:objectMethod())
end

return InheritanceChain