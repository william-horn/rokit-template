--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventSignal = require(ReplicatedStorage.Shared.Classes.EventSignal)

local sig = EventSignal.new()
sig:connect(function(event: boolean, arg1, arg2) end)

--[[
    local parentSig = EventSignal.new({
        dispatchLimit = 3,
        dispatchInterval = 1

        throttleLimit = 10,
        throttleDuration = 10,
        throttleResetInterval = 20,

        queueThrottledDispatches = false
    })
    local sig = EventSignal.new(parentSig)

    local c1 = sig:connect(function(event, arg1)
        ...
    end, { priority = 1 })

    sig:dispatch(arg1)

    sig:dispatchQuery({ connection = c1 })
    sig:dispatchQuery({ priority = 1 })

    sig:disconnectQuery({ connection = c1 })
    sig:disconnectQuery({ priority = 1 })

    parentSig:fire()
    parentSig:fireOnly()
]]
