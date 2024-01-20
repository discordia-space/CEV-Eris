////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/hypospray
	name = "hypospray"
	desc = "The Moebius Medical department hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 40
	possible_transfer_amounts = null
	reagent_flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	preloaded_reagents = list("bicaridine" = 40)
	//spawn_blacklisted = TRUE//antag_item_targets?

/obj/item/reagent_containers/hypospray/attack(mob/living/M as mob, mob/user as mob)
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
		var/obj/item/rig/RIG = H.get_equipped_item(slot_back)
		if((istype(RIG) && RIG.suit_is_deployed()) || istype(SS))
			injtime = 30
			var/obj/item/organ/external/affected = H.get_organ(BP_CHEST)
			if(BP_IS_ROBOTIC(affected))
				to_chat(user, SPAN_WARNING("Injection port on [M]'s suit is refusing your [src]."))
				// I think rig is advanced enough for this, and people will learn what causes this error
				if(RIG)
					playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 1, -3)
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

/obj/item/reagent_containers/hypospray/verb/empty()
	set name = "Empty Hypospray"
	set category = "Object"
	set src in usr

	if (alert(usr, "Are you sure you want to empty that?", "Empty Bottle:", "Yes", "No") != "Yes")
		return
	if(isturf(usr.loc))
		to_chat(usr, SPAN_NOTICE("You empty \the [src] onto the floor."))
		reagents.splash(usr.loc, reagents.total_volume)

/obj/item/reagent_containers/hypospray/autoinjector
	name = "autoinjector (inaprovaline)"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	volumeClass = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	icon_state = "autoinjector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 5
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1)
	reagent_flags = REFILLABLE | DRAINABLE | AMOUNT_VISIBLE
	volume = 5
	preloaded_reagents = list("inaprovaline" = 5)
	spawn_blacklisted = TRUE
	var/image/filling_overlay

/obj/item/reagent_containers/hypospray/autoinjector/on_reagent_change()
	..()
	if(reagents.total_volume <= 0) //Prevents autoinjectors from being refilled.
		reagent_flags &= ~REFILLABLE

/obj/item/reagent_containers/hypospray/autoinjector/update_icon()
	cut_overlays()
	if(reagents && reagents.total_volume > 0)
		icon_state = initial(icon_state)
		filling_overlay = mutable_appearance('icons/obj/reagentfillings.dmi', "autoinjector")
		filling_overlay.color = reagents.get_color()
		add_overlay(filling_overlay)
	else
		if(reagents && reagents.total_volume <= 0)
			filling_overlay = mutable_appearance('icons/obj/reagentfillings.dmi', "autoinjector0")
			filling_overlay.color = reagents.get_color()
			add_overlay(filling_overlay)
			icon_state = "[initial(icon_state)]0"

// TRADE
/obj/item/reagent_containers/hypospray/autoinjector/antitoxin
	name = "autoinjector (anti-toxin)"
	preloaded_reagents = list("anti_toxin" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/tricordrazine
	name = "autoinjector (tricordrazine)"
	preloaded_reagents = list("tricordrazine" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/kelotane
	name = "autoinjector (kelotane)"
	preloaded_reagents = list("kelotane" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/bicaridine
	name = "autoinjector (bicaridine)"
	preloaded_reagents = list("bicaridine" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/antirad
	name = "autoinjector (anti-rad)"
	preloaded_reagents = list("hyronalin" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/dexalin
	name = "autoinjector (dexalin)"
	preloaded_reagents = list("dexalin" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/spaceacillin
	name = "autoinjector (spaceacillin)"
	preloaded_reagents = list("spaceacillin" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/tramadol
	name = "autoinjector (tramadol)"
	preloaded_reagents = list("tramadol" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/polystem
	name = "autoinjector (polystem)"
	preloaded_reagents = list("polystem" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/meralyne
	name = "autoinjector (meralyne)"
	preloaded_reagents = list("meralyne" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/dermaline
	name = "autoinjector (dermaline)"
	preloaded_reagents = list("dermaline" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/dexalinplus
	name = "autoinjector (dexalin plus)"
	preloaded_reagents = list("dexalinp" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/oxycodone
	name = "autoinjector (oxycodone)"
	preloaded_reagents = list("oxycodone" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/ryetalyn
	name = "autoinjector (ryetalyn)"
	preloaded_reagents = list("ryetalyn" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/hyperzine
	name = "autoinjector (hyperzine)"
	preloaded_reagents = list("hyperzine" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/drugs
	name = "autoinjector (drugs)"
	preloaded_reagents = list("space_drugs" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/quickhealbrute
	name = "autoinjector (brute-aid)"
	preloaded_reagents = list("bicaridine" = 1, "meralyne" = 1, "seligitillin" = 1, "tricordrazine" = 1, "polystem" = 1)
	price_tag = 100

/obj/item/reagent_containers/hypospray/autoinjector/quickhealburn
	name = "autoinjector (burn-aid)"
	preloaded_reagents = list("kelotane" = 1.25, "dermaline" = 1.25, "tricordrazine" = 1.25, "polystem" = 1.25)
	price_tag = 100

/obj/item/reagent_containers/hypospray/autoinjector/bloodclot
	name = "autoinjector (blood clotting, type 1)"
	preloaded_reagents = list("thrombopoietin" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/bloodclot_alt
	name = "autoinjector (blood clotting, type 2)"
	preloaded_reagents = list("thromboxane" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/bloodrestore
	name = "autoinjector (blood restoration, type 1)"
	preloaded_reagents = list("aldosterone" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/bloodrestore_alt
	name = "autoinjector (blood restoration, type 2)"
	preloaded_reagents = list("erythropoietin" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/painkiller
	name = "autoinjector (painkiller, type 1)"
	preloaded_reagents = list("enkephalin" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/painkiller_alt
	name = "autoinjector (painkiller, type 2)"
	preloaded_reagents = list("endomorphin" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/speedboost
	name = "autoinjector (agility, type 1)"
	preloaded_reagents = list("osteocalcin" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/speedboost_alt
	name = "autoinjector (agility, type 2)"
	preloaded_reagents = list("noradrenaline" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/oxygenation
	name = "autoinjector (oxygenation, type 1)"
	preloaded_reagents = list("dexterone" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/oxygenation_alt
	name = "autoinjector (oxygenation, type 2)"
	preloaded_reagents = list("vasotriene" = 5)
