/obj/item/gun/projectile/heavysniper
	name = "SA AMR .60 \"Hristov\""
	desc = "A portable anti-armour rifle, fitted with a night-vision scope, it was originally designed for use against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease, but suffers from overpenetration at close range. Fires armor piercing .60 shells. Can be upgraded using thermal glasses."
	icon = 'icons/obj/guns/projectile/heavysniper.dmi'
	icon_state = "heavysniper"
	item_state = "heavysniper"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_COVERT = 2)
	caliber = CAL_ANTIM
	init_recoil = LMG_RECOIL(3)
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	damage_multiplier = 2
	proj_step_multiplier = 0 //so the PTR isn't useless as a sniper weapon
	ammo_type = /obj/item/ammo_casing/antim
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	reload_sound = 'sound/weapons/guns/interact/rifle_load.ogg'
	matter = list(MATERIAL_PLASTEEL = 40, MATERIAL_PLASTIC = 20)
	price_tag = 5000
	zoom_factors = list(1,2)
	twohanded = TRUE
	darkness_view = 7
	see_invisible_gun = SEE_INVISIBLE_NOLIGHTING
	scoped_offset_reduction = 8
	var/extra_dam_mult_scoped_upper = 0.4
	var/extra_dam_mult_scoped_lower = 0.2
	rarity_value = 90
	no_internal_mag = TRUE
	var/bolt_open = 0
	var/item_suffix = ""
	wield_delay = 0
	pierce_multiplier = 6
	gun_parts = list(/obj/item/part/gun/frame/heavysniper = 1, /obj/item/part/gun/grip/serb = 1, /obj/item/part/gun/mechanism/boltgun = 1, /obj/item/part/gun/barrel/antim = 1)
	serial_type = "SA"
	action_button_name = "Switch zoom level"
	action_button_proc = "switch_zoom"

/obj/item/part/gun/frame/heavysniper
	name = "Hristov frame"
	desc = "A Hristov AMR frame. For removing chunks of man and machine alike."
	icon_state = "frame_antimaterial"
	resultvars = list(/obj/item/gun/projectile/heavysniper)
	gripvars = list(/obj/item/part/gun/grip/serb)
	mechanismvar = /obj/item/part/gun/mechanism/boltgun
	barrelvars = list(/obj/item/part/gun/barrel/antim)

/obj/item/gun/projectile/heavysniper/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (item_suffix)
		itemstring += "[item_suffix]"

	if (bolt_open)
		iconstring += "_open"
	else
		iconstring += "_closed"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/heavysniper/Initialize()
	. = ..()
	update_icon()

/obj/item/gun/projectile/heavysniper/generate_guntags()
	..()
	gun_tags |= GUN_AMR

/obj/item/gun/projectile/heavysniper/attack_self(mob/user) //Someone overrode attackself for this class, soooo.
	if(zoom)
		toggle_scope(user)
		return
	bolt_act(user)

/obj/item/gun/projectile/heavysniper/proc/bolt_act(mob/living/user)
	playsound(src.loc, 'sound/weapons/guns/interact/rifle_boltback.ogg', 75, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(contents.len)
			if(chambered)
				to_chat(user, SPAN_NOTICE("You work the bolt open, ejecting [chambered]!"))
				chambered.forceMove(get_turf(src))
				loaded -= chambered
				chambered = null
			else
				var/obj/item/ammo_casing/B = loaded[loaded.len]
				to_chat(user, SPAN_NOTICE("You work the bolt open, ejecting [B]!"))
				B.forceMove(get_turf(src))
				loaded -= B
		else
			to_chat(user, SPAN_NOTICE("You work the bolt open."))
	else
		to_chat(user, SPAN_NOTICE("You work the bolt closed."))
		playsound(src.loc, 'sound/weapons/guns/interact/rifle_boltforward.ogg', 75, 1)
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/gun/projectile/heavysniper/special_check(mob/user)
	if(bolt_open)
		to_chat(user, SPAN_WARNING("You can't fire [src] while the bolt is open!"))
		return 0
	return ..()

/obj/item/gun/projectile/heavysniper/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/heavysniper/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/heavysniper/get_ammo() // Let's keep it simple. Count spent casing twice otherwise.
	if(loaded.len)
		return 1
	return 0

/obj/item/gun/projectile/heavysniper/zoom(tileoffset, viewsize, stayzoomed)
	..()
	refresh_upgrades()
	if(zoom)
		var/currentzoom = zoom_factors[active_zoom_factor]
		var/extra_damage
		switch(currentzoom)
			if(1)
				extra_damage = extra_dam_mult_scoped_lower
			if(2)
				extra_damage = extra_dam_mult_scoped_upper
		damage_multiplier += extra_damage
