/obj/item/gun/projectile/automatic/sts35
	name = "OR SDF \"STS-35\""
	desc = "The rugged STS-35 is a durable automatic weapon, made by Oberth Republic Self Defence Force. \
			Extremely efficient rifle design that was put in service right before collapse of the Republic, this weapon can be found almost anywhere in the galaxy by now. \
			Uses .30 Rifle rounds."
	icon = 'icons/obj/guns/projectile/sts.dmi'
	icon_state = "sts"
	item_state = "sts"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_LRIFLE
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 1)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/lrifle
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 12)
	price_tag = 3300
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	damage_multiplier = 1.1
	penetration_multiplier = 0
	init_recoil = RIFLE_RECOIL(0.9)

	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_300,
		BURST_3_ROUND
		)
	gun_parts = list(/obj/item/part/gun/frame/sts35 = 1, /obj/item/part/gun/grip/black = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/lrifle = 1)
	serial_type = "OR"


/obj/item/gun/projectile/automatic/sts35/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "[ammo_magazine? "_mag[ammo_magazine.max_ammo]": ""]"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/automatic/sts35/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/sts35
	name = "STS-35 frame"
	desc = "An STS-35 frame. The finest in kraut space magic."
	icon_state = "frame_orrifle"
	resultvars = list(/obj/item/gun/projectile/automatic/sts35)
	gripvars = list(/obj/item/part/gun/grip/black)
	mechanismvar = /obj/item/part/gun/mechanism/autorifle
	barrelvars = list(/obj/item/part/gun/barrel/lrifle)
