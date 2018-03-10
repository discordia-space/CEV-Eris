/obj/item/weapon/tool/weldingtool
	name = "welding tool"
	icon_state = "welder"
	flags = CONDUCT

	//Amount of OUCH when it's thrown
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	throw_speed = 1
	throw_range = 5

	//Cost to make in the autolathe
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 30)

	//R&D tech level
	origin_tech = list(TECH_ENGINEERING = 1)

	//Welding tool specific stuff
	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold

/obj/item/weapon/tool/weldingtool/New()
//	var/random_fuel = min(rand(10,20),max_fuel)
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	..()

/obj/item/weapon/tool/weldingtool/Destroy()
	if(welding)
		processing_objects -= src
	return ..()

/obj/item/weapon/tool/weldingtool/examine(mob/user)
	if(..(user, 0))
		user << text("\icon[] [] contains []/[] units of fuel!", src, src.name, get_fuel(),src.max_fuel )


/obj/item/weapon/tool/weldingtool/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/tool/screwdriver))
		if(welding)
			user << SPAN_DANGER("Stop welding first!")
			return
		status = !status
		if(status)
			user << SPAN_NOTICE("You secure the welder.")
		else
			user << SPAN_NOTICE("The welder can now be attached and modified.")
		src.add_fingerprint(user)
		return

	if((!status) && (istype(W,/obj/item/stack/rods)))
		var/obj/item/stack/rods/R = W
		R.use(1)
		var/obj/item/weapon/flamethrower/F = new/obj/item/weapon/flamethrower(user.loc)
		src.loc = F
		F.weldtool = src
		if (user.client)
			user.client.screen -= src
		if (user.r_hand == src)
			user.remove_from_mob(src)
		else
			user.remove_from_mob(src)
		src.master = F
		src.layer = initial(src.layer)
		user.remove_from_mob(src)
		if (user.client)
			user.client.screen -= src
		src.loc = F
		src.add_fingerprint(user)
		return

	..()
	return


/obj/item/weapon/tool/weldingtool/process()
	if(welding)
		if(prob(5))
			remove_fuel(1)

		if(get_fuel() < 1)
			setWelding(0)

	//I'm not sure what this does. I assume it has to do with starting fires...
	//...but it doesnt check to see if the welder is on or not.
	var/turf/location = src.loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = get_turf(M)
	if (istype(location, /turf))
		location.hotspot_expose(700, 5)


/obj/item/weapon/tool/weldingtool/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && !src.welding)
		O.reagents.trans_to_obj(src, max_fuel)
		user << SPAN_NOTICE("Welder refueled")
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && src.welding)
		message_admins("[key_name_admin(user)] triggered a fueltank explosion with a welding tool.")
		log_game("[key_name(user)] triggered a fueltank explosion with a welding tool.")
		user << SPAN_DANGER("You begin welding on the fueltank and with a moment of lucidity you realize, this might not have been the smartest thing you've ever done.")
		var/obj/structure/reagent_dispensers/fueltank/tank = O
		tank.explode()
		return
	if (src.welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)
	return


/obj/item/weapon/tool/weldingtool/attack_self(mob/user as mob)
	setWelding(!welding, usr)
	return

//Returns the amount of fuel in the welder
/obj/item/weapon/tool/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")


//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weapon/tool/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding)
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			M << SPAN_NOTICE("You need more welding fuel to complete this task.")
		return 0

//Returns whether or not the welding tool is currently on.
/obj/item/weapon/tool/weldingtool/proc/isOn()
	return src.welding

