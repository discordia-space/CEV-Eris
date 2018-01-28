/obj/item/weapon/tool/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon_state = "saw"
	hitsound = 'sound/weapons/circsawhit.ogg'
	flags = CONDUCT
	force = WEAPON_FORCE_ROBUST
	w_class = ITEM_SIZE_NORMAL
	throwforce = WEAPON_FORCE_WEAK
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 20000,"glass" = 10000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = TRUE
	edge = TRUE
