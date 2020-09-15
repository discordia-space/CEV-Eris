/obj/machinery/plumbing/disposer
	name = "chemical disposer"
	desc = "Breaks down chemicals and annihilates them."
	icon_state = "disposal"
	///we remove 10 reagents per second
	var/disposal_rate = 5

/obj/machinery/plumbing/disposer/Initialize(mapload, d=0)
	. = ..()
	AddComponent(/datum/component/plumbing/demand, anchored)

/obj/machinery/plumbing/disposer/Process()
	if(stat & NOPOWER)
		return
	if(reagents.total_volume)
		if(icon_state != initial(icon_state) + "_working") //threw it here instead of update icon since it only has two states
			icon_state = initial(icon_state) + "_working"
		reagents.remove_any(disposal_rate)
	else
		if(icon_state != initial(icon_state))
			icon_state = initial(icon_state)

