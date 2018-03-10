/obj/item/weapon/tool/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon_state = "drill"
	hitsound = WORKSOUND_DRIVER_TOOL
	worksound = WORKSOUND_DRIVER_TOOL
	matter = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 10000)
	flags = CONDUCT
	force = WEAPON_FORCE_DANGEROUS
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")
	tool_qualities = list(QUALITY_DRILLING = 3)
