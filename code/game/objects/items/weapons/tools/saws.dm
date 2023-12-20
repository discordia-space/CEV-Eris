/obj/item/tool/saw //tier 2
	name = "metal saw"
	desc = "For cutting wood and other objects to pieces. Or sawing bones, in case of emergency."
	icon_state = "metal_saw"
	melleDamages = list(ARMOR_SLASH = list(DELEM(BRUTE,19)))
	throwforce = WEAPON_FORCE_NORMAL
	worksound = WORKSOUND_SIMPLE_SAW
	flags = CONDUCT
	volumeClass = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 1)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharp = TRUE
	edge = TRUE
	forced_broad_strike = TRUE
	tool_qualities = list(QUALITY_SAWING = 30, QUALITY_CUTTING = 20, QUALITY_WIRE_CUTTING = 20)
	embed_mult = 1.3 //Serrated blades catch on bone more easily

/obj/item/tool/saw/improvised //tier 1
	name = "choppa"
	desc = "A wicked serrated blade made of whatever nasty sharp things you could find. It would make a pretty decent weapon, given there are more space for some tool mods too."
	icon_state = "impro_saw"
	melleDamages = list(ARMOR_SLASH = list(DELEM(BRUTE,23)))
	tool_qualities = list(QUALITY_SAWING = 15, QUALITY_CUTTING = 10, QUALITY_WIRE_CUTTING = 10)
	degradation = 1
	maxUpgrades = 5 //all makeshift tools get more mods to make them actually viable for mid-late game
	spawn_tags = SPAWN_TAG_JUNKTOOL
	rarity_value = 3

/obj/item/tool/saw/circular //tier 3
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon_state = "saw"
	hitsound = WORKSOUND_CIRCULAR_SAW
	worksound = WORKSOUND_CIRCULAR_SAW
	melleDamages = list(ARMOR_SLASH = list(DELEM(BRUTE,35)))
	matter = list(MATERIAL_STEEL = 5, MATERIAL_PLASTIC = 2)
	tool_qualities = list(QUALITY_SAWING = 40, QUALITY_CUTTING = 30, QUALITY_WIRE_CUTTING = 30)

	use_power_cost = 0.15
	suitable_cell = /obj/item/cell/small
	spawn_tags = SPAWN_TAG_SURGERY_TOOL

/obj/item/tool/saw/circular/advanced //tier 4, focusing on armor penetration
	name = "advanced circular saw"
	desc = "You think you can cut anything with it."
	icon_state = "advanced_saw"
	melleDamages = list(ARMOR_SLASH = list(DELEM(BRUTE,45)))
	matter = list(MATERIAL_STEEL = 6, MATERIAL_PLASTEEL = 1, MATERIAL_PLASTIC = 2)
	tool_qualities = list(QUALITY_SAWING = 50, QUALITY_CUTTING = 40, QUALITY_WIRE_CUTTING = 40)
	degradation = 0.7
	use_power_cost = 0.22
	maxUpgrades = 4
	spawn_blacklisted = TRUE
	rarity_value = 20

/obj/item/tool/saw/chain //tier 4, focusing on damage, fuel variant
	name = "chainsaw"
	desc = "You can cut trees, people, walls and zombies with it, just watch out for fuel."
	icon_state = "chainsaw"
	hitsound = WORKSOUND_CHAINSAW
	worksound = WORKSOUND_CHAINSAW
	melleDamages = list(ARMOR_SLASH = list(DELEM(BRUTE,30)))
	wieldedMultiplier = 2
	WieldedattackDelay = 10
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 2)
	tool_qualities = list(QUALITY_SAWING = 60, QUALITY_CUTTING = 50, QUALITY_WIRE_CUTTING = 20) //not the best choice to cut wires
	volumeClass = ITEM_SIZE_BULKY
	maxUpgrades = 4
	use_fuel_cost = 0.1
	max_fuel = 80
	rarity_value = 96
	spawn_tags = SPAWN_TAG_TOOL_ADVANCED

/obj/item/tool/saw/hyper //tier 4, focusing on damage, cell variant
	name = "TM hypersaw"
	desc = "This eco-friendly chainsaw will Rip and Tear until it is done."
	icon_state = "hypersaw"
	hitsound = WORKSOUND_CHAINSAW
	worksound = WORKSOUND_CHAINSAW
	matter = list(MATERIAL_SILVER = 2, MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 3)
	tool_qualities = list(QUALITY_SAWING = 60, QUALITY_CUTTING = 50, QUALITY_WIRE_CUTTING = 20)
	volumeClass = ITEM_SIZE_BULKY
	maxUpgrades = 4
	degradation = 0.7
	use_power_cost = 1
	suitable_cell = /obj/item/cell/medium
	rarity_value = 96
	spawn_tags = SPAWN_TAG_TOOL_ADVANCED
