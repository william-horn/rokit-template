--!strict
--[[
	@author: William J. Horn
	@written: 10/20/2025

	ValidationResult class
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Super = require(ReplicatedStorage.Shared.Classes.Object)
local newClass = require(ReplicatedStorage.Shared.Classes.ClassTemplate)
local mergeTables = require(ReplicatedStorage.Shared.Util.Table.mergeTables)

export type ResultType = "passed" | "failed" | "warning" | "error"
export type ValidationResultData<T = never> = {
	result: ResultType | T,
	message: string | T,
	handler: (self: { result: string, message: string }) -> ()?,
}

-- Non-static types
export type LocalInstanceFieldsPublic<CP, IP, SCP> = {
	-- public instance fields here
}

export type LocalInstanceFieldsPrivate<CI, II, SCI> = {
	-- private instance fields here
	_hasPassed: boolean,
	_validationResultData: ValidationResultData,
}

export type LocalInstanceMethodsPublic<CP, IP, SCP> = {
	-- public instance methods here
	getResult: (self: any) -> ResultType,
	getMessage: (self: any) -> string,
	hasPassed: (self: any) -> boolean,
	hasFailed: (self: any) -> boolean,
	hasWarning: (self: any) -> boolean,
	hasError: (self: any) -> boolean,
	runHandler: (self: any) -> (),
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
	-- new: (result: ResultType, message: string?) -> InstancePublic,
	new: (validationResultData: ValidationResultData<nil>?) -> InstancePublic,
	newWithInitialization: (
		withInitialization: boolean,
		validationResultData: ValidationResultData<nil>?
	) -> InstancePublic,
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

local ValidationResult = newClass({} :: InstancePublic, "ValidationResult", Super) :: ClassInternal

-- Private static fields
--

-- Public static fields
--

-- Constructors
function ValidationResult.newWithInitialization(withInitialization, validationResultData)
	-- If inheriting:
	local self = setmetatable((Super.new() :: any) :: InstanceInternal, ValidationResult)
	-- local self = setmetatable(_self :: InstanceInternal, ValidationResult)
	ValidationResult:__init__(self, withInitialization)

	-- Assign private fields
	self._validationResultData = {
		result = "passed",
		message = "No description",
	}

	if validationResultData ~= nil then
		mergeTables(self._validationResultData, validationResultData)
	end

	-- Assign public fields
	--

	-- Return new instance
	return self
end

function ValidationResult.new(...)
	return ValidationResult.newWithInitialization(true, ...)
end

-- Public static methods
--

-- Private static methods
--

-- Private instance methods
--

-- Public instance methods
function ValidationResult.getResult(self: InstanceInternal)
	return self._validationResultData.result
end

function ValidationResult.getMessage(self: InstanceInternal)
	return self._validationResultData.message
end

function ValidationResult.hasPassed(self: InstanceInternal)
	return self._hasPassed
end

function ValidationResult.hasFailed(self: InstanceInternal)
	return self._hasPassed == false
end

function ValidationResult.runHandler(self: InstanceInternal)
	if self._validationResultData.handler ~= nil then
		self._validationResultData.handler({
			result = self:getResult(),
			message = self:getMessage(),
		})
	end
end

function ValidationResult.test()
	local o = ValidationResult.new({
		result = "warning",
		message = "",
		handler = function(self) end,
	})
end

return ValidationResult :: ClassPublic
