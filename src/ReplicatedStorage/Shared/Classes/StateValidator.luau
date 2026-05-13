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
local Table = require(ReplicatedStorage.Shared.Types.Table)

export type StateValidator = (state: any, compareAgainst: any) -> ValidationReport.InstancePublic
export type StateUpdater = (prev: any) -> any

-- Non-static types
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {
	-- public instance fields here
}

export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	-- private instance fields here
	_internalState: any,
	_compareAgainst: any,
	_stateValidator: StateValidator?,
	_validationReport: ValidationReport.InstancePublic,
}

export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	-- public instance methods here
	getState: (self: any, key: string?) -> any,
	setState: (self: any, state: any) -> (),
	useValidator: (self: any, validator: StateValidator) -> (),
	validate: (self: any) -> ValidationReport.InstancePublic,
	updateState: (self: any, state: Table.Map<any, StateUpdater> | any) -> (),
	getValidationReport: (self: any) -> ValidationReport.InstancePublic,
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
	new: (state: any, compareAgainst: any) -> InstancePublic,
	newWithInitialization: (withInitialization: boolean, state: any, compareAgainst: any) -> InstancePublic,
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

-- Private static fields
--

-- Public static fields
--

-- Constructors
function StateValidator.newWithInitialization(withInitialization, state, compareAgainst)
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, StateValidator)
	StateValidator:__init__(self, withInitialization)

	-- Assign private fields
	self._internalState = state
	self._stateValidator = nil
	self._compareAgainst = compareAgainst
	self._validationReport = ValidationReport.new()
	--

	-- Assign public fields
	--

	-- Return new instance
	return self
end

function StateValidator.new(...)
	return StateValidator.newWithInitialization(true, ...)
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

	local compareAgainst = {
		x = 200,
		y = 300,
	}

	local s = StateValidator.new(value, compareAgainst)

	s:useValidator(function(state: Data, compareAgainst)
		local validationReport = s:getValidationReport()

		if state.x > compareAgainst.x then
			validationReport:addResult(ValidationResult.new("failed"))
		end

		return validationReport
	end)

	local validationReport = s:validate()

	if validationReport:hasFailed() then
	end

	validationReport:clear()
end
--

-- Public static methods
--

-- Private static methods
--

-- Private instance methods
--

-- Public instance methods
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
		return self._stateValidator(self._internalState, self._compareAgainst)
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
--

return StateValidator :: ClassPublic
