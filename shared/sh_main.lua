local QBCore = exports["qb-core"]:GetCoreObject()
Shared = {} or Shared
Shared.FishingZones = {}
Shared.currentZone = nil
Shared.canFish = false
Shared.isFishing = false

function Dump(o)
    if type(o) == 'table' then
        local s = '{ \n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. Dump(v) .. ',\n'
        end
        return s .. '} \n'
    else
        return tostring(o)
    end
end

Shared.FishingZoneConfigs = {
    [1] = {
        poly_type = "circle",
        config = {
            center = vector3(1463.58, 4298.59, 30.86),
            radius = 1.0,
            options = {
                name = "normal_fishing",
                debugPoly = true,
                debugColor = { 0, 255, 0 },
            },
        },
        inOut = function(isPointInside, point, zone)
            if isPointInside then
                exports["qb-core"]:DrawText("Shout a compliment")
                Shared.currentZone = zone
                Shared.canFish = true
            else
                exports["qb-core"]:HideText()
                Shared.currentZone = zone
                Shared.canFish = false
            end
        end,
        fish = function()
            if (QBCore.Functions.HasItem("bassfishbait")) then
                Shared.isFishing = true
                QBCore.Functions.Notify("\"You ARE a real musician\"", "primary", 2500)
                local fishingRod = Shared.DefaultFishing.generateFishingRod()
                if Shared.currentZone then
                    Shared.currentZone.animation()
                end

                TriggerServerEvent("ct-fishing:server:RemoveBait:bass")
                
                Wait(3000)
                if fishingRod then DeleteObject(fishingRod) end
                Shared.isFishing = false
            else
                QBCore.Functions.Notify("No bait, no date!", "error", 2500)
            end
        end,
        animation = function()
            RequestAnimDict("mini@tennis")
            LoadAnimDict("mini@tennis")

            while not HasAnimDictLoaded("mini@tennis") do Wait(0) end
            
            TaskPlayAnim(
                PlayerPedId(), 'mini@tennis',
                'forehand_ts_md_far',
                8.0,   -- blendInSpeed
                8.0,   -- blendOutSpeed
                -1,    -- duration
                0,     -- flag
                0,     -- playbackRate
                false, -- lockX
                false, -- lockY
                true   -- lockZ
            )
        end,
        reward = function()
        end,
    },
}
Shared.DefaultFishing = {
    inOut = function(isPointInside, point, zone)
        print("isPointInside2", isPointInside)
        print("point2", point)
        print("zone2", zone)
        if isPointInside then
            exports["qb-core"]:DrawText("Fish!")
            Shared.currentZone = zone
            Shared.canFish = true
        else
            exports["qb-core"]:HideText()
            Shared.currentZone = nil
            Shared.canFish = false
        end
    end,
    fish = function()
        QBCore.Functions.Notify("Okay we fishing..", "primary", 2500)
    end,
    generateFishingRod = function()
        local ped = PlayerPedId()
        local fishingRodHash = "prop_microphone_02"

        if not IsModelValid(fishingRodHash) then return end
        if not HasModelLoaded(fishingRodHash) then
            RequestModel(fishingRodHash)
        end
        
        while not HasModelLoaded do
            Wait(0)
        end
        
        local pedCoords = GetEntityCoords(ped)
        local fishingRod = CreateObject(
            fishingRodHash,
            pedCoords.x, pedCoords.y, pedCoords.z,
            true,   -- isNetworked
            false,  -- netMissionEntity
            false   -- doorFlag
        )

        local handId = GetPedBoneIndex(ped, 0xDEAD)

        AttachEntityToEntity(
            fishingRod, ped, handId,
            0.10, 0.03, 0.0, -- position
            0.0, 70.0, 80.0, -- rotation
            false,           -- doesn't matter
            false,           -- soft pinning
            false,           -- collision
            true,            -- isPed
            2,               -- rotationOrder
            true             -- syncRotation
        )
        SetModelAsNoLongerNeeded(fishingRodHash)
        return fishingRod
    end
}
