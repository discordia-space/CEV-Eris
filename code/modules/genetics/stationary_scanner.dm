/obj/machinery/cryo_slab
	name = "Chrysalis Pod"
	desc = "Stationary dna sequencer."
	icon = 'icons/obj/eris_genetics.dmi'
	icon_state = "cybercoffin_open"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/electronics/circuitboard/cryo_slab
	use_power = IDLE_POWER_USE
	idle_power_usage = 60
	active_power_usage = 10000
	var/mob/living/carbon/human/han_solo


/obj/machinery/cryo_slab/Destroy()
	if(han_solo)
		han_solo.ghostize(0)
		han_solo.gib()
	return ..()


/obj/machinery/cryo_slab/relaymove(mob/user)
	if(user.incapacitated())
		return
	go_out()
	return


/obj/machinery/cryo_slab/verb/eject()
	set src in view(1)
	set category = "Object"
	set name = "Eject Occupant"

	if(usr.incapacitated())
		return
	go_out()
	add_fingerprint(usr)
	return


/obj/machinery/cryo_slab/verb/move_inside()
	set src in view(1)
	set category = "Object"
	set name = "Enter [src]"

	if(usr.incapacitated() || !ishuman(usr))
		return
	if(han_solo)
		to_chat(usr, SPAN_WARNING("[src] is already occupied!"))
		return
	if(usr.abiotic())
		to_chat(usr, SPAN_WARNING("Subject cannot have abiotic items on."))
		return
	set_occupant(usr)
	add_fingerprint(usr)
	return


/obj/machinery/cryo_slab/proc/go_out()
	if (!han_solo)
		return

	for(var/obj/O in src)
		O.forceMove(loc)
	han_solo.forceMove(loc)
	han_solo.reset_view()
	han_solo.unset_machine()
	han_solo = null
	set_power_use(IDLE_POWER_USE)
	update_icon()


/obj/machinery/cryo_slab/proc/set_occupant(mob/living/carbon/human/user)
	if(han_solo || !istype(user))
		return
	add_fingerprint(user)
	user.forceMove(src)
	han_solo = user
	set_power_use(ACTIVE_POWER_USE)
	user.set_machine(src)
	update_icon()


/obj/machinery/cryo_slab/affect_grab(mob/user, mob/target)
	if(han_solo)
		to_chat(user, SPAN_NOTICE("[src] is already occupied!"))
		return
	if(target.buckled)
		to_chat(user, SPAN_NOTICE("Unbuckle the subject before attempting to move them."))
		return
	if(target.abiotic())
		to_chat(user, SPAN_NOTICE("Subject cannot have abiotic items on."))
		return
	set_occupant(target)
	add_fingerprint(user)
	return TRUE


/obj/machinery/cryo_slab/MouseDrop_T(mob/target, mob/user)
	if(!ishuman(target))
		return
	if(han_solo)
		to_chat(user, SPAN_WARNING("[src] is already occupied!"))
		return
	if(target.abiotic())
		to_chat(user, SPAN_WARNING("Subject cannot have abiotic items on."))
		return
	if(target.buckled)
		to_chat(user, SPAN_NOTICE("Unbuckle the subject before attempting to move them."))
		return
	user.visible_message(
		SPAN_NOTICE("\The [user] begins placing \the [target] into \the [src]."),
		SPAN_NOTICE("You start placing \the [target] into \the [src]."))
	if(!do_after(user, 30, src) || !Adjacent(target))
		return
	set_occupant(target)
	add_fingerprint(user)
	return


/obj/machinery/cryo_slab/attackby(obj/item/I, mob/living/user)
	if(default_part_replacement(I, user))
		return

	if(default_deconstruction(I, user))
		return

	..()


/obj/machinery/cryo_slab/update_icon()
	..()
	if(han_solo)
		icon_state = "cybercoffin_closed"
	else
		icon_state = "cybercoffin_open"
