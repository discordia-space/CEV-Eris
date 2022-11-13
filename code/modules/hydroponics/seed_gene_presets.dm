/obj/item/computer_hardware/hard_drive/portable/plantgene
	disk_name = "plant gene disk"
	rarity_value = 40
	spawn_tags = SPAWN_TAG_PLANT_GENE_DISK
	spawn_blacklisted = TRUE	// Trade beacons or off-ship loot
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene	// Base type has no gene info
	price_tag = 50
	var/trait_info
	var/preset_genetype
	var/list/preset_values = list()

/obj/item/computer_hardware/hard_drive/portable/plantgene/Initialize()
	var/datum/computer_file/binary/plantgene/preloaded_gene = new /datum/computer_file/binary/plantgene

	// Taken from maintshrooms
	var/list/firstnames = list (
		"bleak", "bog", "bum", "candy", "coarse", "corpse", "cramp", "club", "demon", "dog", "dung", "felt", "fly", "goblin", "grave", "greasy", "hypoxylon", "jelly", "junk", "icky", "imp", "ling", "lung", "maggot", "monkey", "mottled", "pixie", "poached", "powder", "pterula", "ramularia", "radiant", "rat", "roach", "rock", "scruffy", "serbian", "shaggy", "slimy", "smelly", "smoky", "space", "spider", "spiky", "splash", "stag", "stinky", "tumbling", "undulate", "vagabond", "veiled", "wall", "web"
		)
	var/list/secondnames = list(
		"amanita", "bane", "beacon", "bolete", "bonnet", "bulgar", "cap", "cone", "conocybe", "coral", "clown", "cremini", "crepidotus", "cup", "cushion", "entoloma", "ear", "fungus", "gill", "heart", "horn", "hydnum", "leafspot", "leoninus", "lichen", "micellium", "morsel", "moss", "mushroom", "ori", "oyster", "panellus", "polypore", "panus", "porcini", "porridge", "puffball", "rod", "rot", "russula", "scale", "smut", "spots", "stem", "stool", "tail", "tears", "tongue", "trumpet", "truffle",  "urn", "vase", "wort"
		)

	var/plant_name = "[pick(firstnames)] [pick(secondnames)]"
	var/plant_id = rand(100,999)

	preloaded_gene.genesource = plant_name
	preloaded_gene.genesource_uid = plant_id

	preloaded_gene.genetype = preset_genetype
	preloaded_gene.values = preset_values.Copy()

	preloaded_gene.update_name()

	store_file(preloaded_gene)

	disk_name = "[plant_name] #[plant_id], [trait_info]"
	. = ..()

// BIOCHEMISTRY
/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry
	preset_genetype = GENE_BIOCHEMISTRY
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/potency
	trait_info = "potency: 50"
	preset_values = list(TRAIT_POTENCY = 50)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/potency_high
	trait_info = "potency: 100"
	preset_values = list(TRAIT_POTENCY = 100)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/potency_max
	trait_info = "potency: 200"
	preset_values = list(TRAIT_POTENCY = 200)

