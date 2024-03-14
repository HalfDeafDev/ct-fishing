local QBCore = exports["qb-core"]:GetCoreObject()

-- Bass Fishing
table.insert(Shared.FishingZoneConfigs, {
    zone_type = "circle",
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
        local year, month, day, hour, minute, second = GetUtcTime()
        math.randomseed((year * month / second) + ((minute - day) * second) + hour)
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
})

-- Dork Fishing
table.insert(Shared.FishingZoneConfigs, {
    zone_type = "circle",
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
        RequestAnimDict("mini@dartsoutro")

        while not HasAnimDictLoaded("mini@dartsoutro") do Wait(0) end

        TaskPlayAnim(
            PlayerPedId(), 'mini@dartsoutro',
            'darts_outro_01_guy2',
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
        local year, month, day, hour, minute, second = GetUtcTime()
        math.randomseed((year * month / second) + ((minute - day) * second) + hour)
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
})

-- Fly Fishing
table.insert(Shared.FishingZoneConfigs, {
    zone_type = "circle",
    config = {
        center = vector3(899.46, 36.64, 111.32),
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
            QBCore.Functions.Notify("They don't work with the poor..", "error", 2500)
        end
    end,
    game = function(cb)
        RequestAnimDict("missfam2_pier")

        while not HasAnimDictLoaded("missfam2_pier") do Wait(0) end

        TaskPlayAnim(
            PlayerPedId(), 'missfam2_pier',
            'pier_lean_toss_cigarette',
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
                    "You hear something smug approaching...", 
                    "primary",
                    3000
                )
                TriggerServerEvent("ct-fishing:server:GiveReward", Shared.currentZone.reward())
            else
                QBCore.Functions.Notify(
                    "You sound like new money",
                    "error",
                    3000
                )
            end
        end, 3, 20) -- NumberOfCircles, MS

        ClearPedTasks(PlayerPedId())
        cb()
    end,
    reward = function()
        local year, month, day, hour, minute, second = GetUtcTime()
        math.randomseed((year * month / second) + ((minute - day) * second) + hour)
        local roll = math.random()
        local rewards = {}
        local dropRates = {
            { 40, "flyfishnote" },
            { 90, "flyfish" }
        }

        for k, item in pairs(dropRates) do
            if #rewards >= 2 then return rewards end

            local numToSucceed = 1 - (item[1] / 100)

            print(roll)

            if roll >= numToSucceed then
                table.insert(rewards, item[2])
            end
        end

        return rewards
    end,
    zone_setup = function()
        local modelHash = "hei_p_attache_case_shut"
        local model

        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(0)
        end

        model = CreateObject(modelHash, 898.4, 36.3, 111.1, false, false, false)
        
        if not Shared.ZoneProps then Shared.ZoneProps = {} end

        Shared.ZoneProps["fly_fishing"] = {model}
        
        FreezeEntityPosition(model, true)
        SetEntityInvincible(model, true)
        SetBlockingOfNonTemporaryEvents(model, true)
    end,
})

print("zone configs loaded, Shared Object: ")
print(Shared)