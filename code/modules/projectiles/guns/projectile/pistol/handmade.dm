/obj/item/weapon/gun/projectile/handmade_pistol
	name = "handmade pistol"
	desc = "Looks unreliable. can fit anyt casing. but anything bigger than a pistol might make it blow up in your hands. Due to a strange design, this one can be reload only after shot. Or with the use of a screwdriver."
	icon = 'icons/obj/guns/projectile/hm_pistol.dmi'
	icon_state = "hm_pistol"
	item_state = "pistol"
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	can_dual = 1
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/
	damage_multiplier = 1.36
	recoil_buildup = 45
	var/chamber_open = TRUE //so you can get the first shot in without needing any tools
	var/jammed = FALSE
	var/jam_chance = 100 //if you don't load it shouldn't matter
	var/explode = FALSE //if it explodes when

/obj/item/weapon/gun/projectile/handmade_pistol/New()
	..()
	open_chamber()

/obj/item/weapon/gun/projectile/handmade_pistol/special_check(mob/user)
	if(jammed)
		to_chat(user, SPAN_WARNING("[src] is jammed!"))
		return 0
	else
		if(loaded.len && prob(jam_chance)) //you know, when you try to shot and "aaaaawwwww fuk"
			jammed = TRUE
			playsound(src.loc, 'sound/weapons/guns/interact/hpistol_cock.ogg', 70, 1)
			to_chat(user, SPAN_DANGER("[src] is jammed!"))
			if(caliber == CAL_MAGNUM )
				if (prob(1))
					explode(src)
			if(caliber == CAL_357 )
				if (prob(1))
					explode(src)
			if(caliber == CAL_SRIFLE )
				if (prob(2.5))
					explode(src)
			if(caliber == CAL_CLRIFLE)
				if (prob(2.5))
					explode(src)
			if(caliber == CAL_LRIFLE )
				if (prob(2.5))
					explode(src)
			if(caliber == CAL_SHOTGUN )
				if (prob(10))
					explode(src)
			if(caliber == CAL_70)
				if (prob(25))
					explode(src)
			if(caliber == CAL_ANTIM)
				if (prob(80))
					to_chat(user, SPAN_WARNING("you can feel the primer expanding. the bullet doesn't fly out."))
					explode(src)
			if(caliber == CAL_GRENADE) //i mean if you are dumb go on
				to_chat(user, SPAN_WARNING("you can hear a weird click."))
				if (prob(100)) //for real go on please
					explode(src)
			else
				if (prob(33)) // maybe explode? if the ammo type got here and its not above shouldn't be here
					explode(src)
			return 0
	return ..()

/obj/item/weapon/gun/projectile/handmade_pistol/attackby(obj/item/weapon/W as obj, mob/user as mob,)
	if(!chamber_open)
		if(istype(W, /obj/item/weapon/tool/screwdriver) || istype(W, /obj/item/weapon/material/kitchen/utensil) || W.sharp)
			open_chamber()
			to_chat(user, SPAN_NOTICE("You force open chamber with [W]."))
	..()

/obj/item/weapon/gun/projectile/handmade_pistol/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	..()
	open_chamber()

/obj/item/weapon/gun/projectile/handmade_pistol/proc/explode(obj)
	explosion(loc, 0, 1, 2, 3)
	spawn(0)
		qdel(src)

/obj/item/weapon/gun/projectile/handmade_pistol/load_ammo(obj/item/ammo_casing/A, mob/user)
	if(istype(A, /obj/item/ammo_casing))
		if(!chamber_open)
			if(!(caliber == A.caliber))
				caliber = A.caliber
				to_chat(user, SPAN_WARNING("You adapt its barrel to the new caliber."))
			else to_chat(user, SPAN_WARNING("You need to open chamber first."))
			return
		..()

		if(!(caliber == A.caliber))
			to_chat(user, SPAN_WARNING("you notice you can adjust it. if it were closed, and so you do"))
		chamber_open = FALSE
		icon_state = "hm_pistol"
		playsound(src.loc, 'sound/weapons/guns/interact/batrifle_magin.ogg', 65, 1)
		if(caliber == CAL_CAP )
			jam_chance = 0 //its a blank why should it jam ? for pain to the player?
			to_chat(user, SPAN_WARNING("it fits just right."))
		if(caliber == CAL_PISTOL)
			jam_chance = 5 //it jams 10% less with regular pistol ammo now
			to_chat(user, SPAN_WARNING("almost a perfet fitting."))
		if(caliber == CAL_35A )
			jam_chance = 10
			to_chat(user, SPAN_WARNING("the casing is just a tiny bit bigger than the hammer."))
		if(caliber == CAL_MAGNUM )
			jam_chance = 15 //original value. every other cartridge will make it higher
			to_chat(user, SPAN_WARNING("the casing is a slightly bigger than the hammer."))
		if(caliber == CAL_357 )
			jam_chance = 15
			to_chat(user, SPAN_WARNING("the casing is a slightly bigger than the hammer."))
		if(caliber == CAL_SRIFLE )
			jam_chance = 20
			to_chat(user, SPAN_WARNING("the casing is bigger than the hammer."))
		if(caliber == CAL_CLRIFLE)
			jam_chance = 23
			to_chat(user, SPAN_WARNING("the casing is a slightly bigger than the hammer."))
		if(caliber == CAL_LRIFLE )
			jam_chance = 26
			to_chat(user, SPAN_WARNING("the casing is a slightly bigger than the hammer."))
		if(caliber == CAL_SHOTGUN )
			jam_chance = 33 // 1 in 3 sounds high but better safe than sorrow
			to_chat(user, SPAN_WARNING("with some effort. you manage to fit it."))
		if(caliber == CAL_70)
			jam_chance = 75
			to_chat(user, SPAN_WARNING("the little hammer pales in comparison to the casings primer"))
		if(caliber == CAL_ANTIM)
			jam_chance = 100 //this NEEDS to jam the shit. or else easy amr
			to_chat(user, SPAN_WARNING("you bang it in with your hand. the gun creaks as if it was a warning."))
		if(caliber == CAL_GRENADE) //i mean if you are dumb go on
			to_chat(user, SPAN_WARNING("you force it in. it definetly doesn't fit right. the gun almost breaks. but its chambered now."))  //a warning maybe you can notice your dumb act
			jam_chance = 100
		else
			jam_chance = 100 //if somehow you manage to fit something else. it will jam. 
/obj/item/weapon/gun/projectile/handmade_pistol/unload_ammo(mob/user, var/allow_dump=1)
	return

/obj/item/weapon/gun/projectile/handmade_pistol/proc/open_chamber()
	src.jammed = FALSE
	src.chamber_open = TRUE
	icon_state = "hm_pistol_open"
	playsound(src.loc, 'sound/weapons/guns/interact/batrifle_magout.ogg', 65, 1)
	if(loaded.len)
		var/obj/item/ammo_casing/our_bullet = loaded[1]
		our_bullet.loc = get_turf(src)
		loaded -= our_bullet
		chambered = null
