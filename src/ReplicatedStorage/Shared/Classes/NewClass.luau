--!strict
--[[
	@author William J. Horn (ScriptGuider@ROBLOX.com)
	@written 5/12/2026

	NewClass
	
	If you have any questions, email williamjosephhorn@gmail.com
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)

--[[
	PUBLIC Fields - Instance
]]
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {}

--[[
	PRIVATE Fields - Instance
]]
export type LocalInstanceFieldsPrivate<CI, II, SCI> = {}

--[[
	PUBLIC Methods - Instance
]]
export type LocalInstanceMethodsPublic<CP, IP, SCP> = {}

--[[
	PRIVATE Methods - Instance
]]
export type LocalInstanceMethodsPrivate<CI, II, SCI> = {}

--[[
	Type inheritance intersections between local instance-interface
	definitions and superclass-instance definitions.
]]
export type InstanceFieldsPublic<CP, IP, SCP> =
	LocalInstanceFieldsPublic<CP, IP, SCP>
	& Super.InstanceFieldsPublic<CP, IP, SCP>
export type InstanceMethodsPublic<CP, IP, SCP> =
	LocalInstanceMethodsPublic<CP, IP, SCP>
	& Super.InstanceMethodsPublic<CP, IP, SCP>
export type InstanceFieldsPrivate<CI, II, SCI> =
	LocalInstanceFieldsPrivate<CI, II, SCI>
	& Super.InstanceFieldsPrivate<CI, II, SCI>
export type InstanceMethodsPrivate<CI, II, SCI> =
	LocalInstanceMethodsPrivate<CI, II, SCI>
	& Super.InstanceMethodsPrivate<CI, II, SCI>
export type InstancePublic =
	InstanceFieldsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
	& InstanceMethodsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
export type InstanceInternal =
	InstancePublic
	& InstanceFieldsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>
	& InstanceMethodsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>

--[[
	PUBLIC Static Fields - Class
]]
export type ClassFieldsPublic = {}

--[[
	PRIVATE Static Fields - Class
]]
export type ClassFieldsPrivate = {}

--[[
	PUBLIC Static Methods - Class
]]
export type ClassMethodsPublic = {
	--[[
		Create a new initialized instance of this class. This
		constructor is exactly identical to calling `newWithInitialization(true)`

		<b>Example:</b>

		```luau
		-- this
		local o = NewClass.new()
		-- is the same as
		o = NewClass.newWithInitialization(true)
		```

		@return `NewClass` <<b>NewClass Instance</b>>
	]]
	new: () -> InstancePublic,

	--[[
		Create a new instance of this class with the option of 
		being initialized. If the instance is not initialized, it
		must be initialized manually to define the missing class
		fields: `_class`, `_className`, `_super`.

		With no initialization, the object will also not be stored
		internally, and thus will not add to the `_activeInstanceCount`
		field internally.

		<b>Example:</b>

		```luau
		local o = NewClass.newWithInitialization(true)
		print(o:getClassName()) --> "NewClass"
		print(NewClass:getActiveInstanceCount()) --> 1

		o = NewClass.newWithInitialization(false)
		print(o:getClassName()) --> nil
		print(NewClass:getActiveInstanceCount()) --> 1
		```

		@return `NewClass` <<b>NewClass Instance</b>>
	]]
	newWithInitialization: (withInitialization: boolean) -> InstancePublic,

	--[[
		A test method to write temporary test code for the class.
	]]
	test: () -> (),
}

--[[
	PRIVATE Static Methods - Class
]]
export type ClassMethodsPrivate = {}

--[[
	Type intersections for combining all static definitions into
	a single class interface. One for internal use, and one for
	exported external use.
]]
export type ClassPublic =
	ClassFieldsPublic
	& ClassMethodsPublic
	& newClass.ClassTemplatePublic<InstancePublic, Super.ClassPublic>

export type ClassInternal =
	ClassPublic
	& ClassMethodsPrivate
	& ClassFieldsPrivate
	& InstanceMethodsPrivate<ClassInternal, InstanceInternal, Super.ClassInternal>
	& InstanceMethodsPublic<ClassPublic, InstancePublic, Super.ClassPublic>
	& newClass.ClassTemplatePrivate<InstancePublic, Super.ClassPublic>

--[[
	Class definition
]]
local NewClass = newClass({} :: InstancePublic, "NewClass", Super) :: ClassInternal

--[[
	PUBLIC Static Fields - Class

	Public fields that are assigned directly on the class object, such
	as `NewClass.foo = "bar"` for example.
]]

--[[
	PRIVATE Static Fields - Class

	Private fields that are assigned directly on the class object, such
	as `NewClass._foo = "bar"` for example. All private fields are prefaced
	with an underscore `_` as convention.
]]

--[[
	CONSTRUCTORS

	Class constructors - responsible for creating class instances
]]
function NewClass.newWithInitialization(withInitialization)
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, NewClass)
	NewClass:__init__(self, withInitialization)

	--[[
		PRIVATE Fields - Instance
	]]

	--[[
		PUBLIC Fields - Instance
	]]

	-- Return new instance
	return self
end

function NewClass.new(...)
	return NewClass.newWithInitialization(true, ...)
end

--[[
	PUBLIC Static Methods - Class
]]

--[[
	PRIVATE Static Methods - Class
]]

--[[
	PUBLIC Methods - Instance
]]

--[[
	PRIVATE Methods - Instance
]]

--[[
	TEST CODE:

	A class-level function which contains optional or temporary 
	test-code, ideally for testing class features.
]]
function NewClass.test() end

-- Export the final class with a public interface
return NewClass :: ClassPublic
