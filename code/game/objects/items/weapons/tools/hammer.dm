/obj/item/weapon/tool/hammer
	name = "Hammer"
	desc = "Used for applying blunt force to a surface."
	icon_state = "hammer"
	item_state = "hammer"
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFUL
	worksound = WORKSOUND_HAMMER
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 4, MATERIAL_WOOD = 2)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked","flattened","pulped")
	tool_qualities = list(QUALITY_HAMMERING = 30)

/obj/item/weapon/tool/hammer/powered_hammer
	name = "Powered Hammer"
	desc = "Used for applying excessive blunt force to a surface."
	icon_state = "powered_hammer"
	item_state = "powered_hammer"
	force = WEAPON_FORCE_DANGEROUS
	structure_damage_factor = STRUCTURE_DAMAGE_BREACHING
	w_class = ITEM_SIZE_BULKY
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTEEL = 6, MATERIAL_PLASTIC = 1)
	tool_qualities = list(QUALITY_HAMMERING = 45)
	degradation = 0.7
	use_power_cost = 0.22
	suitable_cell = /obj/item/weapon/cell/small