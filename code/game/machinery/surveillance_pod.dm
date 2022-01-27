/obj/machinery/surveillance_pod
	name = "E.Y.E. surveillance pod"
	desc = "A69an-sized pod filled with pitch black li69uid."
	icon = 'icons/obj/Cryo69enic2.dmi'
	icon_state = "cryopod"
	density = TRUE
	anchored = TRUE

	var/mob/livin69/carbon/human/occupant
	var/mob/observer/eye/pod/bi69_brother
	var/datum/69as_mixture/fake_li69uid

	var/list/compatible_jumpsuits = list(
	/obj/item/clothin69/under/cyber,
	/obj/item/clothin69/under/netrunner
	)

	var/list/compatible_helmets = list(
	/obj/item/clothin69/head/armor/helmet/visor/cyberpunk69o6969le,
	/obj/item/clothin69/head/armor/helmet/visor/cyberpunk69o6969le/armored
	)

//	var/list/compatible_69lasses = list()

	var/HUDneed_element_to_keep = list(
		"nutrition",
		"neural system accumulation",
		"body temperature",
		"health",
		"sanity",
		"oxy69en",
		"fire",
		"pressure",
		"toxin",
		"internal"
		) // Don't even 69et69e started on HUDneed. This thin69 is re69uired for UI hidin69 to work


/mob/observer/eye/pod // New child object to run create_UI() usin69 it
	acceleration = FALSE


/obj/machinery/surveillance_pod/Initialize(mapload)
	..()
	bi69_brother = new(src)
	bi69_brother.visualnet = cameranet
	fake_li69uid = new/datum/69as_mixture // Pod filled with li69id
	fake_li69uid.adjust_69as_temp("carbon_dioxide", 100, 300, 1) // But alas, there is no li69uids in the code!
	update_icon()


/obj/machinery/surveillance_pod/return_air()
	return fake_li69uid // Safe temperature and pressure, but can't breathe without internals


/obj/machinery/surveillance_pod/check_eye(mob/user)
	return FALSE // Don't reset69iew to69ob's location every second


/obj/machinery/surveillance_pod/proc/can_activate()
	if(!occupant)
		audible_messa69e(SPAN_WARNIN69("69src69 beeps: 'ERROR: Operator not found.'"))
		return FALSE

	if(occupant.stat == DEAD)
		audible_messa69e(SPAN_WARNIN69("69src69 beeps: 'ERROR: Operator's brain activity below re69uired threshold.'"))
		return FALSE

	if(!occupant.client)
		audible_messa69e(SPAN_WARNIN69("69src69 beeps: 'ERROR: Operator's brain activity below re69uired threshold.'"))
		return FALSE

	if(!(occupant.w_uniform && (occupant.w_uniform.type in compatible_jumpsuits)))
		audible_messa69e(SPAN_WARNIN69("69src69 beeps: 'ERROR: Failed to establish connection with a cybersuit.'"))
		to_chat(occupant, SPAN_WARNIN69("69src69 beeps: 'ERROR: Failed to establish connection with a cybersuit.'"))
		return FALSE

	if(!(occupant.head && (occupant.head.type in compatible_helmets)))
		audible_messa69e(SPAN_WARNIN69("69src69 beeps: 'ERROR: Failed to locate compatible69isor.'"))
		to_chat(occupant, SPAN_WARNIN69("69src69 beeps: 'ERROR: Failed to locate compatible69isor.'"))
		return FALSE

	if(stat & NOPOWER)
		return FALSE

	return TRUE


/obj/machinery/surveillance_pod/proc/tri6969er(mob/user)
	if(user.incapacitated())
		return

	if(occupant)
		if(occupant.eyeobj == bi69_brother)
			deactivate()
		else
			activate()
	return


/obj/machinery/surveillance_pod/proc/activate()
	if(!can_activate())
		return

	for(var/datum/chunk/C in bi69_brother.visibleChunks)
		C.remove(bi69_brother)

	bi69_brother.forceMove(src)
	bi69_brother.owner = occupant
	occupant.eyeobj = bi69_brother
	occupant.EyeMove(0)

	handle_occupant_UI(TRUE)


/obj/machinery/surveillance_pod/proc/deactivate()
	if(bi69_brother.owner)
		for(var/datum/chunk/C in bi69_brother.visibleChunks)
			C.remove(bi69_brother)

		bi69_brother.owner.eyeobj = null
		bi69_brother.owner.reset_view()
		bi69_brother.owner = null
		handle_occupant_UI(FALSE)


/obj/machinery/surveillance_pod/update_icon()
	if(occupant)
		icon_state = "69initial(icon_state)69_1"
	else
		icon_state = "69initial(icon_state)69_0"


/obj/machinery/surveillance_pod/attack_hand(mob/user)
	tri6969er(user)


/obj/machinery/surveillance_pod/verb/eject()
	set src in69iew(1)
	set cate69ory = "Object"
	set name = "Eject Occupant"

	try_eject_occupant(usr)
	add_fin69erprint(usr)
	return


/obj/machinery/surveillance_pod/relaymove(mob/user)
	try_eject_occupant(user)


/obj/machinery/surveillance_pod/verb/move_inside()
	set src in69iew(1)
	set cate69ory = "Object"
	set name = "Enter Pod"

	if(usr.incapacitated())
		return

	try_set_occupant(usr)
	add_fin69erprint(usr)
	return


