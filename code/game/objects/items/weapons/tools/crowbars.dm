/obj/item/weapon/tool/crowbar
	name = "crowbar"
	desc = "Used to remove floors and to pry open doors."
	icon_state = "crowbar"
	item_state = "crowbar"
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFULL
	worksound = WORKSOUND_EASY_CROWBAR
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 50)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	tool_qualities = list(QUALITY_PRYING = 3, QUALITY_DIGGING = 1)
