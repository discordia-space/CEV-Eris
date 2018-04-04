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
	matter = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 5000)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	tool_qualities = list(QUALITY_CUTTING = 3, QUALITY_WIRE_CUTTING = 1)

/obj/item/weapon/tool/scalpel/advanced
	name = "advanced scalpel"
	desc = "Made of more expensive materials, sharper and generally more reliable."
	icon_state = "scalpel_t4"
	tool_qualities = list(QUALITY_CUTTING = 4, QUALITY_WIRE_CUTTING = 1)

/obj/item/weapon/tool/scalpel/laser
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field."
	icon_state = "scalpel_t5"
	damtype = "fire"
	force = WEAPON_FORCE_DANGEROUS
	tool_qualities = list(QUALITY_CUTTING = 5, QUALITY_WIRE_CUTTING = 2, QUALITY_LASER_CUTTING = 4)

	use_power_cost = 1
	suitable_cell = /obj/item/weapon/cell/small