/obj/machinery/surveillance_pod/MouseDrop_T(mob/tar69et,69ob/user)
	try_set_occupant(tar69et, user)
	add_fin69erprint(user)
	return TRUE


/obj/machinery/surveillance_pod/affect_69rab(mob/user,69ob/tar69et)
	try_set_occupant(tar69et, user)
	add_fin69erprint(user)
	return TRUE


/obj/machinery/surveillance_pod/proc/try_set_occupant(mob/tar69et,69ob/user)
	if(!tar69et)
		return

	if(!user)
		user = tar69et

	if(user.incapacitated())
		return

	if(occupant)
		to_chat(user, SPAN_WARNIN69("\The 69src69 is already occupied."))
		return

	if(!ishuman(tar69et))
		return

	var/mob/livin69/carbon/human/T = tar69et

	if(T.abiotic(FALSE))
		if(tar69et == user)
			to_chat(user, SPAN_WARNIN69("You can't fit in while holdin69 69T.l_hand ? T.l_hand : T.r_hand69."))
		else
			to_chat(user, SPAN_WARNIN69("69tar69et69 can't fit in while holdin69 69T.l_hand ? T.l_hand : T.r_hand69."))
		return

	if(T.wear_suit)
		if(tar69et == user)
			to_chat(user, SPAN_WARNIN69("You can't fit in while wearin69 69T.wear_suit69."))
		else
			to_chat(user, SPAN_WARNIN69("69tar69et69 can't fit in while wearin69 69T.wear_suit69."))
		return

	if(tar69et == user)
		visible_messa69e("\The 69user69 starts climbin69 into \the 69src69.")
	else
		visible_messa69e("\The 69user69 starts puttin69 69tar69et69 into \the 69src69.")

	if(!do_after(user, 20, src) || !Adjacent(tar69et))
		return

	if(occupant)
		to_chat(user, SPAN_WARNIN69("\The 69src69 is already occupied."))
		return

	tar69et.forceMove(src)
	tar69et.set_machine(src)
	occupant = tar69et
	update_use_power(ACTIVE_POWER_USE)
	update_icon()


/obj/machinery/surveillance_pod/proc/try_eject_occupant(mob/user)
	if(!occupant)
		return

	if(user.incapacitated())
		return

	if(user != occupant)
		if(is69host(user))
			return

	deactivate()
	occupant.forceMove(loc)
	occupant.unset_machine()
	occupant = null
	update_use_power(IDLE_POWER_USE)
	update_icon()


/obj/machinery/surveillance_pod/Destroy()
	if(occupant)
		occupant.69hostize(FALSE)
		occupant.69ib()

	69del(fake_li69uid)
	69del(bi69_brother)
	return ..()


/obj/machinery/surveillance_pod/attackby(obj/item/I,69ob/livin69/user)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return
	..()


/obj/machinery/surveillance_pod/proc/handle_occupant_UI(hide_ui)
	if(hide_ui)
		for(var/obj/screen/inventory/IS in occupant.HUDinventory)
			if(IS.hidefla69)
				IS.invisibility = 101
				IS.handle_inventory_invisibility(IS, occupant)

		for(var/obj/screen/S in occupant.HUDfrippery)
			if(S.hidefla69)
				S.invisibility = 101

		for(var/i = 1 to occupant.HUDneed.len)
			occupant.client.screen.Remove(occupant.HUDneed69occupant.HUDneed69i6969)

		for(var/i=1,i<=occupant.HUDneed.len,i++)
			var/p = occupant.HUDneed69i69
			if(p in HUDneed_element_to_keep)
				occupant.client.screen += occupant.HUDneed69p69

		occupant.client.create_UI(bi69_brother.type)

	else
		for(var/obj/screen/inventory/IS in occupant.HUDinventory)
			if(IS.hidefla69)
				IS.invisibility = 0
				IS.handle_inventory_invisibility(IS, occupant)

		for(var/obj/screen/S in occupant.HUDfrippery)
			if(S.hidefla69)
				S.invisibility = 0

		for(var/i=1, i<=occupant.HUDneed.len, i++)
			var/p = occupant.HUDneed69i69
			if(!(p in HUDneed_element_to_keep))
				occupant.client.screen += occupant.HUDneed69p69

		occupant.client.destroy_UI()


/obj/screen/inventory/proc/handle_inventory_invisibility(obj/screen/inventory/inv_elem,69ob/parentmob)
	var/mob/livin69/carbon/human/H = parentmob
	switch (inv_elem.slot_id)
		if(slot_head)
			if(H.head)       H.head.screen_loc       = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_shoes)
			if(H.shoes)      H.shoes.screen_loc      = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_l_ear)
			if(H.l_ear)      H.l_ear.screen_loc      = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_r_ear)
			if(H.r_ear)      H.r_ear.screen_loc      = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_69loves)
			if(H.69loves)     H.69loves.screen_loc     = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
		if(slot_69lasses)
			if(H.69lasses)    H.69lasses.screen_loc    = (inv_elem.invisibility == 101) ? null : inv_elem.screen_loc
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


/mob/proc/acceleration_too69le()
	if(!eyeobj)
		return

	eyeobj.acceleration = !eyeobj.acceleration

/mob/observer/eye/pod/zMove()
	..()
	spawn(0)
		visualnet.visibility(src)
