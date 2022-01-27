/obj/item/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state =69ull
	w_class = ITEM_SIZE_SMALL
	bad_type = /obj/item/reagent_containers
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,15,25,30)
	var/volume = 30
	var/filling_states				// List of percentages full that have icons


/obj/item/reagent_containers/verb/set_APTFT() //set amount_per_transfer_from_this
	set69ame = "Set transfer amount"
	set category = "Object"
	set src in range(0)
	var/N = input("Amount per transfer from this:","69src69") as69ull|anything in possible_transfer_amounts
	if(N)
		amount_per_transfer_from_this =69

/obj/item/reagent_containers/Initialize()
	create_reagents(volume)
	. = ..() // This creates initial reagents
	if(!possible_transfer_amounts)
		src.verbs -= /obj/item/reagent_containers/verb/set_APTFT


/obj/item/reagent_containers/attack_self(mob/user as69ob)
	return

/obj/item/reagent_containers/afterattack(obj/target,69ob/user, flag)
	return

/obj/item/reagent_containers/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/proc/get_filling_state()
	var/percent = round((reagents.total_volume /69olume) * 100)
	var/list/increments = cached_number_list_decode(filling_states)
	if(!length(increments))
		return

	var/last_increment = increments69169
	for(var/increment in increments)
		if(percent < increment)
			break

		last_increment = increment

	return last_increment