/obj/item/weapon/tool/weldingtool/update_icon()
	..()
	icon_state = welding ? "welder1" : "welder"
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weapon/tool/weldingtool/proc/setWelding(var/set_welding, var/mob/M)
	if(!status)	return

	var/turf/T = get_turf(src)
	//If we're turning it on
	if(set_welding && !welding)
		if (get_fuel() > 0)
			if(M)
				M << SPAN_NOTICE("You switch the [src] on.")
			else if(T)
				T.visible_message(SPAN_DANGER("\The [src] turns on."))
			force = WEAPON_FORCE_PAINFULL
			damtype = "fire"
			w_class = ITEM_SIZE_LARGE
			welding = 1
			tool_qualities = list(QUALITY_WELDING = 3, QUALITY_CAUTERIZING = 1)
			update_icon()
			set_light(l_range = 1.4, l_power = 1, l_color = COLOR_ORANGE)
			processing_objects |= src
		else
			if(M)
				M << SPAN_NOTICE("You need more welding fuel to complete this task.")
			return
	//Otherwise
	else if(!set_welding && welding)
		processing_objects -= src
		if(M)
			M << SPAN_NOTICE("You switch \the [src] off.")
		else if(T)
			T.visible_message(SPAN_WARNING("\The [src] turns off."))
		force = WEAPON_FORCE_WEAK
		damtype = "brute"
		w_class = initial(w_class)
		tool_qualities = initial(tool_qualities)
		welding = 0
		update_icon()
		set_light(l_range = 0, l_power = 0, l_color = COLOR_ORANGE)

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weapon/tool/weldingtool/proc/eyecheck(mob/user as mob)
	if(!iscarbon(user))
		return 1
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if(!E)
			return
		var/safety = H.eyecheck()
		switch(safety)
			if(FLASH_PROTECTION_MODERATE)
				H << SPAN_WARNING("Your eyes sting a little.")
				E.damage += rand(1, 2)
				if(E.damage > 12)
					H.eye_blurry += rand(3,6)
			if(FLASH_PROTECTION_NONE)
				H << SPAN_WARNING("Your eyes burn.")
				E.damage += rand(2, 4)
				if(E.damage > 10)
					E.damage += rand(4,10)
			if(FLASH_PROTECTION_REDUCED)
				H << SPAN_DANGER("Your equipment intensify the welder's glow. Your eyes itch and burn severely.")
				H.eye_blurry += rand(12,20)
				E.damage += rand(12, 16)
		if(safety<FLASH_PROTECTION_MAJOR)
			if(E.damage > 10)
				user << SPAN_WARNING("Your eyes are really starting to hurt. This can't be good for you!")

			if (E.damage >= E.min_broken_damage)
				H << SPAN_DANGER("You go blind!")
				H.sdisabilities |= BLIND
			else if (E.damage >= E.min_bruised_damage)
				H << SPAN_DANGER("You go blind!")
				H.eye_blind = 5
				H.eye_blurry = 5
				H.disabilities |= NEARSIGHTED
				spawn(100)
					H.disabilities &= ~NEARSIGHTED

/obj/item/weapon/tool/weldingtool/largetank
	name = "industrial welding tool"
	max_fuel = 40
	origin_tech = list(TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 60)

/obj/item/weapon/tool/weldingtool/hugetank
	name = "upgraded welding tool"
	max_fuel = 80
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 3)
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 120)

/obj/item/weapon/tool/weldingtool/experimental
	name = "experimental welding tool"
	max_fuel = 40
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_PLASMA = 3)
	matter = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 120)
	var/last_gen = 0

/obj/item/weapon/tool/weldingtool/experimental/proc/fuel_gen()//Proc to make the experimental welder generate fuel, optimized as fuck -Sieve
	var/gen_amount = ((world.time-last_gen)/25)
	reagents += (gen_amount)
	if(reagents > max_fuel)
		reagents = max_fuel

/obj/item/weapon/tool/weldingtool/attack(var/mob/living/carbon/human/H, var/mob/living/user)

	if(ishuman(H))
		var/obj/item/organ/external/S = H.organs_by_name[user.targeted_organ]

		if(!S)
			return
		if(S.robotic < ORGAN_ROBOT || user.a_intent != I_HELP)
			return ..()

		if(S.brute_dam)
			if(S.brute_dam < ROBOLIMB_SELF_REPAIR_CAP)
				S.heal_damage(15,0,0,1)
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message(
					SPAN_NOTICE("\The [user] patches some dents on \the [H]'s [S.name] with \the [src].")
				)
			else if(S.open != 2)
				user << SPAN_DANGER("The damage is far too severe to patch over externally.")
		else if(S.open != 2) // For surgery.
			user << SPAN_NOTICE("Nothing to fix!")

	else
		return ..()
