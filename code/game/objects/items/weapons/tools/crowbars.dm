/obj/item/weapon/tool/crowbar
	name = "crowbar"
	desc = "Used to remove floors and to pry open doors."
	icon_state = "red_crowbar"
	item_state = "crowbar_red"
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFULL
	worksound = WORKSOUND_EASY_CROWBAR
	item_state = "crowbar"
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	tool_qualities = list(QUALITY_PRYING = 3, QUALITY_DIGGING = 1)