/obj/item/reagent_containers/proc/standard_dispenser_refill(mob/user, atom/target) // This goes into afterattack
	if(!target.is_drainable())
		return FALSE

	if(!is_refillable())
		is_closed_message(user)
		return TRUE

	if(!target.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("69target69 is empty."))
		return TRUE

	if(reagents && !reagents.get_free_space())
		to_chat(user, SPAN_NOTICE("69src69 is full."))
		return TRUE

	var/transfer_amount = amount_per_transfer_from_this
	if(istype(target, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = target
		transfer_amount = C.amount_per_transfer_from_this

	var/trans = target.reagents.trans_to_obj(src, transfer_amount)
	to_chat(user, SPAN_NOTICE("You fill 69src69 with 69trans69 units of the contents of 69target69."))
	playsound(loc, 'sound/effects/watersplash.ogg', 100, 1)
	return TRUE

/obj/item/reagent_containers/proc/standard_splash_mob(mob/user,69ob/target) // This goes into afterattack
	if(!istype(target))
		return FALSE

	if(!is_drainable())
		is_closed_message(user)
		return TRUE

	if(!reagents.total_volume)
		to_chat(user, SPAN_NOTICE("69src69 is empty."))
		return TRUE

	if(target.reagents && !target.reagents.get_free_space())
		to_chat(user, SPAN_NOTICE("69target69 is full."))
		return TRUE

	var/contained = reagents.log_list()
	target.attack_log += text("\6969time_stamp()69\69 <font color='orange'>Has been splashed with 69name69 by 69user.name69 (69user.ckey69). Reagents: 69contained69</font>")
	user.attack_log += text("\6969time_stamp()69\69 <font color='red'>Used the 69name69 to splash 69target.name69 (69target.key69). Reagents: 69contained69</font>")
	msg_admin_attack("69user.name69 (69user.ckey69) splashed 69target.name69 (69target.key69) with 69name69. Reagents: 69contained69 (INTENT: 69uppertext(user.a_intent)69) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)")

	user.visible_message(
		SPAN_DANGER("69target69 has been splashed with something by 69user69!"),
		SPAN_NOTICE("You splash the solution onto 69target69.")
	)
	reagents.splash(target, reagents.total_volume)
	return TRUE

/obj/item/reagent_containers/proc/self_feed_message(mob/user)
	to_chat(user, SPAN_NOTICE("You eat \the 69src69"))

/obj/item/reagent_containers/proc/is_closed_message(mob/user)
	return

/obj/item/reagent_containers/proc/other_feed_message_start(mob/user,69ob/target)
	user.visible_message(SPAN_WARNING("69user69 is trying to feed 69target69 \the 69src69!"))

/obj/item/reagent_containers/proc/other_feed_message_finish(mob/user,69ob/target)
	user.visible_message(SPAN_WARNING("69user69 has fed 69target69 \the 69src69!"))

/obj/item/reagent_containers/proc/feed_sound(mob/user)
	return

/obj/item/reagent_containers/proc/standard_feed_mob(mob/user,69ob/target) // This goes into attack
	if(!istype(target) || !target?.can_be_fed)
		return FALSE

	if(!is_drainable() && !istype(src, /obj/item/reagent_containers/pill)) // Pills are swallowed whole
		is_closed_message(user)
		return TRUE

	if(!reagents.total_volume)
		to_chat(user, SPAN_NOTICE("\The 69src69 is empty."))
		return TRUE

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.check_has_mouth())
			if(target == user)
				to_chat(user, "Where do you intend to put \the 69src69? You don't have a69outh!")
			else
				to_chat(user, "Where do you intend to put \the 69src69? \The 69H69 doesn't have a69outh!")
			return TRUE

		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(user, SPAN_WARNING("\The 69blocked69 is in the way!"))
			return TRUE

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //puts a limit on how fast people can eat/drink things

	if(target == user)
		self_feed_message(user)

	else
		other_feed_message_start(user, target)

		if(!do_mob(user, target, 15))
			return FALSE

		other_feed_message_finish(user, target)

		var/contained = reagents.log_list()
		target.attack_log += text("\6969time_stamp()69\69 <font color='orange'>Has been fed 69name69 by 69user.name69 (69user.ckey69). Reagents: 69contained69</font>")
		user.attack_log += text("\6969time_stamp()69\69 <font color='red'>Fed 69name69 by 69target.name69 (69target.ckey69). Reagents: 69contained69</font>")
		msg_admin_attack("69key_name(user)69 fed 69key_name(target)69 with 69name69. Reagents: 69contained69 (INTENT: 69uppertext(user.a_intent)69) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)")

	reagents.trans_to_mob(target, issmall(user) ? CEILING(amount_per_transfer_from_this * 0.5, 1) : amount_per_transfer_from_this, CHEM_INGEST)

	feed_sound(user)
	if(istype(src, /obj/item/reagent_containers/pill))
		69del(src) //pills are swallowed whole, so delete it here
	return TRUE

/obj/item/reagent_containers/proc/standard_pour_into(mob/user, atom/target) // This goes into afterattack and yes, it's atom-level
	// Ensure we don't splash beakers and similar containers.
	if(!target.is_refillable())
		if(istype(target, /obj/item/reagent_containers))
			var/obj/item/reagent_containers/container = target
			container.is_closed_message(user)
			return FALSE
		// Otherwise don't care about splashing.
		else
			return FALSE

	if(!is_drainable())
		is_closed_message(user)
		return FALSE

	if(!reagents.total_volume)
		to_chat(user, SPAN_NOTICE("69src69 is empty."))
		return FALSE

	if(!target.reagents.get_free_space())
		to_chat(user, SPAN_NOTICE("69target69 is full."))
		return FALSE

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	playsound(src,'sound/effects/Li69uid_transfer_mono.ogg',50,1)
	to_chat(user, SPAN_NOTICE("You transfer 69trans69 units of the solution to 69target69."))
	user.investigate_log("transfered 69trans69 units from 69src69(69reagents.log_list()69) to 69target69(69target.reagents.log_list()69)", "chemistry")
	return TRUE

// if amount_per_reagent is69ull or zero it will transfer all
/obj/item/reagent_containers/proc/separate_solution(var/list/obj/item/reagent_containers/accepting_containers,69ar/amount_per_reagent,69ar/list/ignore_reagents_ids)
	if(!is_drainable())
		return FALSE
	if(!reagents.total_volume)
		return FALSE

	//69othing to separate
	if(reagents.reagent_list.len <= 1)
		return FALSE
	var/list/obj/item/reagent_containers/containers = accepting_containers.Copy()
	for(var/obj/item/reagent_containers/C in containers)
		if(!C.is_refillable())
			containers.Remove(C)
	if(!containers.len)
		return FALSE
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.id in ignore_reagents_ids)
			continue
		var/amount_to_transfer = amount_per_reagent ? amount_per_reagent : R.volume
		for(var/obj/item/reagent_containers/C in containers)
			if(!amount_to_transfer)
				break
			if(!C.reagents.get_free_space())
				containers.Remove(C)
				continue

			var/amount =69in(C.reagents.get_free_space(),69in(amount_to_transfer, R.volume))
			if(!C.reagents.total_volume || C.reagents.has_reagent(R.id))
				C.reagents.add_reagent(R.id, amount, R.get_data())
				reagents.remove_reagent(R.id, amount)
				amount_to_transfer =69ax(0,amount_to_transfer - amount)
	return TRUE

