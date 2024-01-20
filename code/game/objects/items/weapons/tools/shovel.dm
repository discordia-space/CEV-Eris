/obj/item/tool/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt and rock."
	icon_state = "shovel"
	item_state = "shovel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,20)))
	wieldedMultiplier = 1.5
	attackDelay = 4
	/// chunky like junk blade
	WieldedattackDelay = 6
	throwforce = 19
	volumeClass = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 5)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	hitsound = 'sound/weapons/melee/blunthit.ogg'
	sharp = FALSE
	edge = TRUE
	tool_qualities = list(QUALITY_SHOVELING = 30, QUALITY_DIGGING = 30, QUALITY_EXCAVATION = 10, QUALITY_HAMMERING = 10)
	rarity_value = 9.6

/obj/item/tool/shovel/improvised
	name = "junk shovel"
	desc = "A large but fragile tool for moving dirt and rock, made by hand. Has more than enough space for tool mods to make it better."
	icon_state = "impro_shovel"
	tool_qualities = list(QUALITY_SHOVELING = 25, QUALITY_DIGGING = 25, QUALITY_EXCAVATION = 10, QUALITY_HAMMERING = 10)
	degradation = 1.5
	maxUpgrades = 5 //all makeshift tools get more mods to make them actually viable for mid-late game
	rarity_value = 5
	spawn_tags = SPAWN_TAG_JUNKTOOL

/obj/item/tool/shovel/spade
	name = "spade"
	desc = "A small tool ofter used for simple gardening task such as digging soil and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,10)))
	throwforce = 10
	armor_divisor = 1.2
	volumeClass = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 1)
	tool_qualities = list(QUALITY_SHOVELING = 20, QUALITY_DIGGING = 20, QUALITY_EXCAVATION = 10,QUALITY_HAMMERING = 10)
	maxUpgrades = 2
	rarity_value = 19.2

/obj/item/tool/shovel/power
	name = "power shovel 9000"
	desc = "A powered shovel for all your dumpster diving needs."
	icon_state = "powershovel"
	item_state = "shovel"
	melleDamages = list(ARMOR_BLUNT = list(DELEM(BRUTE,12)))
	wieldedMultiplier = 4
	WieldedattackDelay = 20
	throwforce = 5
	armor_divisor = 1.1
	volumeClass = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_PLASTEEL = 6,  MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 1)
	tool_qualities = list(QUALITY_SHOVELING = 60, QUALITY_DIGGING = 40, QUALITY_EXCAVATION = 20, QUALITY_HAMMERING = 15)
	use_power_cost = 0.8
	degradation = 0.7
	maxUpgrades = 4
	suitable_cell = /obj/item/cell/medium
	rarity_value = 48
