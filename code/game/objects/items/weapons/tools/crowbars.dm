/obj/item/weapon/tool/crowbar
	name = "crowbar"
	desc = "Used to remove floors and to pry open doors."
	icon_state = "crowbar"
	item_state = "crowbar"
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFULL
	worksound = WORKSOUND_EASY_CROWBAR
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 6000)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	tool_qualities = list(QUALITY_PRYING = 3, QUALITY_DIGGING = 1)

/obj/item/weapon/tool/crowbar/pneumatic
	name = "pneumatic crowbar"
	desc = "When you realy need to crack open something."
	icon_state = "pneumo_crowbar"
	item_state = "jackhammer"
	matter = list(MATERIAL_STEEL = 6000, MATERIAL_PLASTIC = 2000)

	use_power_cost = 5
	suitable_cell = /obj/item/weapon/cell/medium
