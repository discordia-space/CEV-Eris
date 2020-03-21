/obj/item/weapon/tool/hammer //needs new sprite
	name = "hammer"
	desc = "Used for applying blunt force to a surface."
	icon_state = "hammer"
	item_state = "hammer"
	force = WEAPON_FORCE_PAINFUL
	w_class = ITEM_SIZE_SMALL
	worksound = WORKSOUND_HAMMER
	flags = CONDUCT
	origin_tech = list(TECH_ENGINEERING = 1)
	tool_qualities = list(QUALITY_HAMMERING = 20)
	matter = list(MATERIAL_STEEL = 4, MATERIAL_WOOD = 2)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked","flattened","pulped")

/obj/item/weapon/tool/hammer/homewrecker
	name = "homewrecker"
	desc = "A large steel chunk welded to a long handle which resembles sledgehammer. Extremely heavy."
	icon_state = "homewrecker"
	item_state = "homewrecker"
	wielded_icon = "homewrecker1"
	structure_damage_factor = STRUCTURE_DAMAGE_HEAVY
	armor_penetration = ARMOR_PEN_DEEP
	force_unwielded = WEAPON_FORCE_NORMAL
	force_wielded = WEAPON_FORCE_DANGEROUS
	w_class = ITEM_SIZE_HUGE
	tool_qualities = list(QUALITY_HAMMERING = 15)
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTIC = 1)
	max_upgrades = 5

/obj/item/weapon/tool/hammer/powered_hammer //to be made into proper two-handed tool as small "powered" hammer doesn't make sense
	name = "powered hammer"					//lacks normal sprites, both icon, item and twohanded for this
	desc = "Used for applying excessive blunt force to a surface. Powered edition."
	icon_state = "powered_hammer"
	item_state = "powered_hammer"
	structure_damage_factor = STRUCTURE_DAMAGE_BREACHING
	armor_penetration = ARMOR_PEN_MODERATE
	force = WEAPON_FORCE_DANGEROUS
	w_class = ITEM_SIZE_HUGE
	tool_qualities = list(QUALITY_HAMMERING = 30)
	matter = list(MATERIAL_STEEL = 5, MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 1)
	degradation = 0.7
	use_power_cost = 2
	suitable_cell = /obj/item/weapon/cell/medium
	max_upgrades = 4

/obj/item/weapon/tool/hammer/powered_hammer/onestar_hammer
	name = "One Star sledgehammer"
	desc = "Famous sledgehammer model made by One Star used for applying immeasurable blunt force to anything in your way. Could breach even toughest obstracles and crack most resilent skulls."
	icon_state = "onehammer"
	item_state = "onehammer"
	wielded_icon = "onehammer_on"
	structure_damage_factor = STRUCTURE_DAMAGE_DESTRUCTIVE
	armor_penetration = ARMOR_PEN_EXTREME
	force_unwielded = WEAPON_FORCE_DANGEROUS
	force_wielded = WEAPON_FORCE_BRUTAL
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLATINUM = 5, MATERIAL_DIAMOND = 5)
	tool_qualities = list(QUALITY_HAMMERING = 50)
	degradation = 0.6
	use_power_cost = 1.5
	workspeed = 1.5
	max_upgrades = 2
