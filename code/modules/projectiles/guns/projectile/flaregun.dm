/obj/item/gun/projectile/flare_gun
	name = "flare gun"
	desc = "Flare gun made of cheap plastic. Now, where did all those gun-toting madmen get to?"
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
	matter = list(MATERIAL_PLASTIC = 12, MATERIAL_STEEL = 4)
	gun_parts = list(/obj/item/stack/material/plastic = 4)
	ammo_type = /obj/item/ammo_casing/flare
	init_recoil = HANDGUN_RECOIL(2.5)
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
				to_chat(user, SPAN_NOTICE("You snap the barrel open, ejecting [chambered]!"))
				chambered.forceMove(get_turf(src))
				loaded -= chambered
				chambered = null
			else
				var/obj/item/ammo_casing/shell = loaded[loaded.len]
				to_chat(user, SPAN_NOTICE("You snap the barrel open, ejecting [shell]!"))
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
		to_chat(user, SPAN_WARNING("You can't fire [src] while the barrel is open!"))
		return FALSE
	return ..()

/obj/item/gun/projectile/flare_gun/load_ammo(obj/item/A, mob/user)
	if(!bolt_open)
		to_chat(user, SPAN_WARNING("You can't load [src] while the barrel is closed!"))
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
	name = "reinforced flare gun" // slightly worse than a DB sawn off, less recoil with one hand, more with two
	desc = "Flare gun made of cheap plastic, repurposed to fire shotgun shells."
	icon_state = "empty_r"
	caliber = CAL_SHOTGUN
	damage_multiplier = 0.8
	penetration_multiplier = 0.3
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_PLASTIC = 12, MATERIAL_STEEL = 11)

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
