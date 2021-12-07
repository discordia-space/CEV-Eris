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
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/srifle
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 12)
	price_tag = 2000
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	damage_multiplier = 1.2 //30
	penetration_multiplier = 1.4 //35
	recoil_buildup = 2
	one_hand_penalty = 20 //full sized rifle
	zoom_factor = 0.6
	fire_delay = 6.5
	gun_parts = list(/obj/item/part/gun/frame/kovacs = 1, /obj/item/part/gun/grip/serb = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/srifle = 1)



/obj/item/gun/projectile/kovacs/on_update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "[ammo_magazine? "_mag": ""]"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/kovacs/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/kovacs
	name = "Kovacs frame"
	desc = "A Kovacs battle rifle frame. To punch through armor with panache."
	icon_state = "frame_kovacs"
	result = /obj/item/gun/projectile/kovacs
	grip = /obj/item/part/gun/grip/serb
	mechanism = /obj/item/part/gun/mechanism/autorifle
	barrel = /obj/item/part/gun/barrel/srifle
