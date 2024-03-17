local QBCore = exports["qb-core"]:GetCoreObject();

FishShop = {}

FishShop.config = {
    getLocation = function()
        -- x, y, z, heading
        return 1139.38, 3944.31, -10.17, 16.55
    end,
    items = {
        [0] = { name = "bassfish", value = 50 },
        [1] = { name = "dorkfish", value = 250 },
        [2] = { name = "flyfish", value = 500 },
    },
}

FishShop.propConfig = {
    getLocation = function() return 1147.35, 3936.24, 33.0, 290 end
}

local transitionMenus = function(menu)
    if Shared.atfInUse == false then
        TriggerEvent("qb-menu:client:closeMenu")
    else
        exports['qb-menu']:openMenu(menu)
    end
end

FishShop.buildProps = function()
    local propModel = "prop_roadcone01a"
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do Wait(0) end

    local x, y, z, h = FishShop.propConfig.getLocation()

    local coneIndicator = CreateObjectNoOffset(propModel, x, y, z, false, false, false)
    FreezeEntityPosition(coneIndicator, true)

    return coneIndicator
end

FishShop.spawn = function()
    local pedModel = "a_c_killerwhale"
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do Wait(0) end

    local x, y, z, h = FishShop.config.getLocation()

    local shopkeeper = CreatePed(
        2, pedModel,
        x, y, z, h,
        false, false
    )
    FreezeEntityPosition(shopkeeper, true)
    SetEntityInvincible(shopkeeper, true)
    SetBlockingOfNonTemporaryEvents(shopkeeper, true)
    TaskStartScenarioInPlace(shopkeeper, "WORLD_FISH_IDLE", 0, true)

    

    exports['qb-target']:AddTargetEntity(shopkeeper, {
        options = {
            {
                type = "client",
                icon = "fas fa-fish",
                label = "\"Sell\" Fish",
                event = "ct-fishing:shop:OpenShop"
            }
        },
        distance = 3.0
    })

    return shopkeeper
end

RegisterNetEvent("ct-fishing:shop:OpenShop", function()
    local menu = {
        {
            header = "Wally's Paradise",
            isMenuHeader = true
        },
    }

    for i, item in pairs(FishShop.config.items) do
        local fish = QBCore.Shared.Items[item.name]
        local value = item.value
        local hasItem = exports['qb-inventory']:HasItem(item.name, 1)

        table.insert(menu, {
            header = fish.label,
            txt = "Value: "..value,
            params = {
                event = "ct-fishing:shop:SelectedFish",
                args = {
                    fish = fish,
                    value = value,
                }
            },
            disable = function() if hasItem then return false end return true end
        })
    end

    table.insert(menu, {
        header = "Close Menu",
        txt = "Clicking off menu works too",
        params = {
            event = "qb-menu:closeMenu"
        }
    })

    transitionMenus(menu)
end)

RegisterNetEvent("ct-fishing:shop:SelectedFish", function(args)
    local fish = args.fish
    local value = args.value
    local hasAtleastOne = exports['qb-inventory']:HasItem(fish.name, 1)
    local sellOptions = {
        [1] = { label = "x1", amount = 1},
        [2] = { label = "x5", amount = 5},
        [3] = { label = "x10", amount = 10}
    }

    local menu = {
        {
            header = "Wally's Paradise",
            txt = "How many are you selling?",
            isMenuHeader = true
        },
    }
    
    local shouldDisableSellOption = function(hasItem) if hasItem then return false end return true end
    local shouldDisableSellAllOption
    if hasAtleastOne then shouldDisableSellAllOption = false else shouldDisableSellAllOption = true end

    for i, sellOption in ipairs(sellOptions) do
        local qty = sellOption.amount
        local qtyLabel = sellOption.label
        local hasItem = exports['qb-inventory']:HasItem(fish.name, qty)

        table.insert(menu, {
            header = fish.label.." "..qtyLabel,
            txt = "Value: "..value * qty,
            params = {
                event = "ct-fishing:client:SellFish",
                args = {
                    fish = fish,
                    qty = qty,
                    value = value
                }
            },
            disabled = shouldDisableSellOption(hasItem)
        })
    end

    table.insert(menu, {
        header = "All the "..fish.label.."!",
        txt = "I\'m not telling you",
        params = {
            event = "ct-fishing:client:SellFish",
            args = {
                fish = fish,
                qty = "All",
                value = value
            }
        },
        disabled = shouldDisableSellAllOption
    })

    table.insert(menu, {
        header = "Go Back",
        txt = "If you dare!",
        params = {
            event = "ct-fishing:shop:OpenShop"
        }
    })

    table.insert(menu, {
        header = "Close Menu",
        txt = "Clicking off menu works too",
        params = {
            event = "qb-menu:closeMenu"
        }
    })

    transitionMenus(menu)
end)

RegisterNetEvent("ct-fishing:client:SellFish", function(args)
    -- print("=============================================")
    -- print("=============================================")
    -- print("=============================================")
    -- print("=============================================")
    -- print("=============================================")
    -- print("================= NEW DUMP ==================")
    -- print("=============================================")
    -- print("=============================================")
    -- print("=============================================")
    -- print(Dump(QBCore))
    TriggerServerEvent("ct-fishing:server:SellFish", QBCore.PlayerData.id, args.fish, args.qty, args.value)
end)