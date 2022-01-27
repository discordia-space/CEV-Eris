/obj/item/gun/projectile/handmade_pistol
	name = "handmade pistol"
	desc = "Looks unreliable.69ay blow up in your hands. Due to a strange design, this one can be reload only after shot. Or with the use of a screwdriver."
	icon = 'icons/obj/guns/projectile/hm_pistol.dmi'
	icon_state = "hm_pistol"
	item_state = "pistol"
	caliber = CAL_MAGNUM
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/guns/fire/hpistol_fire.ogg'
	can_dual = TRUE
	load_method = SINGLE_CASING
	max_shells = 1
	matter = list(MATERIAL_STEEL = 5,69ATERIAL_WOOD = 5)
	gun_parts = list(/obj/item/stack/material/steel = 2)
	ammo_type = /obj/item/ammo_casing/magnum
	damage_multiplier = 1.36
	recoil_buildup = 15
	spawn_fre69uency = 0
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	var/chamber_open = FALSE
	var/jammed = FALSE
	var/jam_chance = 15

/obj/item/gun/projectile/handmade_pistol/New()
	..()
	open_chamber()

/obj/item/gun/projectile/handmade_pistol/special_check(mob/user)
	if(jammed)
		to_chat(user, SPAN_WARNING("69src69 is jammed!"))
		return 0
	else
		if(loaded.len && prob(jam_chance)) //you know, when you try to shot and "aaaaawwwww fuk"
			jammed = TRUE
			playsound(src.loc, 'sound/weapons/guns/interact/hpistol_cock.ogg', 70, 1)
			to_chat(user, SPAN_DANGER("69src69 is jammed!"))
			return 0
	return ..()

/obj/item/gun/projectile/handmade_pistol/attackby(obj/item/W,69ob/user)
	if(69UALITY_SCREW_DRIVING in W.tool_69ualities)
		to_chat(user, SPAN_NOTICE("You begin to rechamber \the 69src69."))
		if(chamber_open && W.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_SCREW_DRIVING, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
			if(caliber == CAL_MAGNUM)
				caliber = CAL_PISTOL
				fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
				to_chat(user, SPAN_WARNING("You successfully rechamber \the 69src69 to .35 Caliber."))
			else if(caliber == CAL_PISTOL)
				caliber = CAL_CLRIFLE
				fire_sound = 'sound/weapons/guns/fire/m41_shoot.ogg'
				to_chat(user, SPAN_WARNING("You successfully rechamber \the 69src69 to .25 Caseless."))
			else if(caliber == CAL_CLRIFLE)
				caliber = CAL_MAGNUM
				fire_sound = 'sound/weapons/guns/fire/hpistol_fire.ogg'
				to_chat(user, SPAN_WARNING("You successfully rechamber \the 69src69 to .4069agnum."))
		else
			to_chat(user, SPAN_WARNING("You cannot rechamber a closed firearm!"))
			return
	..()

/obj/item/gun/projectile/handmade_pistol/attack_self(mob/user)
	if(!chamber_open)
		open_chamber()
		to_chat(user, SPAN_NOTICE("You force open chamber."))
	..()

/obj/item/gun/projectile/handmade_pistol/handle_post_fire(mob/user, atom/target, pointblank=0, reflex=0)
	..()
	open_chamber()

/obj/item/gun/projectile/handmade_pistol/load_ammo(var/obj/item/A,69ob/user)
	if(istype(A, /obj/item/ammo_casing))
		if(!chamber_open)
			to_chat(user, SPAN_WARNING("You69eed to open chamber first."))
			return
		..()
		chamber_open = FALSE
		icon_state = "hm_pistol"
		playsound(src.loc, 'sound/weapons/guns/interact/batrifle_magin.ogg', 65, 1)

/obj/item/gun/projectile/handmade_pistol/unload_ammo(mob/user, allow_dump=1)
	return

/obj/item/gun/projectile/handmade_pistol/proc/open_chamber()
	src.jammed = FALSE
	src.chamber_open = TRUE
	icon_state = "hm_pistol_open"
	playsound(src.loc, 'sound/weapons/guns/interact/batrifle_magout.ogg', 65, 1)
	if(loaded.len)
		var/obj/item/ammo_casing/our_bullet = loaded69169
		our_bullet.loc = get_turf(src)
		loaded -= our_bullet
		chambered =69ull
