/obj/item/reagent_containers/drywet
	var/list/solids = list()
	volume = 180
	var/untaken_capacity = 180 // how much space remains
	var/can_be_placed_into = list() // todo after cooking: stove and microwave and oven
	var/largestdimension = ITEM_SIZE_BULKY
	reagent_flags = DRAINABLE|REFILLABLE|TRANSPARENT
	name = "mixing bowl"
	desc = "A large mixing bowl."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mixingbowl"
	matter = list(MATERIAL_STEEL = 2)
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,180)
	volumeClass = ITEM_SIZE_NORMAL

/obj/item/reagent_containers/drywet/Initialize()
	. = ..()
	desc += " Can hold up to [volume] units."

/obj/item/reagent_containers/drywet/examine(mob/user)
	var/description = ""
	if(solids)
		var/list/toinsert = list()
		for(var/obj/item/solid in solids)
			toinsert.Add(solid.name)
		if(toinsert.len > 0)
			var/count = 1
			description += "It holds a "
			for(var/entry in toinsert)
				if(toinsert.len == 1)
					description += "[toinsert[1]]."
				else
					description += "[toinsert.len > count ? "\ [toinsert[count]], ":"and a [toinsert[toinsert.len]]."]"
					count +=1
	..(user, afterDesc = description)

//copied from glass
/obj/item/reagent_containers/drywet/pre_attack(atom/A, mob/user, params)
	if(user.a_intent == I_HURT)
		user.investigate_log("splashed [src] filled with [reagents.log_list()] and also [english_list(solids)] onto [A]", "chemistry")
		if(standard_splash_mob(user, A) || (ismob(A) && solids.len))
			for(var/obj/throwit in solids)
				remove_from_storage(throwit)
				throwit.throw_at(A, throwit.throw_range, throwit.throw_speed, user)
			return TRUE
		if(is_drainable() && (reagents.total_volume || solids.len))
			if(istype(A, /obj/structure/sink))
				to_chat(user, SPAN_NOTICE("You pour the solution into [A]."))
				reagents.remove_any(reagents.total_volume)
			else
				playsound(src,'sound/effects/Splash_Small_01_mono.ogg',50,1)
				to_chat(user, SPAN_NOTICE("You splash the contents of [src] onto [A]."))
				reagents.splash(A, reagents.total_volume)
				for(var/obj/throwit in solids)
					remove_from_storage(throwit)
					throwit.throw_at(A, throwit.throw_range, throwit.throw_speed, user)
			return TRUE
	return ..()

/obj/item/reagent_containers/drywet/afterattack(var/obj/target, var/mob/user, var/flag)
	if(!flag)
		return
	for(var/type in can_be_placed_into)
		if(istype(target, type))
			return
	if(standard_pour_into(user, target))
		return 1
	if(standard_dispenser_refill(user, target))
		return 1

/obj/item/reagent_containers/drywet/attack(mob/M as mob, mob/user as mob, def_zone)
	if(dhTotalDamage(melleDamages) && !(flags & NOBLUDGEON) && user.a_intent == I_HURT)
		return ..()

	if(standard_feed_mob(user, M))
		return

	return FALSE

/obj/item/reagent_containers/drywet/self_feed_message(mob/user)
	to_chat(user, SPAN_NOTICE("You drink from \the [src]"))
/obj/item/reagent_containers/drywet/other_feed_message_start(mob/user, mob/target)
	user.visible_message(SPAN_WARNING("[user] is trying to make [target] drink from \the [src]!"))

/obj/item/reagent_containers/drywet/other_feed_message_finish(mob/user, mob/target)
	user.visible_message(SPAN_WARNING("[user] has made [target] drink from \the [src]!"))

