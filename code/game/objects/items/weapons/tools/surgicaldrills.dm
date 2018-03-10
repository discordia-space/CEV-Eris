/obj/item/weapon/tool/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	matter = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 10000)
	flags = CONDUCT
	force = WEAPON_FORCE_DANGEROUS
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")
	tool_qualities = list(QUALITY_DRILLING = 3)
