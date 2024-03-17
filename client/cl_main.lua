local QBCore = exports["qb-core"]:GetCoreObject();

RegisterNetEvent("ct-fishing:client:UseFishingRod", function()
    if not QBCore.Functions.HasItem("fishingrod") then
        QBCore.Functions.Notify("You could scream, but no one would hear you", "error", 2500)
        return
    end
    if Shared.isFishing then
        QBCore.Functions.Notify("Don't strain yourself...", "error", 2500)
        return
    end
    
    if Shared.canFish then
        if Shared.currentZone.fish then 
            Shared.currentZone.fish() 
        else 
            QBCore.Functions.Notify("Just Fishing...", "primary", 2500) 
        end
    else
        QBCore.Functions.Notify("Why would you think you can fish here..?", "error", 2500)
    end
end)

RegisterNetEvent("ct-fishing:client:UseAntiTriFish", function()
    if not QBCore.Functions.HasItem("antitrifish") then
        QBCore.Functions.Notify("You've got no idea what to do", "error", 2500)
        return
    end

    if Shared.atfInUse then
        QBCore.Functions.Notify("No reason to use it again!", "error", 2500)
        return
    else
        QBCore.Functions.Notify("There was a shift in the aquaforce", "primary", 2500)
        local shopkeeper = FishShop.spawn()
        local indicator = FishShop.buildProps()
        CreateThread(function()
            Wait(10000)
            DeleteEntity(shopkeeper)
            DeleteEntity(indicator)
            TriggerEvent("qb-menu:client:closeMenu")
            QBCore.Functions.Notify("The aquaforce is back to normal", "primary", 2500)
            Shared.atfInUse = false
        end)
        Shared.atfInUse = true
    end
end)

-- Generate Fishing Zones from Configs
CreateThread(function()
    local zones = {}

    for k, zone in pairs(Shared.FishingZoneConfigs) do
        local zc = zone.config
        local nextZone = #zones+1

        if zone.zone_type == "circle" then
            zones[nextZone] = CircleZone:Create(zc.center, zc.radius, zc.options)
        elseif zone.zone_type == "box" then
            zones[nextZone] = BoxZone:Create(zc.center, zc.length, zc.width, zc.options)
        end

        zones[nextZone].inOut = zone.inOut
        zones[nextZone].fish = zone.fish
        zones[nextZone].game = zone.game
        zones[nextZone].reward = zone.reward

        if zone.zone_setup then
            zone.zone_setup()
        end

        Shared.FishingZones[zones[nextZone].name] = zones[nextZone]
    end
    
    local fishingCombo = ComboZone:Create(zones, {
        name="FishingCombo",
        debugPoly = true
    })

    fishingCombo:onPlayerInOut(function(isPointInside, point, zone)
        if zone == nil then return else
            zone.inOut(isPointInside, point, zone)
        end
    end)
end)