// Not actually under biochemistry
/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/immutable
	trait_info = "immutable"
	preset_values = list(TRAIT_IMMUTABLE = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/mutable
	trait_info = "mutable"
	preset_values = list(TRAIT_IMMUTABLE = 0)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/highly_mutable
	trait_info = "highly mutable"
	preset_values = list(TRAIT_IMMUTABLE = -1)

// ATMOSPHERE
/obj/item/computer_hardware/hard_drive/portable/plantgene/atmos
	preset_genetype = GENE_ATMOSPHERE
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/atmos

/obj/item/computer_hardware/hard_drive/portable/plantgene/atmos/low_kpa_tolerance
	trait_info = "low pressure: 40"
	preset_values = list(TRAIT_LOWKPA_TOLERANCE = 40)

/obj/item/computer_hardware/hard_drive/portable/plantgene/atmos/high_kpa_tolerance
	trait_info = "high pressure: 160"
	preset_values = list(TRAIT_HIGHKPA_TOLERANCE = 160)

/obj/item/computer_hardware/hard_drive/portable/plantgene/atmos/heat_tolerance
	trait_info = "heat tolerance: 70"
	preset_values = list(TRAIT_HEAT_TOLERANCE = 70)

// ENVIRONMENT
/obj/item/computer_hardware/hard_drive/portable/plantgene/environment
	preset_genetype = GENE_ENVIRONMENT
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/environment

/obj/item/computer_hardware/hard_drive/portable/plantgene/environment/ideal_heat
	trait_info = "ideal heat: 273 K"
	preset_values = list(TRAIT_IDEAL_HEAT = 273)

/obj/item/computer_hardware/hard_drive/portable/plantgene/environment/light_tolerance
	trait_info = "light tolerance: 10"
	preset_values = list(TRAIT_LIGHT_TOLERANCE = 10)

/obj/item/computer_hardware/hard_drive/portable/plantgene/environment/ideal_light
	trait_info = "ideal light: 10"
	preset_values = list(TRAIT_IDEAL_LIGHT = 10)

// HARDNIESS
/obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness
	preset_genetype = GENE_HARDINESS
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness

/obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness/toxins_tolerance
	trait_info = "toxins tolerance: 7"
	preset_values = list(TRAIT_TOXINS_TOLERANCE = 7)

/obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness/pest_tolerance
	trait_info = "pest tolerance: 7"
	preset_values = list(TRAIT_PEST_TOLERANCE = 7)

/obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness/weed_tolerance
	trait_info = "weed tolerance: 7"
	preset_values = list(TRAIT_WEED_TOLERANCE = 7)

// METABOLISM
/obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism
	preset_genetype = GENE_METABOLISM
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism

/obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism/no_nutrients_water
	trait_info = "requires nutrients/water: FALSE"
	preset_values = list(TRAIT_REQUIRES_NUTRIENTS = 0, TRAIT_REQUIRES_WATER = 0)

/obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism/requires_nutrients
	trait_info = "requires nutrients: TRUE"
	preset_values = list(TRAIT_REQUIRES_NUTRIENTS = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism/requires_water
	trait_info = "requires water: TRUE"
	preset_values = list(TRAIT_REQUIRES_WATER = 1)

// VIGOUR
/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour
	preset_genetype = GENE_VIGOUR
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/vigour

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/yield
	trait_info = "yield: 5"
	preset_values = list(TRAIT_YIELD = 5)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/yield_high
	trait_info = "yield: 10"
	preset_values = list(TRAIT_YIELD = 10)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/yield_max
	trait_info = "yield: 15"
	preset_values = list(TRAIT_YIELD = 15)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/production
	trait_info = "production: 8"
	preset_values = list(TRAIT_PRODUCTION = 5)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/production_high
	trait_info = "production: 5"
	preset_values = list(TRAIT_PRODUCTION = 3)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/production_max
	trait_info = "production: 3"
	preset_values = list(TRAIT_PRODUCTION = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/maturation
	trait_info = "maturation: 8"
	preset_values = list(TRAIT_MATURATION = 5)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/maturation_fast
	trait_info = "maturation: 5"
	preset_values = list(TRAIT_MATURATION = 3)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/maturation_faster
	trait_info = "maturation: 3"
	preset_values = list(TRAIT_MATURATION = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/spreading
	trait_info = "spreading: 1"
	preset_values = list(TRAIT_SPREAD = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/not_spreading
	trait_info = "spreading: 0"
	preset_values = list(TRAIT_SPREAD = 0)

// STRUCTURE
/obj/item/computer_hardware/hard_drive/portable/plantgene/structure
	preset_genetype = GENE_STRUCTURE
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/structure

/obj/item/computer_hardware/hard_drive/portable/plantgene/structure/repeat_harvest
	trait_info = "repeatable harvest"
	preset_values = list(TRAIT_HARVEST_REPEAT = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/structure/single_harvest
	trait_info = "single harvest"
	preset_values = list(TRAIT_HARVEST_REPEAT = 0)

// OUTPUT
/obj/item/computer_hardware/hard_drive/portable/plantgene/output
	preset_genetype = GENE_OUTPUT
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/output

// Power
/obj/item/computer_hardware/hard_drive/portable/plantgene/output/power_producer
	trait_info = "power production: on"
	preset_values = list(TRAIT_PRODUCES_POWER = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/not_power_producer
	trait_info = "power production: off"
	preset_values = list(TRAIT_PRODUCES_POWER = 0)

// Light
/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_off
	trait_info = "bioluminescence: off"
	preset_values = list(TRAIT_BIOLUM = 0)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_dimmer
	trait_info = "bioluminescence: 1"
	preset_values = list(TRAIT_BIOLUM = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_dim
	trait_info = "bioluminescence: 2"
	preset_values = list(TRAIT_BIOLUM = 2)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_normal
	trait_info = "bioluminescence: 3"
	preset_values = list(TRAIT_BIOLUM = 3)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_bright
	trait_info = "bioluminescence: 4"
	preset_values = list(TRAIT_BIOLUM = 4)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_brighter
	trait_info = "bioluminescence: 5"
	preset_values = list(TRAIT_BIOLUM = 5)

// PIGMENT
/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment
	preset_genetype = GENE_PIGMENT
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/pigment

// Light
/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/red
	trait_info = "light color: red, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_RED_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/orange
	trait_info = "light color: orange, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_ORANGE_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/green
	trait_info = "light color: green, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_GREEN_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/cyan
	trait_info = "light color: cyan, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_CYAN_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/blue
	trait_info = "light color: blue, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_BLUE_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/purple
	trait_info = "light color: purple, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_PURPLE_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/red_dark
	trait_info = "light color: red, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_RED_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/orange_dark
	trait_info = "light color: orange, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_ORANGE_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/green_dark
	trait_info = "light color: green, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_GREEN_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/cyan_dark
	trait_info = "light color: cyan, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_CYAN_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/blue_dark
	trait_info = "light color: blue, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_BLUE_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/purple_dark
	trait_info = "light color: purple, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_PURPLE_DARK)
