local QBCore = exports["qb-core"]:GetCoreObject();
RegisterNetEvent("ct-fishing:client:UseFishingRod", function()
    if not QBCore.Functions.HasItem("fishingrod") then
        QBCore.Functions.Notify("Hmm.. How you trying to fish without a rod?", "error", 2500)
        QBCore.Functions.Notify("!Admin Notified!", "error", 2500)
        return
    end
    if Shared.isFishing then
        QBCore.Functions.Notify("Don't strain yourself...", "error", 2500)
        return
    end
    -- Check if in zone
    if Shared.canFish then
        if Shared.currentZone.fish then 
            Shared.currentZone.fish() 
        else 
            QBCore.Functions.Notify("Just Fishing...", "primary", 2500) 
        end
        -- Play fishing animation
        -- Progress Bar
        -- Give Fish
    else
        QBCore.Functions.Notify("Why would you think you can fish here..?", "error", 2500)
    end
end)

CreateThread(function()
    local zones = {}
    
    for k, zone in pairs(Shared.FishingZoneConfigs) do
        local zc = zone.config
        local nextZone = #zones+1

        if zone.poly_type == "circle" then
            zones[nextZone] = CircleZone:Create(zc.center, zc.radius, zc.options)
        elseif zone.poly_type == "box" then
            zones[nextZone] = BoxZone:Create(zc.center, zc.length, zc.width, zc.options)
        end
        
        zones[nextZone].inOut = zone.inOut
        zones[nextZone].fish = zone.fish
        zones[nextZone].game = zone.game
        zones[nextZone].reward = zone.reward
        
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