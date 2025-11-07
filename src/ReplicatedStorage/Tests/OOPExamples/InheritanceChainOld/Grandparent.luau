--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--[[
	@author: William J. Horn
	@written: 10/20/2025

	Grandparent class
]]
local Super = require(script.Parent.Object) -- inheriting from

local Grandparent = {}

export type Instance = typeof(setmetatable(
	{} :: {
		_serialId: number,
		_className: string,
		_super: typeof(Super),
	},
	Grandparent
))

-- Private static fields
Grandparent.__index = setmetatable(Grandparent, Super) -- inheritance
Grandparent._instancesCreated = 0
--

-- Public static fields
--

-- Constructors
function Grandparent.new(): Instance
	local self = setmetatable(Super.new() :: any, Grandparent) :: Instance

	-- Assign private fields
	self._serialId = Grandparent.getInstanceCount()
	self._className = "Grandparent"
	self._super = Super
	--

	-- Assign public fields
	--

	Grandparent._incrementInstanceCount()

	-- Return new instance
	return self
end
--

-- Public static methods
function Grandparent.getInstanceCount()
	return Grandparent._instancesCreated
end
--

-- Private static methods
function Grandparent._incrementInstanceCount()
	Grandparent._instancesCreated += 1
end
--

-- Private instance methods
--

-- Public instance methods
function Grandparent:objectMethod()
	return self._super.objectMethod(self) == 100
end

function Grandparent:grandparentMethod()
	return "grandparent method"
end
--

return Grandparent
