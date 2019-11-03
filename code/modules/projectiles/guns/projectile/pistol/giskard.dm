/obj/item/weapon/gun/projectile/giskard
	name = "FS HG .32 \"Giskard\""
	desc = "That's the \"Frozen Star\" popular non-lethal pistol. Can even fit into the pocket! Uses .32 rounds."
	icon_state = "giskard"
	item_state = "pistol"
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	silencer_type = /obj/item/weapon/silencer
	caliber = ".32"
	ammo_mag = "mag_cl32"
	w_class = ITEM_SIZE_SMALL
	fire_delay = 0.6
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_WOOD = 4)
	price_tag = 600
	recoil = 0.2 //peashooter tier gun

/obj/item/weapon/gun/projectile/giskard/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = initial(item_state)

	if (ammo_magazine)
		iconstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if (silenced)
		iconstring += "_s"
		itemstring += "_s"

	icon_state = iconstring
	item_state = itemstring

/obj/item/weapon/gun/projectile/giskard/Initialize()
	. = ..()
	update_icon()