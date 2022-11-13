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

	disk_name = "[plant_name] #[plant_id] ([trait_info])"
	. = ..()

// BIOCHEMISTRY
/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry
	preset_genetype = GENE_BIOCHEMISTRY
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/potency
	disk_name = "plant gene disk - potency: 50"	// Needed for vendor names
	trait_info = "potency: 50"
	preset_values = list(TRAIT_POTENCY = 50)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/potency_high
	disk_name = "plant gene disk - potency: 100"
	trait_info = "potency: 100"
	preset_values = list(TRAIT_POTENCY = 100)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/potency_max
	disk_name = "plant gene disk - potency: 200"
	trait_info = "potency: 200"
	preset_values = list(TRAIT_POTENCY = 200)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/psilocybin
	disk_name = "plant gene disk - psilocybin-producing"
	trait_info = "psilocybin-producing"
	preset_values = list(TRAIT_CHEMS = list("psilocybin" = list(5,4)))

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/mutagen
	disk_name = "plant gene disk - mutagen-producing"
	trait_info = "mutagen-producing"
	preset_values = list(TRAIT_CHEMS = list("mutagen" = list(3,5)))

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/cleaner
	disk_name = "plant gene disk - cleaner-producing"
	trait_info = "cleaner-producing"
	preset_values = list(TRAIT_CHEMS = list("cleaner" = list(3,5)))

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/eznutrient
	disk_name = "plant gene disk - E-Z-nutrient-producing"
	trait_info = "E-Z-nutrient-producing"
	preset_values = list(TRAIT_CHEMS = list("eznutrient" = list(3,5)))

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/left4zed
	disk_name = "plant gene disk - Left 4 Zed-producing"
	trait_info = "Left 4 Zed-producing"
	preset_values = list(TRAIT_CHEMS = list("left4zed" = list(3,5)))

/obj/item/computer_hardware/hard_drive/portable/plantgene/biochemistry/robustharvest
	disk_name = "plant gene disk - Robust Harvest-producing"
	trait_info = "Robust Harvest-producing"
	preset_values = list(TRAIT_CHEMS = list("robustharvest" = list(3,5)))

// ATMOSPHERE
/obj/item/computer_hardware/hard_drive/portable/plantgene/atmos
	preset_genetype = GENE_ATMOSPHERE
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/atmos

/obj/item/computer_hardware/hard_drive/portable/plantgene/atmos/low_kpa_tolerance
	disk_name = "plant gene disk - low pressure: 40"
	trait_info = "low pressure: 40"
	preset_values = list(TRAIT_LOWKPA_TOLERANCE = 40)

/obj/item/computer_hardware/hard_drive/portable/plantgene/atmos/high_kpa_tolerance
	disk_name = "plant gene disk - high pressure: 160"
	trait_info = "high pressure: 160"
	preset_values = list(TRAIT_HIGHKPA_TOLERANCE = 160)

/obj/item/computer_hardware/hard_drive/portable/plantgene/atmos/heat_tolerance
	disk_name = "plant gene disk - heat tolerance: 70"
	trait_info = "heat tolerance: 70"
	preset_values = list(TRAIT_HEAT_TOLERANCE = 70)

// ENVIRONMENT
/obj/item/computer_hardware/hard_drive/portable/plantgene/environment
	preset_genetype = GENE_ENVIRONMENT
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/environment

/obj/item/computer_hardware/hard_drive/portable/plantgene/environment/ideal_heat
	disk_name = "plant gene disk - ideal heat: 273 K"
	trait_info = "ideal heat: 273 K"
	preset_values = list(TRAIT_IDEAL_HEAT = 273)

/obj/item/computer_hardware/hard_drive/portable/plantgene/environment/light_tolerance
	disk_name = "plant gene disk - light tolerance: 10"
	trait_info = "light tolerance: 10"
	preset_values = list(TRAIT_LIGHT_TOLERANCE = 10)

/obj/item/computer_hardware/hard_drive/portable/plantgene/environment/ideal_light
	disk_name = "plant gene disk - ideal light: 10"
	trait_info = "ideal light: 10"
	preset_values = list(TRAIT_IDEAL_LIGHT = 10)

// HARDNIESS
/obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness
	preset_genetype = GENE_HARDINESS
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness

/obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness/toxins_tolerance
	disk_name = "plant gene disk - toxins tolerance: 7"
	trait_info = "toxins tolerance: 7"
	preset_values = list(TRAIT_TOXINS_TOLERANCE = 7)

/obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness/pest_tolerance
	disk_name = "plant gene disk - pest tolerance: 7"
	trait_info = "pest tolerance: 7"
	preset_values = list(TRAIT_PEST_TOLERANCE = 7)

