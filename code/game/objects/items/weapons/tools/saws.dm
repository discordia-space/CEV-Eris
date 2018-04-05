/obj/item/weapon/tool/saw
	name = "metal saw"
	desc = "For cutting wood and other objects to pieces. Or sawing bones, in case of emergency."
	icon_state = "metal_saw"
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	worksound = WORKSOUND_SIMPLE_SAW
	flags = CONDUCT
	throw_speed = 3
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 4000, MATERIAL_PLASTIC = 2000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = TRUE
	edge = TRUE
	tool_qualities = list(QUALITY_SAWING = 3, QUALITY_CUTTING = 1, QUALITY_WIRE_CUTTING = 2)

/obj/item/weapon/tool/saw/circular
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon_state = "saw"
	hitsound = WORKSOUND_CIRCULAR_SAW
	worksound = WORKSOUND_CIRCULAR_SAW
	force = WEAPON_FORCE_ROBUST
	matter = list(MATERIAL_STEEL = 4000, MATERIAL_PLASTIC = 2000)
	tool_qualities = list(QUALITY_SAWING = 4, QUALITY_CUTTING = 1, QUALITY_WIRE_CUTTING = 3)

	use_power_cost = 1
	suitable_cell = /obj/item/weapon/cell/small

/obj/item/weapon/tool/saw/advanced_circular
	name = "advanced circular saw"
	desc = "You think you can cut anything with it."
	icon_state = "advanced_saw"
	hitsound = WORKSOUND_CIRCULAR_SAW
	worksound = WORKSOUND_CIRCULAR_SAW
	force = WEAPON_FORCE_ROBUST
	matter = list(MATERIAL_STEEL = 6000, MATERIAL_PLASTIC = 2000)
	tool_qualities = list(QUALITY_SAWING = 5, QUALITY_CUTTING = 1, QUALITY_WIRE_CUTTING = 4)

	use_power_cost = 2
	suitable_cell = /obj/item/weapon/cell/small

/obj/item/weapon/tool/saw/chain
	name = "chainsaw"
	desc = "You can cut trees, people walls and zombies with it, just watch out for fuel."
	icon_state = "chainsaw"
	hitsound = WORKSOUND_CHAINSAW
	worksound = WORKSOUND_CHAINSAW
	force = WEAPON_FORCE_ROBUST
	matter = list(MATERIAL_STEEL = 8000, MATERIAL_PLASTIC = 4000)
	tool_qualities = list(QUALITY_SAWING = 5, QUALITY_CUTTING = 1, QUALITY_WIRE_CUTTING = 2)

	use_fuel_cost = 1
	max_fuel = 80
