/obj/item/weapon/tool/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon_state = "shovel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_PAINFULL
	throwforce = WEAPON_FORCE_WEAK
	item_state = "shovel"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 5)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	sharp = 0
	edge = 1
	tool_qualities = list(QUALITY_SHOVELING = 30)

/obj/item/weapon/tool/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 1)
	w_class = ITEM_SIZE_SMALL
	tool_qualities = list(QUALITY_SHOVELING = 20)
