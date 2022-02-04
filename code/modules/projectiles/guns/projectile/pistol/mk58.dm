/obj/item/gun/projectile/mk58
	name = "NT HG .35 Auto \"Mk58\""
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, that was produced by a NanoTrasen subsidiary. Uses standard .35 and high capacity magazines."
	icon = 'icons/obj/guns/projectile/mk58.dmi'
	icon_state = "mk58"
	item_state = "pistol"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	price_tag = 600
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	can_dual = TRUE
	caliber = CAL_PISTOL
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL|MAG_WELL_H_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	damage_multiplier = 1.3
	penetration_multiplier = 1.3
	recoil_buildup = 3
	gun_parts = list(/obj/item/part/gun/frame/mk58 = 1, /obj/item/part/gun/grip/black = 1, /obj/item/part/gun/mechanism/pistol = 1, /obj/item/part/gun/barrel/pistol = 1)

/obj/item/gun/projectile/mk58/update_icon()
	..()

	if(!ammo_magazine)
		icon_state = initial(icon_state)
	else if(!ammo_magazine.stored_ammo.len)
		icon_state = initial(icon_state) + "_empty"
	else
		icon_state = initial(icon_state) + "_full"


/obj/item/gun/projectile/mk58/wood
	name = "NT HG .35 Auto \"Mk58-C\""
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. This one has a sweet wooden grip. Uses standard .35 Auto mags."
	icon_state = "mk58_wood"
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)
	price_tag = 650
	gun_parts = list(/obj/item/part/gun/frame/mk58 = 1, /obj/item/part/gun/grip/wood = 1, /obj/item/part/gun/mechanism/pistol = 1, /obj/item/part/gun/barrel/pistol = 1)

/obj/item/part/gun/frame/mk58
	name = "MK58 frame"
	desc = "A MK58 pistol frame. The standard issue of the Nanotrasen Corporation."
	icon_state = "frame_mk58"
	result = /obj/item/gun/projectile/mk58
	variant_grip = TRUE
	gripvars = list(/obj/item/part/gun/grip/black, /obj/item/part/gun/grip/wood)
	resultvars = list(/obj/item/gun/projectile/mk58, /obj/item/gun/projectile/mk58/wood)
	mechanism = /obj/item/part/gun/mechanism/pistol
	barrel = /obj/item/part/gun/barrel/pistol
