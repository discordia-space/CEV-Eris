////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 30
	possible_transfer_amounts = null
	reagent_flags = OPENCONTAINER
	slot_flags = SLOT_BELT

///obj/item/weapon/reagent_containers/hypospray/New() //comment this to make hypos start off empty
//	..()
//	reagents.add_reagent("tricordrazine", 30)
//	return

/obj/item/weapon/reagent_containers/hypospray/attack(mob/living/M as mob, mob/user as mob)
	if(!reagents.total_volume)
		to_chat(user, SPAN_WARNING("[src] is empty."))
		return
	if (!istype(M))
		return
	var/injtime //Injecting through a hardsuit takes long time due to needing to find a port.
	// Handling errors and injection duration
	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/clothing/suit/space/SS = H.get_equipped_item(slot_wear_suit)
		var/obj/item/weapon/rig/RIG = H.get_equipped_item(slot_back)
		if((istype(RIG) && RIG.suit_is_deployed()) || istype(SS))
			injtime = 30
			var/obj/item/organ/external/affected = H.get_organ(BP_CHEST)
			if(BP_IS_ROBOTIC(affected))
				to_chat(user, SPAN_WARNING("Injection port on [M]'s suit is refusing your [src]."))
				// I think rig is advanced enough for this, and people will learn what causes this error
				if(RIG)
					playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 1 -3)
					RIG.visible_message("\icon[RIG]\The [RIG] states \"Attention: User of this suit appears to be synthetic origin\".")
				return
		// check without message
		else if(!H.can_inject(user, FALSE))
			// lets check if user is easily fooled
			var/obj/item/organ/external/affected = H.get_organ(user.targeted_organ)
			if(BP_IS_LIFELIKE(affected) && user && user.stats.getStat(STAT_BIO) < STAT_LEVEL_BASIC)
				if(M.reagents)
					var/trans = reagents.remove_any(amount_per_transfer_from_this)
					user.visible_message(SPAN_WARNING("[user] injects [M] with [src]!"), SPAN_WARNING("You inject [M] with [src]."))
					to_chat(user, SPAN_NOTICE("[trans] units injected. [reagents.total_volume] units remaining in \the [src]."))
				return
			else
				// if he is not lets show him what actually happened
				H.can_inject(user, TRUE)
				return
	else if(!M.can_inject(user, TRUE))
		return
	// handling injection duration on others
	if(M != user)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(M)
		if(injtime)
			user.visible_message(SPAN_WARNING("[user] begins hunting for an injection port on [M]'s suit!"), SPAN_WARNING("You begins hunting for an injection port on [M]'s suit!"))
			if(do_mob(user, M, injtime))
				user.visible_message(SPAN_WARNING("[user] injects [M] with [src]!"), SPAN_WARNING("You inject [M] with [src]."))
			else
				return
	// handling actual injection
	// on this stage we are sure that everything is alright
	var/contained = reagents.log_list()
	var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
	admin_inject_log(user, M, src, contained, trans)
	to_chat(user, SPAN_NOTICE("[trans] units injected. [reagents.total_volume] units remaining in \the [src]."))
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	icon_state = "autoinjector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 5
	reagent_flags = REFILLABLE | DRAINABLE | AMOUNT_VISIBLE
	volume = 5
	preloaded_reagents = list("inaprovaline" = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/on_reagent_change()
	..()
	if(reagents.total_volume <= 0) //Prevents autoinjectors to be refilled.
		reagent_flags &= ~REFILLABLE

/obj/item/weapon/reagent_containers/hypospray/autoinjector/update_icon()
	if(reagents.total_volume > 0)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]0"


/obj/item/weapon/reagent_containers/hypospray/verb/empty()

	set name = "Empty Hypospray"
	set category = "Object"
	set src in usr

	if (alert(usr, "Are you sure you want to empty that?", "Empty Bottle:", "Yes", "No") != "Yes")
		return
	if(isturf(usr.loc))
		to_chat(usr, SPAN_NOTICE("You empty \the [src] onto the floor."))
		reagents.splash(usr.loc, reagents.total_volume)
