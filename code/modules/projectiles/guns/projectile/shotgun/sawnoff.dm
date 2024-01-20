/obj/item/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	icon = 'icons/obj/guns/projectile/sawnshotgun.dmi'
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	can_dual = TRUE
	proj_step_multiplier = 1.1 // becomes 1.2 with slugs, following bolt action sawn off behaviour
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 10)
	volumeClass = ITEM_SIZE_NORMAL
	damage_multiplier = 1 // better to work on recoil and AP than damage (compare to a pistol)
	init_recoil = SMG_RECOIL(3) // with slugs it is 24 recoil (45 is max), and less recoil negation wielded
	twohanded = FALSE
	saw_off = FALSE

