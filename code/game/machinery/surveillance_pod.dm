/obj/machinery/surveillance_pod
	name = "E.Y.E. surveillance pod"
	desc = "A man-sized pod filled with pitch black liquid."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cryopod"
	density = TRUE
	anchored = TRUE

	var/mob/living/carbon/human/occupant
	var/mob/observer/eye/pod/big_brother
	var/datum/gas_mixture/fake_liquid

	var/list/compatible_jumpsuits = list(
	/obj/item/clothing/under/cyber,
	/obj/item/clothing/under/netrunner
	)

	var/list/compatible_helmets = list(
	/obj/item/clothing/head/armor/helmet/visor/cyberpunkgoggle,
	/obj/item/clothing/head/armor/helmet/visor/cyberpunkgoggle/armored
	)

//	var/list/compatible_glasses = list()

	var/HUDneed_element_to_keep = list(
		"nutrition",
		"neural system accumulation",
		"body temperature",
		"health",
		"sanity",
		"oxygen",
		"fire",
		"pressure",
		"toxin",
		"internal"
		) // Don't even get me started on HUDneed. This thing is required for UI hiding to work


/mob/observer/eye/pod // New child object to run create_UI() using it
	acceleration = FALSE


/obj/machinery/surveillance_pod/Initialize(mapload)
	..()
	big_brother = new(src)
	big_brother.visualnet = cameranet
	fake_liquid = new/datum/gas_mixture // Pod filled with liqid
	fake_liquid.adjust_gas_temp("carbon_dioxide", 100, 300, 1) // But alas, there is no liquids in the code!
	update_icon()


/obj/machinery/surveillance_pod/return_air()
	return fake_liquid // Safe temperature and pressure, but can't breathe without internals


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

	if(stat & NOPOWER)
		return FALSE

	return TRUE


/obj/machinery/surveillance_pod/proc/trigger(mob/user)
	if(user.incapacitated())
		return

	if(occupant)
		if(occupant.eyeobj == big_brother)
			deactivate()
		else
			activate()
	return


/obj/machinery/surveillance_pod/proc/activate()
	if(!can_activate())
		return

	for(var/datum/chunk/C in big_brother.visibleChunks)
		C.remove(big_brother)

	big_brother.forceMove(src)
	big_brother.owner = occupant
	occupant.eyeobj = big_brother
	occupant.EyeMove(0)

	handle_occupant_UI(TRUE)


/obj/machinery/surveillance_pod/proc/deactivate()
	if(big_brother.owner)
		for(var/datum/chunk/C in big_brother.visibleChunks)
			C.remove(big_brother)

		big_brother.owner.eyeobj = null
		big_brother.owner.reset_view()
		big_brother.owner = null
		handle_occupant_UI(FALSE)


/obj/machinery/surveillance_pod/update_icon()
	if(occupant)
		icon_state = "[initial(icon_state)]_1"
	else
		icon_state = "[initial(icon_state)]_0"


/obj/machinery/surveillance_pod/attack_hand(mob/user)
	trigger(user)


/obj/machinery/surveillance_pod/verb/eject()
	set src in view(1)
	set category = "Object"
	set name = "Eject Occupant"

	try_eject_occupant(usr)
	add_fingerprint(usr)
	return


/obj/machinery/surveillance_pod/relaymove(mob/user)
	try_eject_occupant(user)


/obj/machinery/surveillance_pod/verb/move_inside()
	set src in view(1)
	set category = "Object"
	set name = "Enter Pod"

	if(usr.incapacitated())
		return

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


/obj/machinery/surveillance_pod/proc/try_eject_occupant(mob/user)
	if(!occupant)
		return

	if(user.incapacitated())
		return

	if(user != occupant)
		if(isghost(user))
			return

	deactivate()
	occupant.forceMove(loc)
	occupant.unset_machine()
	occupant = null
	update_use_power(IDLE_POWER_USE)
	update_icon()


/obj/machinery/surveillance_pod/Destroy()
	if(occupant)
		occupant.ghostize(FALSE)
		occupant.gib()

	qdel(fake_liquid)
	qdel(big_brother)
	return ..()


/obj/machinery/surveillance_pod/attackby(obj/item/I, mob/living/user)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return
	..()


/obj/machinery/surveillance_pod/proc/handle_occupant_UI(hide_ui)
	if(hide_ui)
		for(var/obj/screen/inventory/IS in occupant.HUDinventory)
			if(IS.hideflag)
				IS.invisibility = 101
				IS.handle_inventory_invisibility(IS, occupant)

		for(var/obj/screen/S in occupant.HUDfrippery)
			if(S.hideflag)
				S.invisibility = 101

		for(var/i = 1 to occupant.HUDneed.len)
			occupant.client.screen.Remove(occupant.HUDneed[occupant.HUDneed[i]])

		for(var/i=1,i<=occupant.HUDneed.len,i++)
			var/p = occupant.HUDneed[i]
			if(p in HUDneed_element_to_keep)
				occupant.client.screen += occupant.HUDneed[p]

		occupant.client.create_UI(big_brother.type)

	else
		for(var/obj/screen/inventory/IS in occupant.HUDinventory)
			if(IS.hideflag)
				IS.invisibility = 0
				IS.handle_inventory_invisibility(IS, occupant)

		for(var/obj/screen/S in occupant.HUDfrippery)
			if(S.hideflag)
				S.invisibility = 0

		for(var/i=1, i<=occupant.HUDneed.len, i++)
			var/p = occupant.HUDneed[i]
			if(!(p in HUDneed_element_to_keep))
				occupant.client.screen += occupant.HUDneed[p]

		occupant.client.destroy_UI()


/obj/screen/inventory/proc/handle_inventory_invisibility(obj/screen/inventory/inv_elem, mob/parentmob)
	var/mob/living/carbon/human/H = parentmob
	switch (inv_elem.slot_id)
		if(slot_head)
			if(H.head)       H.head.screen_loc       = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_shoes)
			if(H.shoes)      H.shoes.screen_loc      = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_l_ear)
			if(H.l_ear)      H.l_ear.screen_loc      = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_r_ear)
			if(H.r_ear)      H.r_ear.screen_loc      = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_gloves)
			if(H.gloves)     H.gloves.screen_loc     = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_glasses)
			if(H.glasses)    H.glasses.screen_loc    = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_w_uniform)
			if(H.w_uniform)  H.w_uniform.screen_loc  = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_wear_suit)
			if(H.wear_suit)  H.wear_suit.screen_loc  = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_wear_mask)
			if(H.wear_mask)  H.wear_mask.screen_loc  = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_back)
			if(H.back)       H.back.screen_loc       = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_handcuffed)
			if(H.handcuffed) H.handcuffed.screen_loc = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_l_hand)
			if(H.l_hand)     H.l_hand.screen_loc     = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_r_hand)
			if(H.r_hand)     H.r_hand.screen_loc     = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_belt)
			if(H.belt)       H.belt.screen_loc       = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_wear_id)
			if(H.wear_id)    H.wear_id.screen_loc    = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_l_store)
			if(H.l_store)    H.l_store.screen_loc    = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_r_store)
			if(H.r_store)    H.r_store.screen_loc    = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_s_store)
			if(H.s_store)    H.s_store.screen_loc    = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc


/mob/proc/acceleration_toogle()
	if(!eyeobj)
		return

	eyeobj.acceleration = !eyeobj.acceleration

/mob/observer/eye/pod/zMove()
	..()
	spawn(0)
		visualnet.visibility(src)
