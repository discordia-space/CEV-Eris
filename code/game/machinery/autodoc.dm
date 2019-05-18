// Pretty much everything here is stolen from the dna scanner FYI


/obj/machinery/autodoc
	var/mob/living/carbon/occupant
	var/obj/machinery/autodoc_console/connected
	var/datum/autodoc/autodoc_processor = new()
	var/locked
	name = "Autodoc"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_off"
	density = 1
	anchored = 1

	use_power = 1
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.

/obj/machinery/autodoc/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/autodoc/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Autodoc"

	if (usr.stat != 0)
		return
	if (autodoc_processor.active)
		to_chat(usr, SPAN_WARNING("Autodoc is locked down!"))
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/autodoc/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Autodoc"

	if(usr.stat)
		return
	if(src.occupant)
		usr << SPAN_WARNING("The autodoc is already occupied!")
		return
	if(usr.abiotic())
		usr << SPAN_WARNING("The subject cannot have abiotic items on.")
		return
	set_occupant(usr)
	src.add_fingerprint(usr)
	return

/obj/machinery/autodoc/proc/go_out()
	if (!occupant || locked)
		return
	for(var/obj/O in src)
		O.forceMove(loc)
	src.occupant.forceMove(loc)
	src.occupant.reset_view()
	src.occupant = null
	autodoc_processor.patient = null
	update_use_power(1)
	update_icon()

/obj/machinery/autodoc/proc/set_occupant(var/mob/living/L)
	L.forceMove(src)
	src.occupant = L
	update_use_power(2)
	update_icon()
	src.add_fingerprint(usr)
	autodoc_processor.patient = L

/obj/machinery/autodoc/affect_grab(var/mob/user, var/mob/target)
	if (src.occupant)
		user << SPAN_NOTICE("The autodoc is already occupied!")
		return
	if(target.buckled)
		user << SPAN_NOTICE("Unbuckle the subject before attempting to move them.")
		return
	if(target.abiotic())
		user << SPAN_NOTICE("Subject cannot have abiotic items on.")
		return
	set_occupant(target)
	src.add_fingerprint(user)
	return TRUE

/obj/machinery/autodoc/MouseDrop_T(var/mob/target, var/mob/user)
	if(!ismob(target))
		return
	if (src.occupant)
		user << SPAN_WARNING("The autodoc is already occupied!")
		return
	if (target.abiotic())
		user << SPAN_WARNING("Subject cannot have abiotic items on.")
		return
	if (target.buckled)
		user << SPAN_NOTICE("Unbuckle the subject before attempting to move them.")
		return
	user.visible_message(
		SPAN_NOTICE("\The [user] begins placing \the [target] into \the [src]."),
		SPAN_NOTICE("You start placing \the [target] into \the [src].")
	)
	if(!do_after(user, 30, src) || !Adjacent(target))
		return
	set_occupant(target)
	src.add_fingerprint(user)
	return
/obj/machinery/autodoc/Process()
	. = ..()
	autodoc_processor.Process()
/obj/machinery/autodoc/Topic(href, href_list)
	return autodoc_processor.Topic(href, href_list)

/obj/machinery/autodoc/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A in src)
				A.forceMove(loc)
				A.ex_act(severity)
			qdel(src)
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A in src)
					A.forceMove(loc)
					A.ex_act(severity)
				qdel(src)
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A in src)
					A.forceMove(loc)
					A.ex_act(severity)
				qdel(src)

/obj/machinery/autodoc_console/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return

/obj/machinery/autodoc_console/power_change()
	..()
	update_icon()

/obj/machinery/autodoc_console
	var/obj/machinery/autodoc/connected
	var/datum/autodoc/autodoc_processor
	name = "Autodoc Console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_terminal_off"
	density = 1
	anchored = 1

/obj/machinery/autodoc_console/New()
	..()
	spawn(5)
		for(var/dir in cardinal)
			connected = locate(/obj/machinery/autodoc) in get_step(src, dir)
			if(connected)
				autodoc_processor = connected.autodoc_processor
				autodoc_processor.holder = connected
				return

/obj/machinery/autodoc_console/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/autodoc_console/attack_hand(user as mob)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		return
	if(!connected || (connected.stat & (NOPOWER|BROKEN)))
		to_chat(user, SPAN_WARNING("This console is not connected to a functioning autodoc."))
		return
	if(!ishuman(connected.occupant))
		to_chat(user, SPAN_WARNING("This device can only operate on compatible lifeforms."))
		return
	autodoc_processor.ui_interact(user)
/obj/machinery/autodoc_console/Topic(href, href_list)
	return autodoc_processor.Topic(href, href_list)