/obj/item/gun/projectile/flare_gun
	name = "flare gun"
	desc = "Flare gun made of cheap plastic. Now, where did all those gun-toting madmen get to?"
	icon = 'icons/obj/guns/projectile/flaregun.dmi'
	icon_state = "flaregun"
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
	recoil_buildup = 20
	rarity_value = 9
	no_internal_mag = TRUE
	var/bolt_open = FALSE

/obj/item/gun/projectile/flare_gun/on_update_icon()
	..()

	if (bolt_open)
		SetIconState("flaregun_open")
	else
		SetIconState("flaregun")

/obj/item/gun/projectile/flare_gun/attack_self(mob/user)
	if(zoom)
		toggle_scope(user)
		return
	bolt_act(user)

/obj/item/gun/projectile/flare_gun/proc/bolt_act(mob/living/user)
	bolt_open = !bolt_open
	if(bolt_open)
		playsound(src.loc, 'sound/weapons/guns/interact/rev_cock.ogg', 75, 1)
		to_chat(user, SPAN_NOTICE("You snap the barrel open."))
		unload_ammo(user, allow_dump=1)
	else
		playsound(src.loc, 'sound/weapons/guns/interact/rev_cock.ogg', 75, 1)
		to_chat(user, SPAN_NOTICE("You snap the barrel closed"))
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/gun/projectile/flare_gun/special_check(mob/user)
	if(bolt_open)
		to_chat(user, SPAN_WARNING("You can't fire [src] while the barrel is open!"))
		return 0
	return ..()

/obj/item/gun/projectile/flare_gun/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		to_chat(user, SPAN_WARNING("You can't load [src] while the barrel is closed!"))
		return
	..()

/obj/item/gun/projectile/flare_gun/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/flare_gun/shotgun
	desc = "Flare gun made of cheap plastic, but with a reinforced barrel. Now, where did all those gun-toting madmen get to?"
	caliber = CAL_SHOTGUN
	damage_multiplier = 0.4
	penetration_multiplier = 0.5
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	one_hand_penalty = 10 //compact shotgun level
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_PLASTIC = 12, MATERIAL_STEEL = 16)
