local utils = {}

function utils.cls()
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
end

function utils.copyTable(tbl)
    local out = {}
    for k,v in pairs(tbl) do
        if v ~= tbl then
            if type(v) == "table" then
                out[k] = utils.copyTable(v)
            else
                out[k] = v
            end
        else
            tbl[k] = out
        end
    end
    return out
end

function utils.displayList(tbl, dispCallback, choiceCallback, args)
    local cref = 1
    while true do
        utils.cls()
        local currmax = cref+9
        local cpr = 1
        local pageref = {}
        if currmax > #tbl then currmax = #tbl end
        print("----- "..cref.."-"..currmax.."/"..#tbl.." -----")
        for i = cref, currmax do
            pageref[cpr] = tbl[i]
            print(cpr..". "..dispCallback(tbl[i]))
            cpr = cpr + 1
        end
        print("----- "..cref.."-"..currmax.."/"..#tbl.." -----")
        print("(B)ack, (F)orwards, (L)eave, Number to choose:")
        local input = io.read()
        if input:lower() == "b" then
            if cref ~= 1 then
                cref = cref - 10
            end
        elseif input:lower() == "f" then
            if currmax < #tbl then
                cref = cref + 10
            end
        elseif input:lower() == "l" then
            break
        elseif tonumber(input) ~= nil then
            if tbl[tonumber(input)] ~= nil then
                local doBreak = choiceCallback(tbl[tonumber(input)], args)
                if doBreak then
                    break
                end
            end
        end
    end
end

function utils.generateMap(length, width, objectCallback, args)
	local map = {}
	for i = 1, length do
		map[i] = {}
		if i ~= 1 then
			local layerwidth = math.random(1,width)
			if i == length then
				layerwidth = 1
			end
			for _ = 1, layerwidth do
				local node = {}
				node.to = {}
				node.from = {}
				node.object = objectCallback(args, node)
				table.insert(map[i], node)
			end
			local previous = {}
			local current = {}
			for x = 1, #map[i] do
				current[x] = map[i][x]
			end
			for x = 1, #map[i-1] do
				previous[x] = map[i-1][x]
			end
			for ix = 1, #previous do
				if #current == 0 then
					for x = 1, #map[i] do
						current[x] = map[i][x]
					end
				end
				local choice = math.random(1,#current)
				table.insert(current[choice].from, previous[ix])
				table.insert(previous[ix].to, current[choice])
				table.remove(current, choice)
			end
			local previous = {}
			local current = {}
			for x = 1, #map[i] do
				current[x] = map[i][x]
			end
			for x = 1, #map[i-1] do
				previous[x] = map[i-1][x]
			end
			for ix = 1, #current do
				if #current[ix].from == 0 then
					if #previous == 0 then
						for x = 1, #map[i-1] do
							previous[x] = map[i-1][x]
						end
					end
					local choice = math.random(1,#previous)
					table.insert(current[ix].from, previous[choice])
					table.insert(previous[choice].to, current[ix])
					table.remove(previous, choice)
				end
			end
		elseif i == 1 then
			local node = {}
			node.to = {}
			node.from = {}
            node.object = objectCallback(args, node)
			table.insert(map[i], node)
		end
	end
	return map
end

game = {}

game.qualities = {}
game.qualities[1] = {}
game.qualities[1].displayName = "Standard"
game.qualities[1].range = {1, 500}
game.qualities[1].damageMult = 1
game.qualities[2] = {}
game.qualities[2].displayName = "Jury-rigged"
game.qualities[2].range = {501,750}
game.qualities[2].damageMult = 2
game.qualities[3] = {}
game.qualities[3].displayName = "Modified"
game.qualities[3].range = {751,900}
game.qualities[3].damageMult = 3
game.qualities[4] = {}
game.qualities[4].displayName = "Precision-engineered"
game.qualities[4].range = {901, 975}
game.qualities[4].damageMult = 5
game.qualities[5] = {}
game.qualities[5].displayName = "Masterwork"
game.qualities[5].range = {976,1000}
game.qualities[5].damageMult = 7

game.assets = {}
game.assets.locations = dofile("locations.db")
game.assets.items = dofile("items.db")
math.randomseed(os.clock()*1000000+os.time())

function game.defaultPIG(stack, item, PIGArgs)
    if type(PIGArgs) == "table" then
        if PIGArgs.quality ~= nil then
            stack.quality = PIGArgs.quality
        else
            local rgen = math.random(1, 1000)
            for k,v in pairs(game.qualities) do
                if v.range[1] <= rgen and rgen <= v.range[2] then
                    stack.quality = k
                    break
                end
            end
            if stack.quality > stack.reference.maxQuality then
                stack.quality = stack.reference.maxQuality
            elseif stack.quality < stack.reference.minQuality then
                stack.quality = stack.reference.minQuality
            end
        end
    else
        local rgen = math.random(1, 1000)
        for k,v in pairs(game.qualities) do
            if v.range[1] <= rgen and rgen <= v.range[2] then
                stack.quality = k
                break
            end
        end
        if stack.quality > stack.reference.maxQuality then
            stack.quality = stack.reference.maxQuality
        elseif stack.quality < stack.reference.minQuality then
            stack.quality = stack.reference.minQuality
        end
    end
end

function game.defaultSPIG(stack1, stack2)
    return stack1.quality == stack2.quality and stack1.technicalName == stack2.technicalName and stack1.category == stack2.category
end

function game.generateStack(technicalName, category, quantity, PIGArgs)
    local stack = {}
    stack.technicalName = technicalName
    stack.category = category
    stack.displayName = game.assets.items[category][technicalName].displayName
    stack.description = game.assets.items[category][technicalName].description
    stack.quantity = quantity
    stack.reference = game.assets.items[category][technicalName]
    stack.equipped = false
    stack.use = stack.reference.use
    if game.assets.items[category][technicalName].slot ~= nil then
        stack.slot = game.assets.items[category][technicalName].slot
    end
    if game.assets.items[category][technicalName].overridePIG ~= nil then
        game.assets.items[category][technicalName]:overridePIG(stack, PIGArgs) -- overridePerInstanceGeneration should be defined as a method with stack and PIGArgs inputs
    else
        game.defaultPIG(stack, game.assets.items[category][technicalName], PIGArgs)
    end
    if game.assets.items[category][technicalName].overrideSPIG ~= nil then
        stack.isSamePIG = items[category][technicalName].overrideSPIG
    else
        stack.isSamePIG = game.defaultSPIG
    end

    function stack:calculateDamage()
        if self.reference.baseAttack ~= nil then
            return math.ceil(self.reference.baseAttack * game.qualities[self.quality].damageMult)
        end
    end

    return stack
end

function game.generateGEnt(statusData)
    local gent = {}
    gent.HP = statusData.HP
    gent.maxHP = statusData.maxHP
    gent.class = statusData.class
    gent.displayName = statusData.displayName
    gent.inventory = {}
    gent.blacklist = statusData.filter
    gent.filter = statusData.filter
    gent.locationNode = false
    gent.isAlive = statusData.isAlive

    -- Slots

    gent.slots = {}

    --[[ Implement wearable armor items later?
    -- Wearable slots
    gent.slots.head = false
    gent.slots.face = false
    gent.slots.chest = false
    gent.slots.arms = false
    gent.slots.hands = false
    gent.slots.legs = false
    gent.slots.feet = false
    ]]
    
    -- Weapon slots
    gent.slots.primary = false
    gent.slots.secondary = false

    function gent:equippable(slot) -- returns an array of what can be equipped in a slot
        local tbl = {}
        for k,v in pairs (self.inventory) do
            if v.slot == slot then
                tbl:insert(v)
            end
        end
        return tbl
    end

    function gent:equipped(slot) -- returns the stack equipped in the slot
        if self.slots[slot] ~= nil then
            return self.slots[slot]
        else
            return false
        end
    end

    function gent:equip(stack, slot) -- equips the stack into the slot
        for k,v in pairs(self.inventory) do
            if v == stack then
                if stack.equipped ~= false then
                    return false, "stackAlreadyEquipped"
                else
                    if self:equipped(slot) == false then
                        self.slots[slot] = stack
                        stack.equipped = slot
                        return true
                    else
                        return false, "slotOccupied"
                    end
                end
            end
        end
        return false, "notInInventory"
    end

    function gent:unequip(slot)
        if self:equipped(slot) ~= false then
            self:equipped(slot).equipped = false
            self.slots[slot] = false
        else
            return false
        end
    end

    function gent:damage(amt, type)
        -- write some stuff here to affect damage based on resistances or equipment effects

        if self.isAlive then
            if self.HP > amt then
                self.HP = self.HP - amt
                return true, true
            else
                self.HP = 0
                self.isAlive = false
                return true, false
            end
        else
            return false, "deadGEnt"
        end

    end

    function gent:heal(amt)
        if self.isAlive then
            if amt >= self.maxHP or (amt + self.HP) >= self.maxHP then
                self.HP = self.maxHP
            else
                self.HP = self.HP + amt
            end
        else
            return false, "deadGEnt"
        end
    end

    function gent:addStackAmount(stack, amt)
        stack = utils.copyTable(stack)
        for k, v in pairs(self.inventory) do
            if v:isSamePIG(stack) then
                v.quantity = v.quantity + amt
                return v
            end
        end
        stack.quantity = amt
        table.insert(self.inventory, stack)
        return self.inventory[#self.inventory]
    end

    function gent:removeStackAmount(stack, amt)
        for k,v in pairs(self.inventory) do
            if v:isSamePIG(stack) then
                if v.quantity >= amt then
                    v.quantity = v.quantity - amt
                    if v.quantity == 0 then
                        table.remove( self.inventory, k )
                    end
                    return true
                else
                    return false, "notEnoughinInventory"
                end
            end
        end
        return false, "notinInventory"
    end

    function gent:setLocation(locationObj)
        for k,v in pairs(locationObj.environment) do
            if v == self then
                return true
            end
        end
        if self.locationNode == false then
            self.locationNode = locationObj
            table.insert(locationObj.environment, self)
        else
            for k,v in pairs(self.locationNode.environment) do
                if v == self then
                    table.remove( self.locationNode.environment, k )
                end
            end
            self.locationNode = locationObj
            table.insert(locationObj.environment, self)
        end
    end

    function gent:setCombatant(locationObj)
        for k,v in pairs(locationObj.combatants) do
            if v == self then
                return true
            end
        end
        table.insert(locationObj.combatants, self)
    end

    function gent:calculateWeight()
        local total = 0
        for k,v in pairs(self.inventory) do
            total = total + (v.reference.weight * v.quantity)
        end
        return total
    end

    function gent:calculateDamageMultiplier()
        if self.weightLimit == nil then return 1 end
        local x = math.ceil((self:calculateWeight() - self.weightLimit)/10) + 1
        if x < 1 then x = 1 end
        return x
    end

    function gent:itemCount()
        local total = 0
        for k,v in pairs(self.inventory) do
            total = total + v.quantity
        end
        return total
    end
    
    return gent
end

game.assets.gents, game.assets.natGenerate = dofile("gents.db")

function game.generateLocation(technicalName, nodePassthrough)
    local location = {}
    location.reference = game.assets.locations[technicalName]
    location.technicalName = technicalName
    location.displayName = location.reference.displayName
    location.description = location.reference.description
    location.natGenData = location.reference.natGenData
    location.node = nodePassthrough

    location.environment = {}
    location.combatants = {}
    return location
end

game.cache = {}
game.cache.items = {}
game.cache.gents = {}
game.cache.locations = {}

function game.randomItem(category)
    if category == nil then category = "all" end
    if category == "all" then
        if game.cache.items.all == nil then
            game.cache.items.all = {}
            for k,v in pairs(game.assets.items) do
                for k2,v2 in pairs(v) do
                    table.insert(game.cache.items.all, {v2.technicalName, k})
                end
            end
        end
        local choice = math.random(1, #game.cache.items.all)
        return game.cache.items.all[choice][1], game.cache.items.all[choice][2]
    else
        if game.cache.items[category] == nil then
            game.cache.items[category] = {}
            for k,v in pairs(game.assets.items[category]) do
                table.insert(game.cache.items[category], v.technicalName)
            end
        end
        return game.cache.items[category][math.random(1, #game.cache.items[category])], category
    end
end

function game.randomizedGEnt(location, technicalName)
    if location ~= nil then
        local gEnt
        if technicalName == nil then
            if location.natGenData.allowHostiles == false then
                if game.cache.gents.nonHostile == nil then
                    game.cache.gents.nonHostile = {}
                    for k,v in pairs(game.assets.natGenerate) do
                        if v("hostile") ~= true then
                            table.insert(game.cache.gents.nonHostile, v)
                        end
                    end
                end
                -- here
                gEnt = game.cache.gents.nonHostile[math.random(1,#game.cache.gents.nonHostile)](location)
            else
                if game.cache.gents.allNat == nil then
                    game.cache.gents.allNat = {}
                    for k,v in pairs(game.assets.natGenerate) do
                        table.insert(game.cache.gents.allNat,v)
                    end
                end
                -- here
                gEnt = game.cache.gents.allNat[math.random(1,#game.cache.gents.allNat)](location)
            end
        else
            gEnt = game.assets.gents[technicalName](location)
        end
        if gEnt.natGenData == nil then
            return gEnt
        end
        local numItems = math.random(gEnt.natGenData.minItems,gEnt.natGenData.maxItems)
        for i = 1, numItems do
            local tn, ct = game.randomItem()
            gEnt:addStackAmount(game.generateStack(tn, ct, 1, {}),1)
        end
        if gEnt.natGenData.mustHaveWeapon == true then
            local hasWeapon = false
            for k,v in pairs(gEnt.inventory) do
                if v.category == "weapons" then
                    if not gEnt:equipped(v.reference.slot) then
                        gEnt:equip(v, v.reference.slot)
                    end
                end
            end
            if not hasWeapon then
                local tn, ct = game.randomItem("weapons")
                local weap = gEnt:addStackAmount(game.generateStack(tn, ct, 1, {}),1)
                gEnt:equip(weap, weap.reference.slot)
            end
        end
        return gEnt
    end
end

function game.randomizedLocation (args, nodePassthrough)
    if game.cache.locations.all == nil then
        game.cache.locations.all = {}
        for k,v in pairs(game.assets.locations) do
            table.insert(game.cache.locations.all, v.technicalName)
        end
    end
    local techName = game.cache.locations.all[math.random(1,#game.cache.locations.all)]
    local location = game.generateLocation(techName, nodePassthrough)
    local gentSpawns = math.random(location.natGenData.minSpawn,location.natGenData.maxSpawn)
    if not (gentSpawns <= 0) then
        for i = 1, gentSpawns do
            game.randomizedGEnt(location)
        end
    end
    return location
end

game.map = utils.generateMap(200,9,game.randomizedLocation)

game.player = game.assets.gents.player(game.map[1][1].object)

game.inventory = {}

function game.aliveEnemies()
    for k,v in pairs(game.player.locationNode.combatants) do
        if v.isAlive then
            return true
        end
    end
    return false
end

function game.inventory.displayCallback(stack)
    if stack.equipped == false then
        return "("..stack.quantity..") "..stack.displayName..", "..game.qualities[stack.quality].displayName
    else
        return "("..stack.quantity..") "..stack.displayName.." (e), "..game.qualities[stack.quality].displayName
    end
end

function game.inventory.dropHandler(stack)
    utils.cls()
    if stack.equipped == false then
        print("Drop what amount:")
        local amt
        local inp = io.read()
        if tonumber(inp) == nil then
            amt = 1
        elseif tonumber(inp) <= 0 then
            print("Cannot drop values at or less than zero.")
            print("Press enter to continue.")
            io.read()
            return false
        elseif tonumber(inp) ~= nil then
            amt = tonumber(inp)
            if amt > stack.quantity then amt = stack.quantity end
        end
        for k,v in pairs(game.player.locationNode.environment) do
            if v.class == "basegame:dropbag" then
                v:addStackAmount(stack, amt)
                game.player:removeStackAmount(stack, amt)
                return true
            end
        end
        local dropBag = game.assets.gents.dropBag(game.player.locationNode)
        dropBag:addStackAmount(stack, amt)
        game.player:removeStackAmount(stack, amt)
        return true
    else
        print("You can't drop an equipped item.")
        print("Press enter to continue.")
        io.read()
    end
    return false
end

function game.inventory.playerChoiceCallback(stack)
    while true do
        utils.cls()
        print("----------")
        print("Name: "..stack.displayName)
        print("Description: "..stack.description)
        print("-----")
        print("Quality: "..game.qualities[stack.quality].displayName.." (Level "..stack.quality..")")
        print("Quantity: "..stack.quantity)
        print("-----")
        print("Sellable: "..tostring(stack.reference.sellable))
        print("Value (per item): "..tostring(stack.reference.baseValue)) -- replace this with value equation later
        print("Value (total): "..tostring(stack.reference.baseValue * stack.quantity)) -- replace this with value equation later
        print("-----")
        print("Weight (per item): "..stack.reference.weight)
        print("Weight (total): "..(stack.reference.weight * stack.quantity))
        print("-----")
        if stack.reference.displaySlot ~= nil then
            print("Equip Slot: "..stack.reference.displaySlot)
            if stack.equipped ~= false then
                print("Equipped: True")
            else
                print("Equipped: False")
            end
        end
        if stack.reference.baseAttack ~= nil then
            print("Attack Damage: "..stack:calculateDamage())
        end

        -- insert effects, resistance, damage type, damage threshold data here when implemented

        print("----------")
        if stack.category == "weapons" then
            if stack.equipped == false then
                print("(E)quip item, (D)rop item, (L)eave Menu")
            else
                print("(U)nequip item, (D)rop item, (L)eave Menu")
            end
        elseif stack.category == "consumables" then
            print("(U)se item, (L)eave menu")
        end
        local input = io.read()
        if input:lower() == "d" then
            return game.inventory.dropHandler(stack)
        elseif input:lower() == "e" and stack.category == "weapons" then
            if stack.equipped == false then
                game.player:equip(stack, stack.reference.slot)
            end
        elseif input:lower() == "u" and stack.category == "weapons" then
            if stack.equipped ~= false then
                game.player:unequip(stack.reference.slot)
            end
        elseif input:lower() == "u" and stack.category == "consumables" then
            stack:use(game.player)
            break
        elseif input:lower() == "l" then
            break
        end
    end
    return false
end

function game.inventory.playerCombatChoiceCallback(stack)
    while true do
        utils.cls()
        print("----------")
        print("Name: "..stack.displayName)
        print("Description: "..stack.description)
        print("-----")
        print("Quality: "..game.qualities[stack.quality].displayName.." (Level "..stack.quality..")")
        print("Quantity: "..stack.quantity)
        print("-----")
        print("Sellable: "..tostring(stack.reference.sellable))
        print("Value (per item): "..tostring(stack.reference.baseValue)) -- replace this with value equation later
        print("Value (total): "..tostring(stack.reference.baseValue * stack.quantity)) -- replace this with value equation later
        print("-----")
        print("Weight (per item): "..stack.reference.weight)
        print("Weight (total): "..(stack.reference.weight * stack.quantity))
        print("-----")
        if stack.reference.displaySlot ~= nil then
            print("Equip Slot: "..stack.reference.displaySlot)
            if stack.equipped ~= false then
                print("Equipped: True")
            else
                print("Equipped: False")
            end
        end
        if stack.reference.baseAttack ~= nil then
            print("Attack Damage: "..stack:calculateDamage())
        end

        -- insert effects, resistance, damage type, damage threshold data here when implemented

        print("----------")
        if stack.category == "weapons" then
            if stack.equipped == false then
                print("(E)quip item, (L)eave Menu")
            else
                print("(U)nequip item, (L)eave Menu")
            end
        elseif stack.category == "consumables" then
            print("(U)se item, (L)eave menu")
        end
        local input = io.read()
        if input:lower() == "e" and stack.category == "weapons" then
            if stack.equipped == false then
                game.player:equip(stack, stack.reference.slot)
            end
        elseif input:lower() == "u" and stack.category == "weapons" then
            if stack.equipped ~= false then
                game.player:unequip(stack.reference.slot)
            end
        elseif input:lower() == "u" and stack.category == "consumables" then
            stack:use(game.player)
            break
        elseif input:lower() == "l" then
            break
        end
    end
    return false
end

function game.inventory.nonPlayerInvCallback(stack, args)
    while true do
        utils.cls()
        print("----------")
        print("Name: "..stack.displayName)
        print("Description: "..stack.description)
        print("-----")
        print("Quality: "..game.qualities[stack.quality].displayName.." (Level "..stack.quality..")")
        print("Quantity: "..stack.quantity)
        print("-----")
        print("Sellable: "..tostring(stack.reference.sellable))
        print("Value (per item): "..tostring(stack.reference.baseValue)) -- replace this with value equation later
        print("Value (total): "..tostring(stack.reference.baseValue * stack.quantity)) -- replace this with value equation later
        print("-----")
        print("Weight (per item): "..stack.reference.weight)
        print("Weight (total): "..(stack.reference.weight * stack.quantity))
        print("-----")
        if stack.reference.displaySlot ~= nil then
            print("Equip Slot: "..stack.reference.displaySlot)
        end
        if stack.reference.baseAttack ~= nil then
            print("Attack Damage: "..stack:calculateDamage())
        end

        -- insert effects, resistance, damage type, damage threshold data here when implemented

        print("----------")
        print("(T)ake items, (L)eave Menu")
        local input = io.read()
        if input:lower() == "t" then
            print("Take what amount: ")
            local amt = io.read()
            local amt = tonumber(amt)
            args.gent:unequip(stack.reference.slot)
            if amt == nil then
                amt = 0
            end
            if amt > stack.quantity then 
                amt = stack.quantity 
            end
            if amt < 0 then
                amt = 0
            end
            game.player:addStackAmount(stack, amt)
            args.gent:removeStackAmount(stack, amt)
            return true
        elseif input:lower() == "l" then
            break
        end
    end
    return false
end

function game.setGameOver()
    game.gameOver = true
    print("You have died.")
    print("Game over.")
end

game.locationMenu = {}
game.playerTurn = true
game.gameOver = false

function game.locationMenu.displayCallback(locationNode)
    return locationNode.object.displayName
end

function game.locationMenu.choiceCallback(locationNode)
    game.player:setLocation(locationNode.object)
    game.playerTurn = true
    return true
end

while true do
    if game.gameOver == true then
        break
    elseif not game.aliveEnemies() then
        utils.cls()
        print("--------------------")
        print("Health: "..game.player.HP.."/"..game.player.maxHP)
        print("Weight: "..game.player:calculateWeight().."/"..game.player.weightLimit.." kg")
        if game.player:calculateWeight() > game.player.weightLimit then
            print("Overweight Damage Multiplier: "..game.player:calculateDamageMultiplier().."x")
        end
        print("---------")
        print(game.player.locationNode.displayName)
        print()
        print(game.player.locationNode.description)
        print("----------")
        print()
        print("(O)pen Inventory")
        print("(I)nteract")
        print("(M)ove")
        print()
        print("--------------------")

        local input = io.read()
        if input:lower() == "o" then
            utils.displayList(game.player.inventory,game.inventory.displayCallback,game.inventory.playerChoiceCallback)
        elseif input:lower() == "i" then
            if #game.player.locationNode.environment == 1 then
                utils.cls()
                print("There doesn't seem to be anything to interact with.")
                print("Press enter to continue.")
                io.read()
            else
                utils.displayList(game.player.locationNode.environment, function(x) return x.displayName.." ("..x:itemCount().." items)" end, function (gent) 
                    if gent.class == "basegame:player" then
                        utils.displayList(game.player.inventory,game.inventory.displayCallback,game.inventory.playerChoiceCallback)
                    else
                        while true do
                            utils.cls()
                            print("----------")
                            print()
                            print(gent.displayName)
                            print()
                            print("-----")
                            print()
                            if gent.shopkeep ~= nil and gent.isAlive then
                                print("(S)hop")
                            end
                            if gent.isAlive == false then
                                print("(O)pen inventory")
                            end
                            print()
                            print("----------")
                            print("(L)eave")
                            local input = io.read()
                            if input:lower() == "o" and gent.isAlive == false then
                                utils.displayList(gent.inventory,game.inventory.displayCallback,game.inventory.nonPlayerInvCallback,{["gent"] = gent})
                            elseif input:lower() == "l" then
                                break
                            end
                        end
                    end
                end)
            end
        elseif input:lower() == "m" then
            utils.displayList(game.player.locationNode.node.to,game.locationMenu.displayCallback, game.locationMenu.choiceCallback)
        end
    else
        while true do
            if #game.player.locationNode.combatants == 0 then
                break
            end
            utils.cls()
            if game.playerTurn then
                print("----- COMBAT -----")
                print()
                print("Health: "..game.player.HP.."/"..game.player.maxHP)
                print("Weight: "..game.player:calculateWeight().."/"..game.player.weightLimit.." kg")
                if game.player:calculateWeight() > game.player.weightLimit then
                    print("Overweight Damage Multiplier: "..game.player:calculateDamageMultiplier().."x")
                end
                print()
                print("(I)nventory")
                print("(A)ttack")
                print()
                print("----- COMBAT -----")
                local input = io.read()
                if input:lower() == "i" then
                    utils.displayList(game.player.inventory,game.inventory.displayCallback,game.inventory.playerCombatChoiceCallback)
                elseif input:lower() == "a" then
                    while true do
                        utils.cls()
                        print("----- ATTACK -----")
                        for k,v in pairs(game.player.locationNode.combatants) do
                            print(k..". "..v.displayName..", "..v.HP.."/"..v.maxHP.." HP")
                        end
                        print("----- ATTACK -----")
                        print("(L)eave, Number to choose:")
                        local input = io.read()
                        if input:lower() == "l" then
                            break
                        elseif tonumber(input) ~= nil then
                            if game.player.locationNode.combatants[tonumber(input)] ~= nil then
                                local choice = game.player.locationNode.combatants[tonumber(input)]
                                local choiceIndex = tonumber(input)
                                while true do
                                    utils.cls()
                                    print("----- ATTACK -----")
                                    if game.player:equipped("primary") == false and game.player:equipped("secondary") == false then
                                        print("No weapons equipped.")
                                        print("Press enter to continue.")
                                        print("----- ATTACK -----")
                                        io.read()
                                        break
                                    else
                                        print("(L)eave, Choose weapon: ")
                                        local pri
                                        if false ~= game.player:equipped("primary") then
                                            pri = game.player:equipped("primary")
                                            print("(P)rimary: "..pri.displayName..", "..game.qualities[pri.quality].displayName..", "..pri:calculateDamage().." damage")
                                        end
                                        local sec
                                        if false ~= game.player:equipped("secondary") then
                                            sec = game.player:equipped("secondary")
                                            print("(S)econdary: "..sec.displayName..", "..game.qualities[sec.quality].displayName..", "..sec:calculateDamage().." damage")
                                        end
                                        if false ~= game.player:equipped("secondary") and false ~= game.player:equipped("primary") then
                                            print("(B)oth: "..(sec:calculateDamage() + pri:calculateDamage()).." damage")
                                        end
                                        print("----- ATTACK -----")
                                        local input = io.read()
                                        if input:lower() == "l" then
                                            break
                                        elseif input:lower() == "p" and game.player:equipped("primary") ~= false then
                                            print("You attack '"..choice.displayName.."' for "..pri:calculateDamage().." damage")
                                            local success, alive = choice:damage(pri:calculateDamage())
                                            if not alive then
                                                table.remove(game.player.locationNode.combatants, choiceIndex)
                                                print("You have killed "..choice.displayName)
                                            end
                                            game.playerTurn = false
                                            print("Press enter to continue.")
                                            io.read()
                                            break
                                        elseif input:lower() == "s" and game.player:equipped("secondary") ~= false then
                                            print("You attack '"..choice.displayName.."' for "..sec:calculateDamage().." damage")
                                            local success, alive = choice:damage(sec:calculateDamage())
                                            if not alive then
                                                table.remove(game.player.locationNode.combatants, choiceIndex)
                                                print("You have killed "..choice.displayName)
                                            end
                                            game.playerTurn = false
                                            print("Press enter to continue.")
                                            io.read()
                                            break
                                        elseif input:lower() == "b" and false ~= game.player:equipped("secondary") and false ~= game.player:equipped("primary") then
                                            print("You attack '"..choice.displayName.."' for "..(sec:calculateDamage() + pri:calculateDamage()).." damage")
                                            local success, alive = choice:damage((sec:calculateDamage() + pri:calculateDamage()))
                                            if not alive then
                                                table.remove(game.player.locationNode.combatants, choiceIndex)
                                                print("You have killed "..choice.displayName)
                                            end 
                                            game.playerTurn = false
                                            print("Press enter to continue.")
                                            io.read()
                                            break
                                        end
                                    end
                                    
                                end
                            end
                            break
                        end
                    end
                end
            else
                for k,v in pairs(game.player.locationNode.combatants) do
                    if v:equipped("primary") ~= false then
                        print(v.displayName.." deals "..(v:equipped("primary"):calculateDamage()*game.player:calculateDamageMultiplier()).." damage to the player using '"..v:equipped("primary").displayName.."'.")
                        local success, alive = game.player:damage(v:equipped("primary"):calculateDamage()*game.player:calculateDamageMultiplier())
                        if not alive then
                            game.setGameOver()
                            break
                        end 
                    elseif v:equipped("secondary") ~= false then
                        print(v.displayName.." deals "..(v:equipped("secondary"):calculateDamage()*game.player:calculateDamageMultiplier()).." damage to the player using '"..v:equipped("secondary").displayName.."'.")
                        local success, alive = game.player:damage(v:equipped("secondary"):calculateDamage()*game.player:calculateDamageMultiplier())
                        if not alive then
                            game.setGameOver()
                            break
                        end 
                    else
                        print(v.displayName.." has no weapons equipped and therefore cannot attack.")
                    end
                end
                if game.gameOver then
                    break
                end
                game.playerTurn = true
                print("Press enter to continue.")
                io.read()
            end
        end
    end
end