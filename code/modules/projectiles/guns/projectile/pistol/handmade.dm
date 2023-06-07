/obj/item/gun/projectile/handmade_pistol
	name = "HM HG \"Bubba\""
	desc = "Looks unreliable. May blow up in your hands."
	icon = 'icons/obj/guns/projectile/hm_pistol.dmi'
	icon_state = "hm_pistol"
	item_state = "pistol"
	caliber = CAL_MAGNUM
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/guns/fire/hpistol_fire.ogg'
	can_dual = TRUE
	load_method = SINGLE_CASING
	max_shells = 1
	matter = list(MATERIAL_STEEL = 10, MATERIAL_WOOD = 5)
	gun_parts = list(/obj/item/part/gun/frame/handmade_pistol = 1, /obj/item/part/gun/modular/grip/wood = 1, /obj/item/part/gun/modular/mechanism/pistol/steel = 1, /obj/item/part/gun/modular/barrel/pistol/steel = 1)
	ammo_type = /obj/item/ammo_casing/magnum
	damage_multiplier = 1.35
	penetration_multiplier = 0
	init_recoil = HANDGUN_RECOIL(2)
	spawn_frequency = 0
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	var/chamber_open = FALSE
	var/jammed = FALSE
	var/jam_chance = 15

/obj/item/part/gun/frame/handmade_pistol
	name = "Handmade pistol frame"
	desc = "A handmade pistol frame. It is, without a doubt, absolute trash."
	icon_state = "frame_pistol_hm"
	matter = list(MATERIAL_STEEL = 5)
	resultvars = list(/obj/item/gun/projectile/handmade_pistol)
	gripvars = list(/obj/item/part/gun/modular/grip/wood)
	mechanismvar = /obj/item/part/gun/modular/mechanism/pistol/steel
	barrelvars = list(/obj/item/part/gun/modular/barrel/pistol/steel, /obj/item/part/gun/modular/barrel/magnum/steel)

/obj/item/gun/projectile/handmade_pistol/New()
	..()
	open_chamber()

/obj/item/gun/projectile/handmade_pistol/special_check(mob/user)
	if(jammed)
		to_chat(user, SPAN_WARNING("[src] is jammed!"))
		return 0
	else
		if(loaded.len && prob(jam_chance)) //you know, when you try to shot and "aaaaawwwww fuk"
			jammed = TRUE
			playsound(src.loc, 'sound/weapons/guns/interact/hpistol_cock.ogg', 70, 1)
			to_chat(user, SPAN_DANGER("[src] is jammed!"))
			return 0
	return ..()

/obj/item/gun/projectile/handmade_pistol/attack_self(mob/user)
	if(!chamber_open)
		open_chamber()
		to_chat(user, SPAN_NOTICE("You force open chamber."))
	..()

/obj/item/gun/projectile/handmade_pistol/handle_post_fire(mob/user, atom/target, pointblank=0, reflex=0)
	..()
	open_chamber()

/obj/item/gun/projectile/handmade_pistol/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_casing))
		if(!chamber_open)
			to_chat(user, SPAN_WARNING("You need to open chamber first."))
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
		var/obj/item/ammo_casing/our_bullet = loaded[1]
		our_bullet.loc = get_turf(src)
		loaded -= our_bullet
		chambered = null
