--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	ValidationReport class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ValidationResult = require(script.Parent.ValidationResult)
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
local Table = require(ReplicatedStorage.Shared.Types.Table)

export type ValidationReport = Table.ArrayOf<ValidationResult.InstancePublic>

-- Non-static types
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {
	-- public instance fields here
}

export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	-- private instance fields here
	_validationResults: ValidationReport,
}

export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	-- public instance methods here
	addResult: (self: any, validationResult: ValidationResult.InstancePublic) -> (),
	getReport: (self: any) -> ValidationReport,
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
	new: () -> InstancePublic,
	newWithInitialization: (withInitialization: boolean) -> InstancePublic,
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

local ValidationReport = newClass({} :: InstancePublic, "ValidationReport", Super) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function ValidationReport.newWithInitialization(withInitialization)
	-- If inheriting:
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, ValidationReport)
	-- local self = setmetatable(_self :: InstanceInternal, ValidationReport)
	ValidationReport:__init__(self, withInitialization)

	-- Assign private fields
	--

	-- Assign public fields
	--

	-- Return new instance
	return self
end

function ValidationReport.new(...)
	return ValidationReport.newWithInitialization(true, ...)
end

function ValidationReport.test()
	local o = ValidationReport.new()
end
--

-- Public static methods
--

-- Private static methods
--

-- Private instance methods
--

-- Public instance methods
function ValidationReport.addResult(self: InstanceInternal, validationResult)
	self._validationResults[#self._validationResults + 1] = validationResult
end

function ValidationReport.getReport(self: InstanceInternal)
	return self._validationResults
end
--

return ValidationReport :: ClassPublic
