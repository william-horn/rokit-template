--!strict
local Class = {}
Class.__index = Class

function Class:test()
	return "testing"
end

function Class.new()
	local self = setmetatable({}, Class)

	return self
end

local SubClass = {}
SubClass.__index = setmetatable(SubClass, Class)

function SubClass:thing()
	return 5
end

function SubClass.new()
	local class = Class.new()
	local self = setmetatable(class, SubClass)

	return self
end

return Class
