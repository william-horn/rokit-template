--!strict
--[[
	@author William J. Horn (ScriptGuider@ROBLOX.com)
	@written 5/12/2026

	StateValidator
	
	If you have any questions, email williamjosephhorn@gmail.com
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ValidationReport = require(script.Parent.ValidationReport)
local ValidationResult = require(script.Parent.ValidationResult)
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
local Table = require(ReplicatedStorage.Shared.Types.Table)

export type StateValidationHandler = (
	validationReport: ValidationReport.InstancePublic,
	state: any,
	compareAgainst: any
) -> ValidationReport.InstancePublic
export type StateUpdater = (prev: any) -> any

--[[
	PUBLIC Fields - Instance
]]
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {}

--[[
	PRIVATE Fields - Instance
]]
export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	_internalState: any,
	_compareAgainst: any,
	_stateValidator: StateValidationHandler?,
	_validationReport: ValidationReport.InstancePublic,
}

--[[
	PUBLIC Methods - Instance
]]
export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	--[[
		Gets the current internal state of the `StateValidator` instance.
		This is the exact value that was passed through the class 
		constructor.

		If the internal state is a `table`, you can pass an optional
	 	key indexer as an argument which will return `table[key]`

		<i>Inherited from:</i> [<b>StateValidator</b>](#)

		<b>Example:</b>

		```luau
		local state = "some value"
		local validator = StateValidator.new(state)
		print(validator:getState()) --> "some value"
		```

		With state as a `table` and using an indexer argument:

		```luau
		local state = {
			keyA = "a",
			keyB = "b"
		}

		local validator = StateValidator.new(state)
		print(validator:getState("keyA")) --> "a"
		```

		@param key <<b>any?</b>> The indexer key if `state` is a table.
		
		@return `state` <<b>any</b>> The internal state of the `StateValidator` instance.
	]]
	getState: (self: any, key: any?) -> any,

	--[[
		Set the internal state of the `StateValidator` instance. The state
		can be any value.

		<i>Inherited from:</i> [<b>StateValidator</b>](#)

		<b>Example:</b>

		```luau
		local validator = StateValidator.new(100)
		print(validator:getState()) --> 100
		validator:setState(200)
		print(validator:getState()) --> 200
		```

		@param state <<b>any</b>> The new state that the internal state is set to
	]]
	setState: (self: any, state: any) -> (),

	--[[
		Assigns the current global validation function that is used when
		calling `validate()`. 

		<i>Inherited from:</i> [<b>StateValidator</b>](#)

		<b>Example:</b>

		```luau
		local validator = StateValidator.new(100)
		validator:useValidator(function())
		```
	]]
	useValidator: (self: any, validator: StateValidationHandler) -> (),
	validate: (self: any) -> ValidationReport.InstancePublic,
	updateState: (self: any, state: Table.Map<any, StateUpdater> | any) -> (),
	getValidationReport: (self: any) -> ValidationReport.InstancePublic,
}

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
		Creates a new `StateValidator` instance with a given `state`, and a
		a `compareAgainst` value to compare the state against during validation.

		If comparison is not needed outside of the validator callback, then
		`compareAgainst` can be left as `nil` or undefined.

		<b>Example:</b>

		```luau
		local state = {
			x = 10,
			y = "foo"
		}

		local compareAgainst = {
			conditionA = 5,
			conditionB = "bar"
		}

		local o = StateValidator.new(state, compareAgainst)
		```

		@return `StateValidator` <<b>StateValidator Instance</b>>
	]]
	new: (state: any, compareAgainst: any) -> InstancePublic,

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
		local o = StateValidator.newWithInitialization(true)
		print(o:getClassName()) --> "StateValidator"
		print(StateValidator:getActiveInstanceCount()) --> 1

		o = StateValidator.newWithInitialization(false)
		print(o:getClassName()) --> nil
		print(StateValidator:getActiveInstanceCount()) --> 1
		```

		@return `StateValidator` <<b>StateValidator Instance</b>>
	]]
	newWithInitialization: (withInitialization: boolean, state: any, compareAgainst: any) -> InstancePublic,

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
local StateValidator = newClass({} :: InstancePublic, "StateValidator", Super) :: ClassInternal

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
function StateValidator.newWithInitialization(withInitialization, state, compareAgainst)
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, StateValidator)
	StateValidator:__init__(self, withInitialization)

	--[[
		PRIVATE Fields - Instance
	]]
	self._internalState = state
	self._stateValidator = nil
	self._compareAgainst = compareAgainst
	self._validationReport = ValidationReport.new()

	--[[
		PUBLIC Fields - Instance
	]]

	-- Return new instance
	return self
end

function StateValidator.new(...)
	return StateValidator.newWithInitialization(true, ...)
end

--[[
	PUBLIC Static Methods - Class
]]

--[[
	PRIVATE Static Methods - Class
]]

--[[
	PRIVATE Methods - Instance
]]

--[[
	PUBLIC Methods - Instance
]]
function StateValidator.getState(self: InstanceInternal, key)
	return if key then self._internalState[key] else self._internalState
end

function StateValidator.setState(self: InstanceInternal, state)
	self._internalState = state
end

function StateValidator.useValidator(self: InstanceInternal, validator)
	self._stateValidator = validator
end

function StateValidator.validate(self: InstanceInternal)
	if self._stateValidator ~= nil then
		return self._stateValidator(self._validationReport, self._internalState, self._compareAgainst)
	end
	return ValidationReport.new():destroy()
end

function StateValidator.updateState(self: InstanceInternal, state: any)
	if typeof(state) == "table" and typeof(self._internalState) == "table" then
		for key, stateUpdater in next, state :: Table.Map<any, StateUpdater> do
			self._internalState[key] = stateUpdater(self._internalState[key])
		end
	else
		self:setState(state)
	end
end

function StateValidator.getValidationReport(self: InstanceInternal)
	return self._validationReport
end

--[[
	TEST CODE:

	A class-level function which contains optional or temporary 
	test-code, ideally for testing class features.
]]
function StateValidator.test()
	type Data = {
		x: number,
		y: number,
	}

	local value: Data = {
		x = 100,
		y = 200,
	}

	local compareAgainst = {
		x = 200,
		y = 300,
	}

	local s = StateValidator.new(value, compareAgainst)

	s:useValidator(function(validationReport, state: Data, compareAgainst)
		if state.x > compareAgainst.x then
			validationReport:addResult(ValidationResult.new({ result = "failed" }))
		end

		return validationReport
	end)

	local validationReport = s:validate()

	if validationReport:hasFailed() then
	end

	validationReport:clear()
end

return StateValidator :: ClassPublic
