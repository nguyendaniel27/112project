local locations = {}

-- Forests

-- Temperate Forest
locations.forest_temperate = {}
locations.forest_temperate.technicalName = "forest_temperate"
locations.forest_temperate.displayName = "Temperate Forest"
locations.forest_temperate.description = "Something about this forest reminds you of back home."
locations.forest_temperate.rarity = "common"

locations.forest_temperate.natGenData = {}
locations.forest_temperate.natGenData.whitelist = {"scav_weak", "scav", "scav_hardened", "scav_captain", "cache_small"}
locations.forest_temperate.natGenData.minSpawn = 1
locations.forest_temperate.natGenData.maxSpawn = 2
locations.forest_temperate.natGenData.allowHostiles = true

-- Tropical Forest
locations.forest_tropical = {}
locations.forest_tropical.technicalName = "forest_tropical"
locations.forest_tropical.displayName = "Tropical Forest"
locations.forest_tropical.description = "The soles of your boots make impressions in the moist forest floor."
locations.forest_tropical.rarity = "common"

locations.forest_tropical.natGenData = {}
locations.forest_tropical.natGenData.whitelist = {"scav_weak", "scav", "scav_hardened", "scav_captain", "cache_small"}
locations.forest_tropical.natGenData.minSpawn = 1
locations.forest_tropical.natGenData.maxSpawn = 2
locations.forest_tropical.natGenData.allowHostiles = true

-- Boreal Forest
locations.forest_boreal = {}
locations.forest_boreal.technicalName = "forest_boreal"
locations.forest_boreal.displayName = "Taiga"
locations.forest_boreal.description = "The bright sunlight reflecting off of the snowy hills makes you wish you'd brought goggles."
locations.forest_boreal.rarity = "common"

locations.forest_boreal.natGenData = {}
locations.forest_boreal.natGenData.whitelist = {"scav_weak", "scav", "scav_hardened", "scav_captain", "cache_small"}
locations.forest_boreal.natGenData.minSpawn = 1
locations.forest_boreal.natGenData.maxSpawn = 2
locations.forest_boreal.natGenData.allowHostiles = true

-- Scav Locations

-- Scav Campsite
locations.scav_camp = {}
locations.scav_camp.technicalName = "scav_camp"
locations.scav_camp.displayName = "Scavenger's Camp"
locations.scav_camp.description = "A small scavenger's outpost lies ahead. You must be cautious in your actions."
locations.scav_camp.rarity = "rare"

locations.scav_camp.natGenData = {}
locations.scav_camp.natGenData.whitelist = {"scav_weak", "scav", "cache_small"}
locations.scav_camp.natGenData.minSpawn = 3
locations.scav_camp.natGenData.maxSpawn = 7
locations.scav_camp.natGenData.allowHostiles = true

-- Scav Base
locations.scav_base = {}
locations.scav_base.technicalName = "scav_base"
locations.scav_base.displayName = "Scavenger's Base"
locations.scav_base.description = "A scavenger's base towers over you. You hope you are prepared enough to fight."
locations.scav_base.rarity = "legendary"

locations.scav_base.natGenData = {}
locations.scav_base.natGenData.whitelist = {"scav_weak", "scav", "scav_hardened", "scav_captain", "cache_large"}
locations.scav_base.natGenData.minSpawn = 5
locations.scav_base.natGenData.maxSpawn = 12
locations.scav_base.natGenData.allowHostiles = true

-- High value locations

-- Abandoned labs
locations.hvl_labs = {}
locations.hvl_labs.technicalName = "hvl_labs"
locations.hvl_labs.displayName = "Abandoned Labs"
locations.hvl_labs.description = "A scavenger's base towers over you. You hope you are prepared enough to fight."
locations.hvl_labs.rarity = "exotic"

locations.hvl_labs.natGenData = {}
locations.hvl_labs.natGenData.whitelist = {"scav_captain", "militia_specialist", "militia_captain", "militia_commander", "cache_large"}
locations.hvl_labs.natGenData.minSpawn = 5
locations.hvl_labs.natGenData.maxSpawn = 12
locations.hvl_labs.natGenData.allowHostiles = true

return locations