//copied from obj/item/storage
/obj/item/reagent_containers/drywet/proc/handle_item_insertion(obj/item/W, prevent_warning = 0)
	if (!istype(W)) return 0
	if (usr)
		usr.prepare_for_slotmove(W)
		usr.update_icons() //update our overlays

	W.forceMove(src)
	W.on_enter_storage(src)
	var/volume_taken = W.get_storage_cost() ** 2
	solids[W] = volume_taken
	untaken_capacity -=  volume_taken // checked for validity in can be inserted proc but dangerous if that proc is skipped

	if(usr)
		if (usr.client)
			usr.client.screen -= W
		W.dropped(usr)
		add_fingerprint(usr)

		if (!prevent_warning)
			for (var/mob/M in viewers(usr, null))
				if (M == usr)
					to_chat(usr, SPAN_NOTICE("You put \the [W] into [src]."))
				else if (M in range(1)) //If someone is standing close enough, they can tell what it is...
					M.show_message(SPAN_NOTICE("\The [usr] puts [W] into [src]."))
				else if (W && W.volumeClass >= ITEM_SIZE_NORMAL) //Otherwise they can only see large or normal items from a distance...
					M.show_message(SPAN_NOTICE("\The [usr] puts [W] into [src]."))


	update_icon()
	return 1

// custom for drywet
/obj/item/reagent_containers/drywet/proc/drywet_poured_into(obj/item/reagent_containers/W, mob/user)
	if(untaken_capacity == 0)
		to_chat(user, SPAN_NOTICE("[src] is full."))
		return TRUE

	if(!W.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("[W] is empty."))
		return TRUE // if it returns false, it drains from its target when empty

	var/cantrans = min(W.amount_per_transfer_from_this, untaken_capacity)
	var/trans = W.reagents.trans_to(src, cantrans)
	untaken_capacity -= cantrans
	to_chat(user, SPAN_NOTICE("You transfer [trans] units of the solution to [src]."))
	playsound(src,'sound/effects/Liquid_transfer_mono.ogg',50,1)
	user.investigate_log("transfered [trans] units from [W]([reagents.log_list()]) to [src]([reagents.log_list()])", "chemistry")

// also copied from obj/item/storage
/obj/item/reagent_containers/drywet/proc/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(!istype(W)) return //Not an item

	if(usr && usr.isEquipped(W) && !usr.canUnEquip(W))
		return FALSE

	if(src.loc == W)
		return FALSE //Means the item is already in the storage item

	if(W.anchored)
		return FALSE


	if (largestdimension != null && W.volumeClass > largestdimension)
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("[W] is too large for this [src]."))
		return FALSE

	if((untaken_capacity  -  (W.get_storage_cost() ** 2)) < 0)
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("[src] is too full, make some space."))
		return FALSE

	if(W.volumeClass >= src.volumeClass && (istype(W, /obj/item/storage)||istype(W, /obj/item/reagent_containers/drywet)))
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("[src] cannot hold [W] as it's a storage item of the same size."))
		return FALSE //To prevent the stacking of same sized storage items.


	return TRUE
/obj/item/reagent_containers/drywet/attackby(obj/item/W, mob/user)
	..()

	if(!can_be_inserted(W))
		return FALSE

	if(istype(W, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = W
		if(container.is_drainable())
			drywet_poured_into(container, user)
			W.add_fingerprint(user)
			return TRUE

	return handle_item_insertion(W)

// copied from obj/item/storage
/obj/item/reagent_containers/drywet/proc/remove_from_storage(obj/item/W, atom/new_location)
	if (!istype(W))
		return

	if (new_location)
		W.forceMove(new_location)
	else
		W.forceMove(get_turf(src))

	untaken_capacity = min(untaken_capacity + W.get_storage_cost() ** 2, )
	solids.Remove(W)
	W.on_exit_storage(src)
	update_icon()

/obj/item/reagent_containers/drywet/attack_hand(mob/user)
	add_fingerprint(user)
	if(user.get_inactive_hand() == src)
		var/obj/item/taken = pickweight_n_take(solids)
		if(taken)
			untaken_capacity += taken.get_storage_cost() ** 2
			taken.add_fingerprint(user)
			taken.pickup(user)
			to_chat(user,"You remove [taken] from [src].")
			user.setClickCooldown(3)
	else
		. = ..()
