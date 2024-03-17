local QBCore = exports["qb-core"]:GetCoreObject();

RegisterNetEvent("ct-fishing:server:SellFish", function(source, fish, qtyToSell, value)
    -- print(Dump(QBCore.Functions.GetPlayer(1).Functions.AddMoney("cash", 100)))
    local totalQtyHeld = 0
    local slotsToSellFrom = {}
    for i, slot in ipairs(exports["qb-inventory"]:GetItemsByName(source, fish.name)) do
        totalQtyHeld = totalQtyHeld + slot["amount"]
        table.insert(slotsToSellFrom, {
            slot = slot.slot,
            amount = slot.amount
        })
        
        if qtyToSell ~= "All" and totalQtyHeld > qtyToSell then break end
    end

    local qtyLeftToSell = qtyToSell
    local moneyEarned = 0

    for s, slotToSellFrom in pairs(slotsToSellFrom) do
        if qtyLeftToSell == "All" then
            exports["qb-inventory"]:RemoveItem(1, fish.name, slotToSellFrom.amount, slotToSellFrom.slot)
            moneyEarned = moneyEarned + (value * slotToSellFrom.amount)
        elseif slotToSellFrom.amount >= qtyLeftToSell then
            exports["qb-inventory"]:RemoveItem(1, fish.name, qtyLeftToSell, slotToSellFrom.slot)
            moneyEarned = moneyEarned + (value * qtyLeftToSell)
        else
            qtyLeftToSell = qtyLeftToSell - slotToSellFrom.amount
            exports["qb-inventory"]:RemoveItem(1, fish.name, slotToSellFrom.amount, slotToSellFrom.slot)
            moneyEarned = moneyEarned + (value * slotToSellFrom.amount)
        end
    end

    QBCore.Functions.GetPlayer(1).Functions.AddMoney("cash", moneyEarned)
    TriggerClientEvent("ct-fishing:shop:OpenShop", 1)
end)

print("sv_shop loaded")