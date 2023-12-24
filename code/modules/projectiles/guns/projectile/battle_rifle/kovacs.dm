/obj/item/gun/projectile/kovacs
	name = "SA BR .30 \"Kovacs\""
	desc = "The \"Kovacs\" is a refined battle rifle fit for taking down tough targets. \
			This extremely efficient rifle design has gone into disuse over the years but still sees use by mercenaries. \
			Uses .30 Rifle rounds."
	icon = 'icons/obj/guns/projectile/kovacs.dmi'
	icon_state = "kovacs"
	item_state = "kovacs"
	volumeClass = ITEM_SIZE_BULKY
	caliber = CAL_LRIFLE
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 1)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/lrifle
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 12)
	price_tag = 2200
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	damage_multiplier = 1.4
	init_recoil = RIFLE_RECOIL(1.3)
	zoom_factors = list(0.6)
	fire_delay = 6.5
	gun_parts = list(/obj/item/part/gun/frame/kovacs = 1, /obj/item/part/gun/modular/grip/serb = 1, /obj/item/part/gun/modular/mechanism/autorifle/sharpshooter = 1, /obj/item/part/gun/modular/barrel/lrifle = 1)
	serial_type = "SA"



/obj/item/gun/projectile/kovacs/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/kovacs/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/kovacs
	name = "Kovacs frame"
	desc = "A Kovacs battle rifle frame. To punch through people with panache."
	icon_state = "frame_kovacs"
	resultvars = list(/obj/item/gun/projectile/kovacs)
	gripvars = list(/obj/item/part/gun/modular/grip/serb)
	mechanismvar = /obj/item/part/gun/modular/mechanism/autorifle/sharpshooter
	barrelvars = list(/obj/item/part/gun/modular/barrel/lrifle)
