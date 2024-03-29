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
        QBCore.Shared.Items[item], 'remove'
    )
    end
end

local addItem = function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    Player.Functions.AddItem(item, 1)

    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item], 'add')
end

RegisterNetEvent("ct-fishing:server:RemoveBait:bass", function()
    removeItem(source, "bassfishbait")
end)

RegisterNetEvent("ct-fishing:server:RemoveBait:dork", function()
    removeItem(source, "dorkfishbait")
end)

RegisterNetEvent("ct-fishing:server:RemoveBait:fly", function()
    removeItem(source, "flyfishbait")
end)

RegisterNetEvent("ct-fishing:server:GiveReward", function(rewards)
    print("Giving Reward")
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    for k, reward in ipairs(rewards) do
        addItem(source, reward)
    end
end)

QBCore.Functions.CreateUseableItem("fishingrod", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player.Functions.GetItemByName(item.name) then return end
    TriggerClientEvent("ct-fishing:client:UseFishingRod", source)
end)

QBCore.Functions.CreateUseableItem("antitrifish", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player.Functions.GetItemByName(item.name) then return end
    print("Called AntiTriFish")
    TriggerClientEvent("ct-fishing:client:UseAntiTriFish", source)
end)