/obj/item/weapon/tool/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon_state = "scalpel"
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

/obj/item/weapon/tool/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	damtype = "fire"
	tool_qualities = list(QUALITY_CUTTING = 4, QUALITY_WIRE_CUTTING = 1, QUALITY_LASER_CUTTING = 4)

/obj/item/weapon/tool/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	icon_state = "scalpel_laser2_on"
	damtype = "fire"
	force = WEAPON_FORCE_DANGEROUS
	tool_qualities = list(QUALITY_CUTTING = 4, QUALITY_WIRE_CUTTING = 1, QUALITY_LASER_CUTTING = 4)

/obj/item/weapon/tool/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	damtype = "fire"
	force = WEAPON_FORCE_DANGEROUS
	tool_qualities = list(QUALITY_CUTTING = 5,  QUALITY_WIRE_CUTTING = 2, QUALITY_LASER_CUTTING = 5)
