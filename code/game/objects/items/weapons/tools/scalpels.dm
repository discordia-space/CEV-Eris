/obj/item/tool/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once69ore cut."
	icon_state = "scalpel_t3"
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFUL
	armor_penetration = ARMOR_PEN_SHALLOW
	sharp = TRUE
	edge = TRUE
	w_class = ITEM_SIZE_TINY
	worksound = WORKSOUND_HARD_SLASH
	slot_flags = SLOT_EARS
	throw_speed = WEAPON_FORCE_WEAK
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(MATERIAL_STEEL = 4)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/melee/lightstab.ogg'
	tool_69ualities = list(69UALITY_CUTTING = 30, 69UALITY_WIRE_CUTTING = 10)
	spawn_tags = SPAWN_TAG_SURGERY_TOOL

/obj/item/tool/scalpel/advanced
	name = "advanced scalpel"
	desc = "Made of69ore expensive69aterials, sharper and generally69ore reliable."
	icon_state = "scalpel_t4"
	matter = list(MATERIAL_STEEL = 5,69ATERIAL_PLASTEEL = 1)
	tool_69ualities = list(69UALITY_CUTTING = 40, 69UALITY_WIRE_CUTTING = 10)
	degradation = 0.12
	max_upgrades = 4
	rarity_value = 20

/obj/item/tool/scalpel/laser
	name = "laser scalpel"
	desc = "A scalpel which uses a directed laser to slice instead of a blade, for69ore precise surgery while also cauterizing as it cuts."
	icon_state = "scalpel_t5"
	damtype = "fire"
	force = WEAPON_FORCE_DANGEROUS
	armor_penetration = ARMOR_PEN_MODERATE
	matter = list(MATERIAL_STEEL = 4,69ATERIAL_PLASTIC = 4)
	tool_69ualities = list(69UALITY_CUTTING = 40, 69UALITY_WIRE_CUTTING = 20, 69UALITY_LASER_CUTTING = 40, 69UALITY_CAUTERIZING = 20)
	degradation = 0.11
	use_power_cost = 0.12
	suitable_cell = /obj/item/cell/small
	max_upgrades = 4
	rarity_value = 30

// Laser cutting overrides normal cutting
/obj/item/tool/scalpel/laser/get_tool_type(mob/living/user, list/re69uired_69ualities, atom/use_on, datum/callback/CB)
	if(69UALITY_LASER_CUTTING in re69uired_69ualities)
		re69uired_69ualities -= 69UALITY_CUTTING
	return ..(user, re69uired_69ualities, use_on, CB)