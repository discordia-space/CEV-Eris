/obj/item/gun/projectile/rpg
	name = "RPG-17"
	desc = "A69odified ancient rocket-propelled grenade launcher, this design is centuries old, but well preserved. \
			Modification altered gun69echanism to take69uch69ore compact, but sligtly less devastating in close 69uaters rockets and remove backfire. \
			Their priming and proplusion was altered too for69ore robust speed, so it has strong recoil."
	icon = 'icons/obj/guns/projectile/rocket.dmi'
	icon_state = "launcher" //placeholder,69eeds69ew sprites
	item_state = "launcher" //placeholder,69eeds69ew sprites
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	flags = CONDUCT
	slot_flags = SLOT_BACK
	caliber = CAL_ROCKET
	fire_sound = 'sound/effects/bang.ogg' //placeholder,69eeds69ew sound
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	matter = list(MATERIAL_PLASTEEL = 30,69ATERIAL_PLASTIC = 5,69ATERIAL_SILVER = 5)
	price_tag = 8000
	ammo_type = /obj/item/ammo_casing/rocket
	load_method = SINGLE_CASING
	handle_casings = EJECT_CASINGS
	max_shells = 1
	one_hand_penalty = 1
	recoil_buildup = 0.2 //with69ew system it gives slight chance to69iss but69ot really
	fire_sound = 'sound/effects/bang.ogg'
	bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg' //placeholder,69eeds69ew sound
	twohanded = TRUE
	spawn_blacklisted = TRUE
	wield_delay = 1 SECOND
	wield_delay_factor = 0.8 // 8069ig

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
