local QBCore = exports["qb-core"]:GetCoreObject()

Shared = {} or Shared
Shared.FishingZones = {}
Shared.currentZone = nil
Shared.canFish = false
Shared.isFishing = false
Shared.FishingZoneConfigs = {}

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

print("sh_main loaded, Shared Object: ")
print(Shared)