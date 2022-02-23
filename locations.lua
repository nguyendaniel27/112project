local locations = {}

-- Forests

-- Temperate Forest
locations.forest_temperate = {}
locations.forest_temperate.technicalName = "forest_temperate"
locations.forest_temperate.displayName = "Temperate Forest"
locations.forest_temperate.description = "Something about this forest reminds you of back home."
locations.forest_temperate.rarity = "common"

locations.forest_temperate.natGenData = {}
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
locations.forest_boreal.natGenData.minSpawn = 1
locations.forest_boreal.natGenData.maxSpawn = 2
locations.forest_boreal.natGenData.allowHostiles = true

return locations