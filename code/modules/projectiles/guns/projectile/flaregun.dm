/obj/item/gun/projectile/flare_gun
	name = "flare gun"
	desc = "Flare gun69ade of cheap plastic.69ow, where did all those gun-toting69admen get to?"
	icon = 'icons/obj/guns/projectile/flaregun.dmi'
	icon_state = "empty"
	item_state = "pistol"
	caliber = CAL_FLARE
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	bulletinsert_sound = 'sound/weapons/guns/interact/bullet_insert.ogg'
	fire_sound = 'sound/weapons/guns/interact/hpistol_cock.ogg'
	w_class = ITEM_SIZE_SMALL
	can_dual = TRUE
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	max_shells = 1
	matter = list(MATERIAL_PLASTIC = 12,69ATERIAL_STEEL = 4)
	gun_parts = list(/obj/item/stack/material/plastic = 4)
	ammo_type = /obj/item/ammo_casing/flare
	recoil_buildup = 20
	rarity_value = 9
	no_internal_mag = TRUE
	var/bolt_open = FALSE

/obj/item/gun/projectile/flare_gun/update_icon()
	..()

	if(bolt_open)
		if(loaded.len)
			icon_state = "full_open"
		else
			icon_state = "empty_open"
	else
		if(loaded.len)
			icon_state = "full"
		else
			icon_state = "empty"

/obj/item/gun/projectile/flare_gun/attack_self(mob/user)
	if(zoom)
		toggle_scope(user)
		return
	bolt_act(user)

/obj/item/gun/projectile/flare_gun/proc/bolt_act(mob/living/user)
	playsound(loc, 'sound/weapons/guns/interact/rev_cock.ogg', 75, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(loaded.len)
			if(chambered)
				to_chat(user, SPAN_NOTICE("You snap the barrel open, ejecting 69chambered69!"))
				chambered.forceMove(get_turf(src))
				loaded -= chambered
				chambered =69ull
			else
				var/obj/item/ammo_casing/shell = loaded69loaded.len69
				to_chat(user, SPAN_NOTICE("You snap the barrel open, ejecting 69shell69!"))
				shell.forceMove(get_turf(src))
				loaded -= shell
		else
			to_chat(user, SPAN_NOTICE("You snap the barrel open."))
	else
		to_chat(user, SPAN_NOTICE("You snap the barrel closed"))
	add_fingerprint(user)
	update_icon()

/obj/item/gun/projectile/flare_gun/special_check(mob/user)
	if(bolt_open)
		to_chat(user, SPAN_WARNING("You can't fire 69src69 while the barrel is open!"))
		return FALSE
	return ..()

/obj/item/gun/projectile/flare_gun/load_ammo(obj/item/A,69ob/user)
	if(!bolt_open)
		to_chat(user, SPAN_WARNING("You can't load 69src69 while the barrel is closed!"))
		return
	..()

/obj/item/gun/projectile/flare_gun/unload_ammo(mob/user, allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/flare_gun/get_ammo() // Let's keep it simple. Count spent casing twice otherwise.
	if(loaded.len)
		return 1
	return 0

/obj/item/gun/projectile/flare_gun/shotgun
	name = "reinforced flare gun"
	desc = "Flare gun69ade of cheap plastic, repurposed to fire shotgun shells."
	icon_state = "empty_r"
	caliber = CAL_SHOTGUN
	damage_multiplier = 0.6
	penetration_multiplier = 0.5
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	one_hand_penalty = 10 //compact shotgun level
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_PLASTIC = 12,69ATERIAL_STEEL = 16)

/obj/item/gun/projectile/flare_gun/shotgun/update_icon()
	..()

	if(bolt_open)
		if(loaded.len)
			icon_state = "full_open_r"
		else
			icon_state = "empty_open_r"
	else
		if(loaded.len)
			icon_state = "full_r"
		else
			icon_state = "empty_r"
