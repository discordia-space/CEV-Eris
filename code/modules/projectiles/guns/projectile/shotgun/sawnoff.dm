/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	icon = 'icons/obj/guns/projectile/sawnshotgun.dmi'
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	can_dual = 1
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 10)
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	damage_multiplier = 0.8 //slightly weaker due to sawn-off barrels
	recoil_buildup = 1.2 //gonna have solid grip on those, point-blank shots adviced
	one_hand_penalty = 10 //compact shotgun level
