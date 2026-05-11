--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	StateValidator class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ValidationReport = require(script.Parent.ValidationReport)
local ValidationResult = require(script.Parent.ValidationResult)
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)

export type StateValidator = (state: any) -> ValidationReport.InstancePublic

-- Non-static types
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {
	-- public instance fields here
}

export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	-- private instance fields here
	_internalState: any,
	_stateValidator: StateValidator,
}

export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	-- public instance methods here
	getState: (self: any) -> any,
	setState: (self: any, state: any) -> (),
	useValidator: (self: any, validator: StateValidator) -> (),
	validate: (self: any) -> ValidationReport.InstancePublic,
}

export type LocalInstanceMethodsPrivate<CI, II, SCI> = {
	-- private instance methods
}

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

-- Static types
export type ClassFieldsPublic = {
	-- public static fields here
}

export type ClassFieldsPrivate = {
	-- private static fields here
}

export type ClassMethodsPublic = {
	-- public static methods here
	new: (state: any) -> InstancePublic,
	newWithInitialization: (withInitialization: boolean, state: any) -> InstancePublic,
	test: () -> (),
}

export type ClassMethodsPrivate = {
	-- private static methods here
}

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

local StateValidator = newClass({} :: InstancePublic, "StateValidator", Super) :: ClassInternal

local defaultValidator: StateValidator = function(state)
	return ValidationReport.new()
end

-- Private static fields
--

-- Public static fields
--

-- Constructors
function StateValidator.newWithInitialization<_, State>(withInitialization, state)
	-- If inheriting:
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, StateValidator)
	-- local self = setmetatable(_self :: InstanceInternal, StateValidator)
	StateValidator:__init__(self, withInitialization)

	-- Assign private fields
	self._internalState = state
	self._stateValidator = defaultValidator
	--

	-- Assign public fields
	--

	-- Return new instance
	return self
end

function StateValidator.new(state)
	return StateValidator.newWithInitialization(true, state)
end

function StateValidator.test()
	type Data = {
		x: number,
		y: number,
	}

	local value: Data = {
		x = 100,
		y = 200,
	}

	local o = StateValidator.new(value)

	o:useValidator(function(state: Data)
		local validationReport = ValidationReport.new():destroy()

		if state.x > 99 then
			validationReport:addResult(ValidationResult.new("failed", "too big"))
		end

		if state.y < 300 then
			validationReport:addResult(ValidationResult.new("failed", "too small"))
		end

		if state.y == 200 then
			validationReport:addResult(ValidationResult.new("passed", "just right!"))
		end

		return validationReport
	end)

	local v = o:validate()

	if v:hasPassed() then
		print("IT PASSED")
		print(v:getResults())
	else
		print("IT FAILED")
		print(v:getResults())
	end
end
--

-- Public static methods
--

-- Private static methods
--

-- Private instance methods
--

-- Public instance methods
function StateValidator.getState(self: InstanceInternal)
	return self._internalState
end

function StateValidator.setState(self: InstanceInternal, state)
	self._internalState = state
end

function StateValidator.useValidator(self: InstanceInternal, validator)
	self._stateValidator = validator
end

function StateValidator.validate(self: InstanceInternal)
	return self._stateValidator(self._internalState)
end
--

return StateValidator :: ClassPublic
