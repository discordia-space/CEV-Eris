/obj/item/gun/projectile/rpg
	name = "RPG-17"
	desc = "A modified ancient rocket-propelled grenade launcher, this design is centuries old, but well preserved. \
			Modification altered gun mechanism to take much more compact, but sligtly less devastating in close quaters rockets and remove backfire. \
			Their priming and proplusion was altered too for more robust speed, so it has strong recoil."
	icon = 'icons/obj/guns/projectile/rocket.dmi'
	icon_state = "launcher" //placeholder, needs new sprites
	item_state = "launcher" //placeholder, needs new sprites
	volumeClass = ITEM_SIZE_HUGE
	flags = CONDUCT
	slot_flags = SLOT_BACK
	caliber = CAL_ROCKET
	fire_sound = 'sound/effects/bang.ogg' //placeholder, needs new sound
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_PLASTIC = 5, MATERIAL_SILVER = 5)
	price_tag = 8000
	ammo_type = /obj/item/ammo_casing/rocket
	load_method = SINGLE_CASING
	handle_casings = EJECT_CASINGS
	max_shells = 1
	init_recoil = HMG_RECOIL(1) // RPGs tend to be very large
	fire_sound = 'sound/effects/bang.ogg'
	bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg' //placeholder, needs new sound
	twohanded = TRUE
	spawn_blacklisted = TRUE
	wield_delay = 1 SECOND
	wield_delay_factor = 0.8 // 80 vig
	serial_type = "SA"
	move_delay = 5

/obj/item/gun/projectile/rpg/update_icon()
	. = ..()
	cut_overlays()

	var/iconstring = initial(icon_state)

	if (loaded.len)
		iconstring += "_he"

	overlays += iconstring

	update_wear_icon()

/obj/item/gun/projectile/rpg/Initialize()
	. = ..()
	update_icon()
