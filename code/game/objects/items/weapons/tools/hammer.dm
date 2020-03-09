/obj/item/weapon/tool/hammer
	name = "Hammer"
	desc = "Used for applying blunt force to a surface."
	icon_state = "hammer"
	item_state = "hammer"
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFUL
	worksound = WORKSOUND_HAMMER
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 4, MATERIAL_WOOD = 2)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked","flattened","pulped")
	tool_qualities = list(QUALITY_HAMMERING = 30)

/obj/item/weapon/tool/hammer/powered_hammer
	name = "Powered Hammer"
	desc = "Used for applying excessive blunt force to a surface."
	icon_state = "powered_hammer"
	item_state = "powered_hammer"
	switched_on_force = WEAPON_FORCE_DANGEROUS
	structure_damage_factor = STRUCTURE_DAMAGE_BREACHING
	w_class = ITEM_SIZE_BULKY
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTEEL = 6, MATERIAL_PLASTIC = 1)
	switched_on_qualities = list(QUALITY_HAMMERING = 45)
	switched_off_qualities = list(QUALITY_HAMMERING = 30)
	toggleable = TRUE
	armor_penetration = ARMOR_PEN_MODERATE
	toggleable = TRUE
	degradation = 0.7
	use_power_cost = 2
	suitable_cell = /obj/item/weapon/cell/medium
	max_upgrades = 1

/obj/item/weapon/tool/hammer/powered_hammer/onestar_hammer
	name = "One Star hammer"
	desc = "Used for applying immeasurable blunt force to anything in your way."
	icon_state = "onehammer"
	item_state = "onehammer"
	wielded_icon = "onehammer_on"
	switched_on_force = WEAPON_FORCE_BRUTAL
	structure_damage_factor = STRUCTURE_DAMAGE_DESTRUCTIVE
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLATINUM = 3, MATERIAL_DIAMOND = 3)
	switched_on_qualities = list(QUALITY_HAMMERING = 60)
	switched_off_qualities = list(QUALITY_HAMMERING = 35)
	toggleable = TRUE
	armor_penetration = ARMOR_PEN_EXTREME
	degradation = 0.6
	use_power_cost = 1.5
	workspeed = 1.5
	max_upgrades = 2

/obj/item/weapon/tool/hammer/mace
	name = "mace"
	desc = "Used for applying blunt force trauma to a person's ribcage."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "mace"
	item_state = "mace"

	force = WEAPON_FORCE_DANGEROUS

	tool_qualities = list(QUALITY_HAMMERING = 20)

/obj/item/weapon/tool/hammer/mace/makeshift
	name = "makeshift mace"
	desc = "Some metal attached to the end of a stick, for applying blunt force trauma to a roach."
	icon_state = "ghetto_mace"
	item_state = "ghetto_mace"

	force = WEAPON_FORCE_PAINFUL

	tool_qualities = list(QUALITY_HAMMERING = 15)
	degradation = 5 //This one breaks REALLY fast
	max_upgrades = 5 //all makeshift tools get more mods to make them actually viable for mid-late game
