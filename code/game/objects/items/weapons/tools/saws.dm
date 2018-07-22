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
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 1)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = TRUE
	edge = TRUE
	tool_qualities = list(QUALITY_SAWING = 30, QUALITY_CUTTING = 10, QUALITY_WIRE_CUTTING = 20)

/obj/item/weapon/tool/saw/circular
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon_state = "saw"
	hitsound = WORKSOUND_CIRCULAR_SAW
	worksound = WORKSOUND_CIRCULAR_SAW
	force = WEAPON_FORCE_ROBUST
	matter = list(MATERIAL_STEEL = 5, MATERIAL_PLASTIC = 2)
	tool_qualities = list(QUALITY_SAWING = 40, QUALITY_CUTTING = 10, QUALITY_WIRE_CUTTING = 30)

	use_power_cost = 1
	suitable_cell = /obj/item/weapon/cell/small

/obj/item/weapon/tool/saw/advanced_circular
	name = "advanced circular saw"
	desc = "You think you can cut anything with it."
	icon_state = "advanced_saw"
	hitsound = WORKSOUND_CIRCULAR_SAW
	worksound = WORKSOUND_CIRCULAR_SAW
	force = WEAPON_FORCE_ROBUST
	matter = list(MATERIAL_STEEL = 6, MATERIAL_PLASTIC = 2)
	tool_qualities = list(QUALITY_SAWING = 50, QUALITY_CUTTING = 10, QUALITY_WIRE_CUTTING = 40)

	use_power_cost = 2
	suitable_cell = /obj/item/weapon/cell/small

/obj/item/weapon/tool/saw/chain
	name = "chainsaw"
	desc = "You can cut trees, people walls and zombies with it, just watch out for fuel."
	icon_state = "chainsaw"
	hitsound = WORKSOUND_CHAINSAW
	worksound = WORKSOUND_CHAINSAW
	force = WEAPON_FORCE_ROBUST
	matter = list(MATERIAL_STEEL = 8, MATERIAL_PLASTIC = 3)
	tool_qualities = list(QUALITY_SAWING = 50, QUALITY_CUTTING = 10, QUALITY_WIRE_CUTTING = 20)

	use_fuel_cost = 1
	max_fuel = 80
