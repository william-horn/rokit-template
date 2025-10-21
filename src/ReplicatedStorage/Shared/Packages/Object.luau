--!strict
local Class = {}
Class.__index = Class

type Class = typeof(setmetatable({}, {}))

local g: Class = setmetatable({}, { __index = {} })

local q = { x = 2 }
type tq = typeof(q)
type s<T> = typeof(setmetatable({} :: T, { __index = {} :: T }))

local h: s = setmetatable({ x = 2 }, { __index = {} })

function Class.new(className: string, _super: Class?)
	local super = (_super or Class) :: Class

	local class = setmetatable({
		super = setmetatable({}, {
			__index = function(self, k)
				if super[k] then
					return function(...)
						return getmetatable(super)[k](self, ...)
					end
				end
			end,
		}),
		_className = className,
	}, super)

	return function(constructors: { [string]: () -> () })
		for k, v in next, constructors do
			class[k] = v
		end
		return class
	end
end

function Class:getName(): string
	return self.className
end

-- local Dog = Class.new("Dog")({
-- 	new = function(self)
-- 		self.super.new()
-- 	end,
-- 	_constructor = function(self)
-- 		self.constructor1()
-- 	end,
-- })

-- function Dog:bark()
-- 	self.super:getName()
-- 	self.print("Bark")
-- end

-- Dog.new()
-- Dog.constructor2()

return Class