/obj/item/computer_hardware/hard_drive/portable/plantgene/hardiness/weed_tolerance
	disk_name = "plant gene disk - weed tolerance: 7"
	trait_info = "weed tolerance: 7"
	preset_values = list(TRAIT_WEED_TOLERANCE = 7)

// METABOLISM
/obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism
	preset_genetype = GENE_METABOLISM
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism

/obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism/no_nutrients_water
	disk_name = "plant gene disk - requires nutrients/water: FALSE"
	trait_info = "requires nutrients/water: FALSE"
	preset_values = list(TRAIT_REQUIRES_NUTRIENTS = 0, TRAIT_REQUIRES_WATER = 0)

/obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism/requires_nutrients
	disk_name = "plant gene disk - requires nutrients: TRUE"
	trait_info = "requires nutrients: TRUE"
	preset_values = list(TRAIT_REQUIRES_NUTRIENTS = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/metabolism/requires_water
	disk_name = "plant gene disk - requires water: TRUE"
	trait_info = "requires water: TRUE"
	preset_values = list(TRAIT_REQUIRES_WATER = 1)

// DIET
/obj/item/computer_hardware/hard_drive/portable/plantgene/diet
	preset_genetype = GENE_DIET
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/diet

/obj/item/computer_hardware/hard_drive/portable/plantgene/diet/carnivorous
	disk_name = "plant gene disk - carnivorous"
	trait_info = "carnivorous"
	preset_values = list(TRAIT_CARNIVOROUS = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/diet/noncarnivorous
	disk_name = "plant gene disk - non-carnivorous"
	trait_info = "non-carnivorous"
	preset_values = list(TRAIT_CARNIVOROUS = 0)

/obj/item/computer_hardware/hard_drive/portable/plantgene/diet/parasitic
	disk_name = "plant gene disk - parasitic"
	trait_info = "parasitic"
	preset_values = list(TRAIT_PARASITE = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/diet/nonparasitic
	disk_name = "plant gene disk - non-parasitic"
	trait_info = "non-parasitic"
	preset_values = list(TRAIT_PARASITE = 0)

// VIGOUR
/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour
	preset_genetype = GENE_VIGOUR
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/vigour

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/yield
	disk_name = "plant gene disk - yield: 5"
	trait_info = "yield: 5"
	preset_values = list(TRAIT_YIELD = 5)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/yield_high
	disk_name = "plant gene disk - yield: 10"
	trait_info = "yield: 10"
	preset_values = list(TRAIT_YIELD = 10)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/yield_max
	disk_name = "plant gene disk - yield: 15"
	trait_info = "yield: 15"
	preset_values = list(TRAIT_YIELD = 15)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/production
	disk_name = "plant gene disk - production: 5"
	trait_info = "production: 5"
	preset_values = list(TRAIT_PRODUCTION = 5)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/production_high
	disk_name = "plant gene disk - production: 3"
	trait_info = "production: 3"
	preset_values = list(TRAIT_PRODUCTION = 3)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/production_max
	disk_name = "plant gene disk - production: 1"
	trait_info = "production: 1"
	preset_values = list(TRAIT_PRODUCTION = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/maturation
	disk_name = "plant gene disk - maturation: 5"
	trait_info = "maturation: 5"
	preset_values = list(TRAIT_MATURATION = 5)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/maturation_fast
	disk_name = "plant gene disk - maturation: 3"
	trait_info = "maturation: 3"
	preset_values = list(TRAIT_MATURATION = 3)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/maturation_faster
	disk_name = "plant gene disk - maturation: 1"
	trait_info = "maturation: 1"
	preset_values = list(TRAIT_MATURATION = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/spreading
	disk_name = "plant gene disk - spreading: 1"
	trait_info = "spreading: 1"
	preset_values = list(TRAIT_SPREAD = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/vine_spreading
	disk_name = "plant gene disk - spreading: 2"
	trait_info = "spreading: 2"
	preset_values = list(TRAIT_SPREAD = 2)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/not_spreading
	disk_name = "plant gene disk - spreading: 0"
	trait_info = "spreading: 0"
	preset_values = list(TRAIT_SPREAD = 0)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/wall_hugger
	disk_name = "plant gene disk - wall growth"
	trait_info = "wall growth"
	preset_values = list(TRAIT_WALL_HUGGER = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/vigour/non_wall_hugger
	disk_name = "plant gene disk - no wall growth"
	trait_info = "no wall growth"
	preset_values = list(TRAIT_WALL_HUGGER = 0)

// STRUCTURE
/obj/item/computer_hardware/hard_drive/portable/plantgene/structure
	preset_genetype = GENE_STRUCTURE
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/structure

/obj/item/computer_hardware/hard_drive/portable/plantgene/structure/repeat_harvest
	disk_name = "plant gene disk - repeatable harvest"
	trait_info = "repeatable harvest"
	preset_values = list(TRAIT_HARVEST_REPEAT = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/structure/single_harvest
	disk_name = "plant gene disk - single harvest"
	trait_info = "single harvest"
	preset_values = list(TRAIT_HARVEST_REPEAT = 0)

// OUTPUT
/obj/item/computer_hardware/hard_drive/portable/plantgene/output
	preset_genetype = GENE_OUTPUT
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/output

// Power
/obj/item/computer_hardware/hard_drive/portable/plantgene/output/power_producer
	disk_name = "plant gene disk - power production: on"
	trait_info = "power production: on"
	preset_values = list(TRAIT_PRODUCES_POWER = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/not_power_producer
	disk_name = "plant gene disk - power production: off"
	trait_info = "power production: off"
	preset_values = list(TRAIT_PRODUCES_POWER = 0)

// Light
/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_off
	disk_name = "plant gene disk - bioluminescence: off"
	trait_info = "bioluminescence: off"
	preset_values = list(TRAIT_BIOLUM = 0)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_dimmer
	disk_name = "plant gene disk - bioluminescence: 1"
	trait_info = "bioluminescence: 1"
	preset_values = list(TRAIT_BIOLUM = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_dim
	disk_name = "plant gene disk - bioluminescence: 2"
	trait_info = "bioluminescence: 2"
	preset_values = list(TRAIT_BIOLUM = 2)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_normal
	disk_name = "plant gene disk - bioluminescence: 3"
	trait_info = "bioluminescence: 3"
	preset_values = list(TRAIT_BIOLUM = 3)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_bright
	disk_name = "plant gene disk - bioluminescence: 4"
	trait_info = "bioluminescence: 4"
	preset_values = list(TRAIT_BIOLUM = 4)

/obj/item/computer_hardware/hard_drive/portable/plantgene/output/bioluminescent_brighter
	disk_name = "plant gene disk - bioluminescence: 5"
	trait_info = "bioluminescence: 5"
	preset_values = list(TRAIT_BIOLUM = 5)

// PIGMENT
/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment
	preset_genetype = GENE_PIGMENT
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/pigment

// Light
/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/red
	disk_name = "plant gene disk - light color: red, bright"
	trait_info = "light color: red, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_RED_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/orange
	disk_name = "plant gene disk - light color: orange, bright"
	trait_info = "light color: orange, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_ORANGE_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/green
	disk_name = "plant gene disk - light color: green, bright"
	trait_info = "light color: green, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_GREEN_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/cyan
	disk_name = "plant gene disk - light color: cyan, bright"
	trait_info = "light color: cyan, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_CYAN_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/blue
	disk_name = "plant gene disk - light color: blue, bright"
	trait_info = "light color: blue, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_BLUE_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/purple
	disk_name = "plant gene disk - light color: purple, bright"
	trait_info = "light color: purple, bright"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_PURPLE_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/red_dark
	disk_name = "plant gene disk - light color: red, dark"
	trait_info = "light color: red, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_RED_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/orange_dark
	disk_name = "plant gene disk - light color: orange, dark"
	trait_info = "light color: orange, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_ORANGE_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/green_dark
	disk_name = "plant gene disk - light color: green, dark"
	trait_info = "light color: green, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_GREEN_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/cyan_dark
	disk_name = "plant gene disk - light color: cyan, dark"
	trait_info = "light color: cyan, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_CYAN_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/blue_dark
	disk_name = "plant gene disk - light color: blue, dark"
	trait_info = "light color: blue, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_BLUE_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/pigment/purple_dark
	disk_name = "plant gene disk - light color: purple, dark"
	trait_info = "light color: purple, dark"
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_PURPLE_DARK)

// SPECIAL
/obj/item/computer_hardware/hard_drive/portable/plantgene/special
	preset_genetype = GENE_SPECIAL
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/special

/obj/item/computer_hardware/hard_drive/portable/plantgene/special/immutable
	disk_name = "plant gene disk - immutable"
	trait_info = "immutable"
	preset_values = list(TRAIT_IMMUTABLE = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/special/mutable
	disk_name = "plant gene disk - mutable"
	trait_info = "mutable"
	preset_values = list(TRAIT_IMMUTABLE = 0)

/obj/item/computer_hardware/hard_drive/portable/plantgene/special/highly_mutable
	disk_name = "plant gene disk - highly mutable"
	trait_info = "highly mutable"
	preset_values = list(TRAIT_IMMUTABLE = -1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/special/chem_sprayer
	disk_name = "plant gene disk - chemical sprayer"
	trait_info = "chemical sprayer"
	preset_values = list(TRAIT_CHEM_SPRAYER = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/special/no_chem_sprayer
	disk_name = "plant gene disk - non-sprayer"
	trait_info = "non-sprayer"
	preset_values = list(TRAIT_CHEM_SPRAYER = 0)
