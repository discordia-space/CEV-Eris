/obj/item/computer_hardware/hard_drive/portable/plantgene
	disk_name = "plant gene disk"
	rarity_value = 40
	spawn_tags = SPAWN_TAG_PLANT_GENE_DISK
	spawn_blacklisted = TRUE	// Trade beacons or off-ship loot
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene	// Base type has no gene info
	price_tag = 25
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

	disk_name += " ([plant_name] #[plant_id])"
	. = ..()

// Light
/obj/item/computer_hardware/hard_drive/portable/plantgene/power_producer
	preset_genetype = GENE_BIOCHEMISTRY
	preset_values = list(TRAIT_PRODUCES_POWER = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/bioluminescent
	preset_genetype = GENE_BIOCHEMISTRY
	preset_values = list(TRAIT_BIOLUM = 3)

/obj/item/computer_hardware/hard_drive/portable/plantgene/bioluminescent/dim
	preset_values = list(TRAIT_BIOLUM = 1)

/obj/item/computer_hardware/hard_drive/portable/plantgene/bioluminescent/bright
	preset_values = list(TRAIT_BIOLUM = 5)

// Light colors
/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color
	preset_genetype = GENE_PIGMENT
	bad_type = /obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/red
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_RED_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/orange
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_ORANGE_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/green
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_GREEN_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/cyan
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_CYAN_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/blue
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_BLUE_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/purple
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_PURPLE_BRIGHT)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/red_dark
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_RED_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/orange_dark
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_ORANGE_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/green_dark
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_GREEN_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/cyan_dark
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_CYAN_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/blue_dark
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_BLUE_DARK)

/obj/item/computer_hardware/hard_drive/portable/plantgene/biolum_color/purple_dark
	preset_values = list(TRAIT_BIOLUM_COLOUR = COLOR_LIGHTING_PURPLE_DARK)
