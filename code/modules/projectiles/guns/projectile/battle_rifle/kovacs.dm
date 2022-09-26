/obj/item/gun/projectile/kovacs
	name = "SA BR .20 \"Kovacs\""
	desc = "The \"Kovacs\" is a refined battle rifle fit for taking down heavily armoured targets. \
			This extremely efficient rifle design has gone into disuse over the years but still sees use by mercenaries. \
			Uses .20 Rifle rounds."
	icon = 'icons/obj/guns/projectile/kovacs.dmi'
	icon_state = "kovacs"
	item_state = "kovacs"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_SRIFLE
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 1)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE|MAG_WELL_RIFLE_L
	magazine_type = /obj/item/ammo_magazine/srifle
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 12)
	price_tag = 2000
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	damage_multiplier = 1.4
	penetration_multiplier = 0.2
	init_recoil = RIFLE_RECOIL(1)
	zoom_factors = list(0.6)
	fire_delay = 6.5
	gun_parts = list(/obj/item/part/gun/frame/kovacs = 1, /obj/item/part/gun/grip/serb = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/srifle = 1)
	serial_type = "SA"



/obj/item/gun/projectile/kovacs/update_icon()
	..()

	var/iconstring = initial(icon_state)
	iconstring = initial(icon_state) + (ammo_magazine ? "_mag" + (ammo_magazine.mag_well == MAG_WELL_RIFLE_L ? "_l" : (ammo_magazine.mag_well == MAG_WELL_RIFLE_D ? "_d" : "")) : "")

	icon_state = iconstring

/obj/item/gun/projectile/kovacs/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/kovacs
	name = "Kovacs frame"
	desc = "A Kovacs battle rifle frame. To punch through armor with panache."
	icon_state = "frame_kovacs"
	resultvars = list(/obj/item/gun/projectile/kovacs)
	gripvars = list(/obj/item/part/gun/grip/serb)
	mechanismvar = /obj/item/part/gun/mechanism/autorifle
	barrelvars = list(/obj/item/part/gun/barrel/srifle)
