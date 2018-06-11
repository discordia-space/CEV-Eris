/obj/item/weapon/tool/wrench
	name = "wrench"
	desc = "A wrench with many common uses. Can be usually found in your hand."
	icon_state = "wrench"
	flags = CONDUCT
	force = WEAPON_FORCE_NORMAL
	worksound = WORKSOUND_WRENCHING
	throwforce = WEAPON_FORCE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 3)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	tool_qualities = list(QUALITY_BOLT_TURNING = 30)

/obj/item/weapon/tool/big_wrench
	name = "big wrench"
	desc = "If everything else failed - bring a bigger wrench."
	icon_state = "big-wrench"
	tool_qualities = list(QUALITY_BOLT_TURNING = 40)
	matter = list(MATERIAL_STEEL = 4)
	force = WEAPON_FORCE_PAINFULL
	throwforce = WEAPON_FORCE_PAINFULL
