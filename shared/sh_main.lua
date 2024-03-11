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

Shared.FishingZoneConfigs = {
    -- Bass Fishing
    [1] = {
        poly_type = "circle",
        config = {
            center = vector3(1463.58, 4298.59, 30.86),
            radius = 1.0,
            options = {
                name = "bass_fishing",
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

                print(Shared.currentZone)

                if Shared.currentZone then
                    Shared.currentZone.game(function()
                        if fishingRod then DeleteObject(fishingRod) end
                        Shared.isFishing = false
                        TriggerServerEvent("ct-fishing:server:RemoveBait:bass")
                    end)
                end
            else
                QBCore.Functions.Notify("No bait, no date!", "error", 2500)
            end
        end,
        game = function(cb)
            RequestAnimDict("anim@mp_player_intupperslow_clap")

            while not HasAnimDictLoaded("anim@mp_player_intupperslow_clap") do Wait(0) end

            TaskPlayAnim(
                PlayerPedId(), 'anim@mp_player_intupperslow_clap',
                'idle_a',
                8.0,   -- blendInSpeed
                8.0,   -- blendOutSpeed
                -1,    -- duration
                1,     -- flag
                1,     -- playbackRate
                false, -- lockX
                false, -- lockY
                true   -- lockZ
            )

            Wait(math.random(2, 4) * 1000)

            exports['ps-ui']:Circle(function(success)
                if success then
                    QBCore.Functions.Notify(
                        "You hear splashing...",
                        "primary",
                        3000
                    )
                    TriggerServerEvent("ct-fishing:server:GiveReward", Shared.currentZone.reward())
                else
                    QBCore.Functions.Notify(
                        "You weren't convincing enough!",
                        "error",
                        3000
                    )
                end
            end, 3, 20) -- NumberOfCircles, MS

            ClearPedTasks(PlayerPedId())
            cb()
        end,
        reward = function()
            math.randomseed(GetClockMonth() * GetClockHours() / GetClockSeconds())
            local roll = math.random()
            local rewards = {}
            local dropRates = {
                { 40, "bassfishnote" },
                { 90, "bassfish" }
            }

            for k, item in pairs(dropRates) do
                if #rewards >= 2 then return rewards end

                local numToSucceed = 1 - (item[1] / 100)

                if roll >= numToSucceed then
                    table.insert(rewards, item[2])
                end
            end

            return rewards
        end,
    },
    -- Dork Fishing
    [2] = {
        poly_type = "circle",
        config = {
            center = vector3(-603.59, -121.29, 338.32),
            radius = 1.0,
            options = {
                name = "dork_fishing",
                debugPoly = true,
                debugColor = { 255, 0, 0 },
            },
        },
        inOut = function(isPointInside, point, zone)
            if isPointInside then
                exports["qb-core"]:DrawText("Build a pivot table?")
                Shared.currentZone = zone
                Shared.canFish = true
            else
                exports["qb-core"]:HideText()
                Shared.currentZone = zone
                Shared.canFish = false
            end
        end,
        fish = function()
            if (QBCore.Functions.HasItem("dorkfishbait")) then
                Shared.isFishing = true
                QBCore.Functions.Notify("\"Why won't my pivot table work?\"", "primary", 2500)
                local fishingRod = Shared.DefaultFishing.generateFishingRod()

                print(Shared.currentZone)

                if Shared.currentZone then
                    Shared.currentZone.game(function()
                        if fishingRod then DeleteObject(fishingRod) end
                        Shared.isFishing = false
                        TriggerServerEvent("ct-fishing:server:RemoveBait:dork")
                    end)
                end
            else
                QBCore.Functions.Notify("No bait, no date!", "error", 2500)
            end
        end,
        game = function(cb)
            RequestAnimDict("anim@mp_player_intupperslow_clap")

            while not HasAnimDictLoaded("anim@mp_player_intupperslow_clap") do Wait(0) end

            TaskPlayAnim(
                PlayerPedId(), 'anim@mp_player_intupperslow_clap',
                'idle_a',
                8.0,   -- blendInSpeed
                8.0,   -- blendOutSpeed
                -1,    -- duration
                1,     -- flag
                1,     -- playbackRate
                false, -- lockX
                false, -- lockY
                true   -- lockZ
            )

            Wait(math.random(2, 4) * 1000)

            exports['ps-ui']:Circle(function(success)
                if success then
                    QBCore.Functions.Notify(
                        "You hear something congested...",
                        "primary",
                        3000
                    )
                    TriggerServerEvent("ct-fishing:server:GiveReward", Shared.currentZone.reward())
                else
                    QBCore.Functions.Notify(
                        "You sound like a Windows user",
                        "error",
                        3000
                    )
                end
            end, 3, 20) -- NumberOfCircles, MS

            ClearPedTasks(PlayerPedId())
            cb()
        end,
        reward = function()
            math.randomseed(GetClockMonth() * GetClockHours() / GetClockSeconds())
            local roll = math.random()
            local rewards = {}
            local dropRates = {
                { 40, "dorkfishnote" },
                { 90, "dorkfish" }
            }

            for k, item in pairs(dropRates) do
                if #rewards >= 2 then return rewards end

                local numToSucceed = 1 - (item[1] / 100)

                if roll >= numToSucceed then
                    table.insert(rewards, item[2])
                end
            end

            return rewards
        end,
    },
    -- Fly Fishing
    [3] = {
        poly_type = "circle",
        config = {
            center = vector3(-603.59, -122.29, 338.32),
            radius = 1.0,
            options = {
                name = "fly_fishing",
                debugPoly = true,
                debugColor = {0, 0, 255},
            },
        },
        inOut = function(isPointInside, point, zone)
            if isPointInside then
                exports["qb-core"]:DrawText("Toss a coin")
                Shared.currentZone = zone
                Shared.canFish = true
            else
                exports["qb-core"]:HideText()
                Shared.currentZone = zone
                Shared.canFish = false
            end
        end,
        fish = function()
            if (QBCore.Functions.HasItem("flyfishbait")) then
                Shared.isFishing = true
                QBCore.Functions.Notify("You toss a coin off the building", "primary", 2500)
                local fishingRod = Shared.DefaultFishing.generateFishingRod()

                print(Shared.currentZone)

                if Shared.currentZone then
                    Shared.currentZone.game(function()
                        if fishingRod then DeleteObject(fishingRod) end
                        Shared.isFishing = false
                        TriggerServerEvent("ct-fishing:server:RemoveBait:fly")
                    end)
                end
            else
                QBCore.Functions.Notify("No bait, no date!", "error", 2500)
            end
        end,
        game = function(cb)
            RequestAnimDict("anim@mp_player_intupperslow_clap")

            while not HasAnimDictLoaded("anim@mp_player_intupperslow_clap") do Wait(0) end

            TaskPlayAnim(
                PlayerPedId(), 'anim@mp_player_intupperslow_clap',
                'idle_a',
                8.0,   -- blendInSpeed
                8.0,   -- blendOutSpeed
                -1,    -- duration
                1,     -- flag
                1,     -- playbackRate
                false, -- lockX
                false, -- lockY
                true   -- lockZ
            )

            Wait(math.random(2, 4) * 1000)

            exports['ps-ui']:Circle(function(success)
                if success then
                    QBCore.Functions.Notify(
                        "You hear splashing...",
                        "primary",
                        3000
                    )
                    TriggerServerEvent("ct-fishing:server:GiveReward", Shared.currentZone.reward())
                else
                    QBCore.Functions.Notify(
                        "You sound like a Windows user",
                        "error",
                        3000
                    )
                end
            end, 3, 20) -- NumberOfCircles, MS

            ClearPedTasks(PlayerPedId())
            cb()
        end,
        reward = function()
            math.randomseed(GetClockMonth() * GetClockHours() / GetClockSeconds())
            local roll = math.random()
            local rewards = {}
            local dropRates = {
                { 40, "flyfishnote" },
                { 90, "flyfish" }
            }

            for k, item in pairs(dropRates) do
                if #rewards >= 2 then return rewards end

                local numToSucceed = 1 - (item[1] / 100)

                if roll >= numToSucceed then
                    table.insert(rewards, item[2])
                end
            end

            return rewards
        end,
        zone_setup = function()
            
        end,
    }
}
