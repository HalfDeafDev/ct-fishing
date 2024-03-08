local QBCore = exports["qb-core"]:GetCoreObject();

local removeItem = function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    local playerSource = Player.PlayerData.source

    local didRemove = exports['qb-inventory']:RemoveItem(
        playerSource,
        item,
        1, false
    )

    if didRemove then
        TriggerClientEvent("inventory:client:ItemBox",
        playerSource,
        QBCore.Shared.Items["bassfishbait"], 'remove'
    )
    end
end

RegisterNetEvent("ct-fishing:server:RemoveBait:bass", function()
    removeItem(source, "bassfishbait")
end)

QBCore.Functions.CreateUseableItem("fishingrod", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player.Functions.GetItemByName(item.name) then return end
    TriggerClientEvent("ct-fishing:client:FishingRod", source)
end)