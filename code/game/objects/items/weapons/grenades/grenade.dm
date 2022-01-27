/obj/item/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	flags = CONDUCT
	slot_flags = SLOT_BELT|SLOT_MASK
	var/active = 0
	var/det_time = 40
	var/variance = 0 //How69uch the fuse time69aries up or down. Punishes cooking with69akeshift nades, proper ones should have 0

/obj/item/grenade/proc/clown_check(var/mob/living/user)
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("Huh? How does this thing work?"))

		activate(user)
		add_fingerprint(user)
		spawn(5)
			prime()
		return 0
	return 1

/obj/item/grenade/examine(mob/user)
	if(..(user, 0))
		if(det_time > 1)
			to_chat(user, "The timer is set to 69det_time/1069 seconds.")
			return
		if(det_time == null)
			return
		to_chat(user, "\The 69src69 is set for instant detonation.")


/obj/item/grenade/attack_self(mob/user as69ob)
	if(!active)
		if(clown_check(user))
			to_chat(user, SPAN_WARNING("You prime \the 69name69! 69det_time/1069 seconds!"))

			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
	return


/obj/item/grenade/proc/activate(mob/user as69ob)
	if(active)
		return

	if(user)
		log_and_message_admins("primed \a 69src69")
		user.attack_log += "\6969time_stamp()69\69 <font color='red'>primed \a 69src69</font>"

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	update_icon()

	if(variance)
		det_time *= RAND_DECIMAL(1-variance, 1+variance)

	spawn(det_time)
		prime(user)
		return


/obj/item/grenade/proc/prime(mob/user as69ob)
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)
		user.hud_used.updatePlaneMasters(user)


/obj/item/grenade/attackby(obj/item/I,69ob/user as69ob)
	if(69UALITY_SCREW_DRIVING in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_SCREW_DRIVING, FAILCHANCE_EASY, re69uired_stat = STAT_COG))
			switch(det_time)
				if (1)
					det_time = 30
					to_chat(user, SPAN_NOTICE("You set the 69name69 for 3 second detonation time."))
				if (30)
					det_time = 40
					to_chat(user, SPAN_NOTICE("You set the 69name69 for 4 second detonation time."))
				if (40)
					det_time = 1
					to_chat(user, SPAN_NOTICE("You set the 69name69 for instant detonation."))
			add_fingerprint(user)
	..()
	return

/obj/item/grenade/attack_hand()
	walk(src, null, null)
	..()
	return
