/obj/item/weapon/gun/projectile/mk58
	name = "NT HG .45 \"Mk58\""
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, that was produced by a NanoTrasen subsidiary. Uses .45 rounds."
	icon_state = "mk58"
	item_state = "pistol"
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	price_tag = 1400
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	recoil = 0.5 //regular pistol recoil

/obj/item/weapon/gun/projectile/mk58/update_icon()
	..()

	if(!ammo_magazine)
		icon_state = initial(icon_state)
	else if(!ammo_magazine.stored_ammo.len)
		icon_state = initial(icon_state) + "_empty"
	else
		icon_state = initial(icon_state) + "_full"



/obj/item/weapon/gun/projectile/mk58/wood
	name = "NT HG .45 \"Mk58-C\""
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary. This one has a sweet wooden grip. Uses .45 rounds."
	icon_state = "mk58_wood"
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)
	price_tag = 1500
	recoil = 0.4 //better because that sweet wooden grip
