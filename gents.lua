local gents = {}
local natGen = {}

gents.player = function (location)
    if location == "hostile" then
        return false
    elseif location == "rarity" then
        return false
    end
    local params = {}
    params.HP = 250
    params.maxHP = 250
    params.class = "basegame:player"
    params.displayName = "Player"
    params.isAlive = true
    local player = game.generateGEnt(params)
    player:addStackAmount(game.generateStack("xcn_S1201", "weapons", 1, {["quality"] = 5}), 1)
    player:addStackAmount(game.generateStack("health_H3", "consumables", 1), 10)
    player:setLocation(location)
    player.weightLimit = 100
    return player
end

gents.dropBag = function (location)
    if location == "hostile" then
        return false
    elseif location == "rarity" then
        return false
    end
    local params = {}
    params.HP = 0
    params.maxHP = 0
    params.class = "basegame:dropbag"
    params.displayName = "Dropped Items Bag"
    params.isAlive = false
    local dropbag = game.generateGEnt(params)
    dropbag:setLocation(location)
    return dropbag
end

-- Caches

gents.cache_small = function (location)
    if location == "hostile" then
        return true
    elseif location == "rarity" then
        return "rare"
    end
    local params = {}
    params.HP = 0
    params.maxHP = 0
    params.class = "basegame:cache_small"
    params.displayName = "Small cache"
    params.isAlive = false
    local cache = game.generateGEnt(params)
    cache:setLocation(location)
    cache.natGenData = {}
    cache.natGenData.minItems = 4
    cache.natGenData.maxItems = 8
    cache.natGenData.mustHaveWeapon = false
    return cache
end

natGen.cache_small = gents.cache_small -- alias

gents.cache_large = function (location)
    if location == "hostile" then
        return true
    elseif location == "rarity" then
        return "legendary"
    end
    local params = {}
    params.HP = 0
    params.maxHP = 0
    params.class = "basegame:cache_large"
    params.displayName = "Large cache"
    params.isAlive = false
    local cache = game.generateGEnt(params)
    cache:setLocation(location)
    cache.natGenData = {}
    cache.natGenData.minItems = 9
    cache.natGenData.maxItems = 16
    cache.natGenData.mustHaveWeapon = false
    return cache
end

natGen.cache_large = gents.cache_large -- alias

-- Scavs

gents.scav_weak = function (location)
    if location == "hostile" then
        return true
    elseif location == "rarity" then
        return "common"
    end
    local params = {}
    params.HP = 100
    params.maxHP = 100
    params.class = "basegame:scav_weak"
    params.displayName = "Green Scavenger"
    params.isAlive = true
    local enemy = game.generateGEnt(params)
    enemy:setLocation(location)
    enemy:setCombatant(location)
    enemy.natGenData = {}
    enemy.natGenData.minItems = 1
    enemy.natGenData.maxItems = 3
    enemy.natGenData.mustHaveWeapon = true
    return enemy
end

natGen.scav_weak = gents.scav_weak -- alias

gents.scav = function (location)
    if location == "hostile" then
        return true
    elseif location == "rarity" then
        return "common"
    end
    local params = {}
    params.HP = 200
    params.maxHP = 200
    params.class = "basegame:scav"
    params.displayName = "Scavenger"
    params.isAlive = true
    local enemy = game.generateGEnt(params)
    enemy:setLocation(location)
    enemy:setCombatant(location)
    enemy.natGenData = {}
    enemy.natGenData.minItems = 3
    enemy.natGenData.maxItems = 5
    enemy.natGenData.mustHaveWeapon = true
    return enemy
end

natGen.scav = gents.scav -- alias

gents.scav_hardened = function (location)
    if location == "hostile" then
        return true
    elseif location == "rarity" then
        return "uncommon"
    end
    local params = {}
    params.HP = 350
    params.maxHP = 350
    params.class = "basegame:scav_hardened"
    params.displayName = "Hardened Scavenger"
    params.isAlive = true
    local enemy = game.generateGEnt(params)
    enemy:setLocation(location)
    enemy:setCombatant(location)
    enemy.natGenData = {}
    enemy.natGenData.minItems = 5
    enemy.natGenData.maxItems = 7
    enemy.natGenData.mustHaveWeapon = true
    return enemy
end

natGen.scav_hardened = gents.scav_hardened -- alias

gents.scav_captain = function (location)
    if location == "hostile" then
        return true
    elseif location == "rarity" then
        return "rare"
    end
    local params = {}
    params.HP = 500
    params.maxHP = 500
    params.class = "basegame:scav_captain"
    params.displayName = "Scavenger Captain"
    params.isAlive = true
    local enemy = game.generateGEnt(params)
    enemy:setLocation(location)
    enemy:setCombatant(location)
    enemy.natGenData = {}
    enemy.natGenData.minItems = 7
    enemy.natGenData.maxItems = 11
    enemy.natGenData.mustHaveWeapon = true
    return enemy
end

natGen.scav_captain = gents.scav_captain -- alias

return gents, natGen