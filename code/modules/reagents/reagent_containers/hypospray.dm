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
		user << SPAN_WARNING("[src] is empty.")
		return
	if (!istype(M))
		return

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/affected = H.get_organ(user.targeted_organ)
		if(!affected)
			user << SPAN_DANGER("\The [H] is missing that limb!")
			return
		else if(affected.robotic >= ORGAN_ROBOT)
			user << SPAN_DANGER("You cannot inject a robotic limb.")
			return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)
	user << SPAN_NOTICE("You inject [M] with [src].")
	M << SPAN_NOTICE("You feel a tiny prick!")

	if(M.reagents)
		var/contained = reagents.log_list()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
		admin_inject_log(user, M, src, contained, trans)
		user << SPAN_NOTICE("[trans] units injected. [reagents.total_volume] units remaining in \the [src].")

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
	preloaded = list("inaprovaline" = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/on_reagent_change()
	..()
	if(reagents.total_volume <= 0) //Prevents autoinjectors to be refilled.
		reagent_flags &= ~REFILLABLE

/obj/item/weapon/reagent_containers/hypospray/autoinjector/update_icon()
	if(reagents.total_volume > 0)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]0"
