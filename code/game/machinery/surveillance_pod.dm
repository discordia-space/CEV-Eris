/obj/machinery/surveillance_pod
	name = "E.Y.E. surveillance pod"
	desc = "A man-sized pod filled with pitch black liquid."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cryopod"
	density = TRUE
	anchored = TRUE

	var/mob/living/carbon/human/occupant
	var/mob/observer/eye/big_brother
	var/datum/gas_mixture/environment

	var/list/compatible_jumpsuits = list(
	/obj/item/clothing/under/cyber
	)

	var/list/compatible_helmets = list(
	/obj/item/clothing/head/armor/helmet/visor/cyberpunkgoggle,
	/obj/item/clothing/head/armor/helmet/visor/cyberpunkgoggle/armored
	)

//	var/list/compatible_glasses = list()


/obj/machinery/surveillance_pod/New()
	..()
	big_brother = new(src)
	big_brother.visualnet = cameranet
	environment = new/datum/gas_mixture // Pod filled with liqid
	environment.adjust_gas_temp("carbon_dioxide", 100, 300, 1) // But alas, there is no liquids in the code!
	update_icon()


/obj/machinery/surveillance_pod/return_air()
	return environment // Safe temperature and pressure, but can't breathe without internals


/obj/machinery/surveillance_pod/check_eye(mob/user)
	return FALSE // Don't reset view to mob's location every second


/obj/machinery/surveillance_pod/proc/can_activate()
	if(!occupant)
		audible_message(SPAN_WARNING("[src] beeps: 'ERROR: Operator not found.'"))
		return FALSE

	if(occupant.stat == DEAD)
		audible_message(SPAN_WARNING("[src] beeps: 'ERROR: Operator's brain activity below required threshold.'"))
		return FALSE

	if(!occupant.client)
		audible_message(SPAN_WARNING("[src] beeps: 'ERROR: Operator's brain activity below required threshold.'"))
		return FALSE

	if(!(occupant.w_uniform && (occupant.w_uniform.type in compatible_jumpsuits)))
		audible_message(SPAN_WARNING("[src] beeps: 'ERROR: Failed to establish connection with a cybersuit.'"))
		to_chat(occupant, SPAN_WARNING("[src] beeps: 'ERROR: Failed to establish connection with a cybersuit.'"))
		return FALSE

	if(!(occupant.head && (occupant.head.type in compatible_helmets)))
		audible_message(SPAN_WARNING("[src] beeps: 'ERROR: Failed to locate compatible visor.'"))
		to_chat(occupant, SPAN_WARNING("[src] beeps: 'ERROR: Failed to locate compatible visor.'"))
		return FALSE

	if(stat & (BROKEN|NOPOWER))
		return FALSE

	return TRUE


/obj/machinery/surveillance_pod/proc/activate()
	if(!can_activate())
		return

	for(var/datum/chunk/C in big_brother.visibleChunks)
		C.remove(big_brother)
	big_brother.forceMove(src)
	big_brother.owner = occupant
	occupant.eyeobj = big_brother


/obj/machinery/surveillance_pod/proc/deactivate()
	if(big_brother.owner)
		for(var/datum/chunk/C in big_brother.visibleChunks)
			C.remove(big_brother)
		big_brother.owner.eyeobj = null
		big_brother.owner.reset_view()
		big_brother.owner = null


/obj/machinery/surveillance_pod/on_update_icon()
	if(occupant)
		icon_state = "[initial(icon_state)]_1"
	else
		icon_state = "[initial(icon_state)]_0"


/obj/machinery/surveillance_pod/verb/activate_verb()
	set src in view(0)
	set category = "Object"
	set name = "Activate Pod"

	if(usr.incapacitated())
		return

	if(occupant)
		if(occupant.eyeobj == big_brother)
			deactivate()
		else
			activate()
	return


/obj/machinery/surveillance_pod/verb/eject()
	set src in view(1)
	set category = "Object"
	set name = "Eject Occupant"

	if (usr.incapacitated())
		return

	eject_occupant()
	add_fingerprint(usr)
	return


/obj/machinery/surveillance_pod/relaymove(mob/user)
	if(user.incapacitated())
		return

	eject_occupant()


/obj/machinery/surveillance_pod/verb/move_inside()
	set src in view(1)
	set category = "Object"
	set name = "Enter Pod"

	try_set_occupant(usr)
	add_fingerprint(usr)
	return


/obj/machinery/surveillance_pod/MouseDrop_T(mob/target, mob/user)
	try_set_occupant(target, user)
	add_fingerprint(user)
	return TRUE


/obj/machinery/surveillance_pod/affect_grab(mob/user, mob/target)
	try_set_occupant(target, user)
	add_fingerprint(user)
	return TRUE


/obj/machinery/surveillance_pod/proc/try_set_occupant(mob/target, mob/user)
	if(!target)
		return

	if(!user)
		user = target

	if(user.incapacitated())
		return

	if(occupant)
		to_chat(user, SPAN_WARNING("\The [src] is already occupied."))
		return

	if(!ishuman(target))
		return

	var/mob/living/carbon/human/T = target

	if(T.abiotic(FALSE))
		if(target == user)
			to_chat(user, SPAN_WARNING("You can't fit in while holding [T.l_hand ? T.l_hand : T.r_hand]."))
		else
			to_chat(user, SPAN_WARNING("[target] can't fit in while holding [T.l_hand ? T.l_hand : T.r_hand]."))
		return

	if(T.wear_suit)
		if(target == user)
			to_chat(user, SPAN_WARNING("You can't fit in while wearing [T.wear_suit]."))
		else
			to_chat(user, SPAN_WARNING("[target] can't fit in while wearing [T.wear_suit]."))
		return

	if(target == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [target] into \the [src].")

	if(!do_after(user, 20, src) || !Adjacent(target))
		return

	if(occupant)
		to_chat(user, SPAN_WARNING("\The [src] is already occupied."))
		return

	target.forceMove(src)
	target.set_machine(src)
	occupant = target
	update_use_power(ACTIVE_POWER_USE)
	update_icon()


/obj/machinery/surveillance_pod/proc/eject_occupant()
	if(!occupant)
		return

	deactivate()
	occupant.forceMove(loc)
	occupant.unset_machine()
	occupant = null
	update_use_power(IDLE_POWER_USE)
	update_icon()


/obj/machinery/surveillance_pod/attack_hand(mob/user)
	if(occupant)
		if(occupant.eyeobj == big_brother)
			deactivate()
		else
			activate()


/obj/machinery/surveillance_pod/Destroy()
	if(occupant)
		occupant.ghostize(0)
		occupant.gib()

	qdel(environment)
	qdel(big_brother)
	return ..()


/obj/machinery/surveillance_pod/attackby(obj/item/I, mob/living/user)
	if(default_deconstruction(I, user))
		return
	if(default_part_replacement(I, user))
		return
	..()
