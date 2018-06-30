/obj/item/weapon/tool/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon_state = "scalpel_t3"
	flags = CONDUCT
	force = WEAPON_FORCE_DANGEROUS
	sharp = TRUE
	edge = TRUE
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	throw_speed = WEAPON_FORCE_WEAK
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(MATERIAL_STEEL = 4)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	tool_qualities = list(QUALITY_CUTTING = 30, QUALITY_WIRE_CUTTING = 10)

/obj/item/weapon/tool/scalpel/advanced
	name = "advanced scalpel"
	desc = "Made of more expensive materials, sharper and generally more reliable."
	icon_state = "scalpel_t4"
	matter = list(MATERIAL_STEEL = 5)
	tool_qualities = list(QUALITY_CUTTING = 40, QUALITY_WIRE_CUTTING = 10)

/obj/item/weapon/tool/scalpel/laser
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field."
	icon_state = "scalpel_t5"
	damtype = "fire"
	force = WEAPON_FORCE_DANGEROUS
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTIC = 4)
	tool_qualities = list(QUALITY_CUTTING = 50, QUALITY_WIRE_CUTTING = 20, QUALITY_LASER_CUTTING = 40)

	use_power_cost = 1
	suitable_cell = /obj/item/weapon/cell/small
