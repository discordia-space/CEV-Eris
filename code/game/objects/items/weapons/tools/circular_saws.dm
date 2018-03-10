/obj/item/weapon/tool/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon_state = "saw"
	hitsound = WORKSOUND_CIRCULAR_SAW
	worksound = WORKSOUND_CIRCULAR_SAW
	flags = CONDUCT
	force = WEAPON_FORCE_ROBUST
	w_class = ITEM_SIZE_NORMAL
	throwforce = WEAPON_FORCE_WEAK
	throw_speed = 3
	throw_range = 5
	matter = list(MATERIAL_STEEL = 20000,MATERIAL_GLASS = 10000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = TRUE
	edge = TRUE
	tool_qualities = list(QUALITY_SAWING = 4, QUALITY_CUTTING = 1)

/obj/item/weapon/tool/circular_saw/simple
	name = "metal saw"
	desc = "For cutting wood and other objects to pieces. Or sawing bones, in case of emergency."
	icon_state = "metal_saw"
	hitsound = null
	force = WEAPON_FORCE_WEAK
	matter = list(MATERIAL_STEEL = 10000)
	tool_qualities = list(QUALITY_SAWING = 3, QUALITY_CUTTING = 1)

/obj/item/weapon/tool/circular_saw/advanced
	name = "advanced saw"
	desc = "You think you can cut anything with it."
	icon_state = "advanced_saw"
	matter = list(MATERIAL_STEEL = 20000,MATERIAL_GLASS = 10000)
	tool_qualities = list(QUALITY_SAWING = 5, QUALITY_CUTTING = 1)
