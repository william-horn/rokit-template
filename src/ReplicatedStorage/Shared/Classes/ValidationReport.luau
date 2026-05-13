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
local mergeTables = require(ReplicatedStorage.Shared.Util.Table.mergeTables)

export type ValidationResultList = Table.ArrayOf<ValidationResult.InstancePublic>

-- Non-static types
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {
	-- public instance fields here
}

export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	-- private instance fields here
	_validationResults: ValidationResultList,
	_hasPassed: boolean,
}

export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	-- public instance methods here
	addResult: (self: any, validationResult: ValidationResult.InstancePublic) -> (),
	peekResults: (self: any) -> ValidationResultList,
	collapseResults: (self: any) -> ValidationResultList,
	clear: (self: any) -> (),
	hasPassed: (self: any) -> boolean,
	hasFailed: (self: any) -> boolean,
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
	self._hasPassed = true
	self._validationResults = {}
	--

	-- Assign public fields
	--

	-- Return new instance
	return self
end

function ValidationReport.new(...)
	return ValidationReport.newWithInitialization(true, ...)
end

-- Public static methods
--

-- Private static methods
--

-- Private instance methods
--

-- Public instance methods
function ValidationReport.addResult(self: InstanceInternal, validationResult)
	self._validationResults[#self._validationResults + 1] = validationResult
	if self._hasPassed and validationResult:hasFailed() then
		self._hasPassed = false
	end
end

function ValidationReport.peekResults(self: InstanceInternal)
	return self._validationResults
end

function ValidationReport.collapseResults(self: InstanceInternal)
	local validationResults = mergeTables({}, self:peekResults())
	self:clear()
	return validationResults
end

function ValidationReport.clear(self: InstanceInternal)
	for index = 1, #self._validationResults do
		self._validationResults[index]:destroy()
		self._validationResults[index] = nil
	end
	self._hasPassed = true
end

function ValidationReport.hasPassed(self: InstanceInternal)
	return self._hasPassed
end

function ValidationReport.hasFailed(self: InstanceInternal)
	return self._hasPassed == false
end

function ValidationReport.destroy(self: InstanceInternal)
	self._super.destroy(self)
	self:clear()
	return self
end

function ValidationReport.test()
	local o = ValidationReport.new()
end

return ValidationReport :: ClassPublic
