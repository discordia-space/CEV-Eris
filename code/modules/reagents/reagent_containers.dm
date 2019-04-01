/obj/item/weapon/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = ITEM_SIZE_SMALL
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,15,25,30)
	var/volume = 30
	var/filling_states				// List of percentages full that have icons
	var/list/preloaded = null

/obj/item/weapon/reagent_containers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in range(0)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
	if(N)
		amount_per_transfer_from_this = N

/obj/item/weapon/reagent_containers/New()
	if(!possible_transfer_amounts)
		src.verbs -= /obj/item/weapon/reagent_containers/verb/set_APTFT
	create_reagents(volume)
	if(preloaded)
		for(var/reagent in preloaded)
			reagents.add_reagent(reagent, preloaded[reagent])
	..()


/obj/item/weapon/reagent_containers/attack_self(mob/user as mob)
	return

/obj/item/weapon/reagent_containers/afterattack(obj/target, mob/user, flag)
	return

/obj/item/weapon/reagent_containers/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/proc/get_filling_state()
	var/percent = round((reagents.total_volume / volume) * 100)
	var/list/increments = cached_number_list_decode(filling_states)
	if(!length(increments))
		return

	var/last_increment = increments[1]
	for(var/increment in increments)
		if(percent < increment)
			break

		last_increment = increment

	return last_increment

/obj/item/weapon/reagent_containers/proc/standard_dispenser_refill(mob/user, atom/target) // This goes into afterattack
	if(!target.is_drainable())
		return FALSE

	if(!is_refillable())
		is_closed_message(user)
		return TRUE

	if(!target.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("[target] is empty."))
		return TRUE

	if(reagents && !reagents.get_free_space())
		to_chat(user, SPAN_NOTICE("[src] is full."))
		return TRUE

	var/trans = target.reagents.trans_to_obj(src, target:amount_per_transfer_from_this)
	to_chat(user, SPAN_NOTICE("You fill [src] with [trans] units of the contents of [target]."))
	playsound(loc, 'sound/effects/watersplash.ogg', 100, 1)
	return TRUE

/obj/item/weapon/reagent_containers/proc/standard_splash_mob(mob/user, mob/target) // This goes into afterattack
	if(!istype(target))
		return FALSE

	if(!is_drainable())
		is_closed_message(user)
		return TRUE

	if(!reagents.total_volume)
		to_chat(user, SPAN_NOTICE("[src] is empty."))
		return TRUE

	if(target.reagents && !target.reagents.get_free_space())
		to_chat(user, SPAN_NOTICE("[target] is full."))
		return TRUE

	var/contained = reagents.log_list()
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been splashed with [name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [name] to splash [target.name] ([target.key]). Reagents: [contained]</font>")
	msg_admin_attack("[user.name] ([user.ckey]) splashed [target.name] ([target.key]) with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	user.visible_message(
		SPAN_DANGER("[target] has been splashed with something by [user]!"),
		SPAN_NOTICE("You splash the solution onto [target].")
	)
	reagents.splash(target, reagents.total_volume)
	return TRUE

/obj/item/weapon/reagent_containers/proc/self_feed_message(mob/user)
	to_chat(user, SPAN_NOTICE("You eat \the [src]"))

/obj/item/weapon/reagent_containers/proc/is_closed_message(mob/user)
	return

/obj/item/weapon/reagent_containers/proc/other_feed_message_start(mob/user, mob/target)
	user.visible_message(SPAN_WARNING("[user] is trying to feed [target] \the [src]!"))

/obj/item/weapon/reagent_containers/proc/other_feed_message_finish(mob/user, mob/target)
	user.visible_message(SPAN_WARNING("[user] has fed [target] \the [src]!"))

/obj/item/weapon/reagent_containers/proc/feed_sound(mob/user)
	return

/obj/item/weapon/reagent_containers/proc/standard_feed_mob(mob/user, mob/target) // This goes into attack
	if(!istype(target))
		return FALSE

	if(!is_drainable())
		is_closed_message(user)
		return TRUE

	if(!reagents.total_volume)
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))
		return TRUE

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.check_has_mouth())
			if(target == user)
				to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
			else
				to_chat(user, "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!")
			return TRUE

		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(user, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //puts a limit on how fast people can eat/drink things

	if(target == user)
		self_feed_message(user)

	else
		other_feed_message_start(user, target)

		if(!do_mob(user, target, 15))
			return TRUE

		other_feed_message_finish(user, target)

		var/contained = reagents.log_list()
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [name] by [target.name] ([target.ckey]). Reagents: [contained]</font>")
		msg_admin_attack("[key_name(user)] fed [key_name(target)] with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	reagents.trans_to_mob(target, issmall(user) ? ceil(amount_per_transfer_from_this/2) : amount_per_transfer_from_this, CHEM_INGEST)

	feed_sound(user)
	return TRUE

/obj/item/weapon/reagent_containers/proc/standard_pour_into(mob/user, atom/target) // This goes into afterattack and yes, it's atom-level
	// Ensure we don't splash beakers and similar containers.
	if(!target.is_refillable())
		if(istype(target, /obj/item/weapon/reagent_containers))
			var/obj/item/weapon/reagent_containers/container = target
			container.is_closed_message(user)
			return TRUE
		// Otherwise don't care about splashing.
		else
			return FALSE

	if(!is_drainable())
		is_closed_message(user)
		return TRUE

	if(!reagents.total_volume)
		to_chat(user, SPAN_NOTICE("[src] is empty."))
		return TRUE

	if(!target.reagents.get_free_space())
		to_chat(user, SPAN_NOTICE("[target] is full."))
		return TRUE

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	playsound(src,'sound/effects/Liquid_transfer_mono.ogg',50,1)
	to_chat(user, SPAN_NOTICE("You transfer [trans] units of the solution to [target]."))
	return TRUE
