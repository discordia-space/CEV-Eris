/obj/item/tool/shovel
	name = "shovel"
	desc = "A large tool for digging and69oving dirt and rock."
	icon_state = "shovel"
	item_state = "shovel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_WEAK
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 5)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	hitsound = 'sound/weapons/melee/blunthit.ogg'
	sharp = FALSE
	edge = TRUE
	tool_69ualities = list(69UALITY_SHOVELING = 30, 69UALITY_DIGGING = 30, 69UALITY_EXCAVATION = 10, 69UALITY_HAMMERING = 10)
	rarity_value = 9.6

/obj/item/tool/shovel/improvised
	name = "junk shovel"
	desc = "A large but fragile tool for69oving dirt and rock,69ade by hand. Has69ore than enough space for tool69ods to69ake it better."
	icon_state = "impro_shovel"
	tool_69ualities = list(69UALITY_SHOVELING = 25, 69UALITY_DIGGING = 25, 69UALITY_EXCAVATION = 10, 69UALITY_HAMMERING = 10)
	degradation = 1.5
	max_upgrades = 5 //all69akeshift tools get69ore69ods to69ake them actually69iable for69id-late game
	rarity_value = 5
	spawn_tags = SPAWN_TAG_JUNKTOOL

/obj/item/tool/shovel/spade
	name = "spade"
	desc = "A small tool ofter used for simple gardening task such as digging soil and69oving dirt."
	icon_state = "spade"
	item_state = "spade"
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_PLASTIC = 1)
	tool_69ualities = list(69UALITY_SHOVELING = 20, 69UALITY_DIGGING = 20, 69UALITY_EXCAVATION = 10,69UALITY_HAMMERING = 10)
	max_upgrades = 2
	rarity_value = 19.2

/obj/item/tool/shovel/power
	name = "power shovel 9000"
	desc = "A powered shovel for all your dumpster diving needs."
	icon_state = "powershovel"
	item_state = "shovel"
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_WEAK
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_PLASTEEL = 6, 69ATERIAL_STEEL = 3,69ATERIAL_PLASTIC = 1)
	tool_69ualities = list(69UALITY_SHOVELING = 60, 69UALITY_DIGGING = 40, 69UALITY_EXCAVATION = 20, 69UALITY_HAMMERING = 15)
	use_power_cost = 0.8
	degradation = 0.7
	max_upgrades = 4
	suitable_cell = /obj/item/cell/medium
	rarity_value = 48
