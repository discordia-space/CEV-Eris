/obj/machinery/power/nano_compressor
	name = "Nano compressor"
	desc = "Using alien technologies , this machine goes to the limit of the laws of physics to compress matter."
	icon = 'icons/obj/machines/compressor.dmi'
	icon_state = "compressor"
	active_power_usage = 5000000 // 5 MW to compress matter
	idle_power_usage = 0
	use_power = NO_POWER_USE
	var/retracted = TRUE
	var/obj/machinery/compressor_feeder/linked_feeder = null
	var/making = FALSE


/obj/machinery/power/nano_compressor/Initialize()
	linked_feeder = new(loc)
	extend_or_retract()
	. = ..()

/obj/machinery/power/nano_compressor/proc/extend_or_retract()
	if(retracted)
		linked_feeder.forceMove(locate(x + 1, y, z))
	else
		linked_feeder.forceMove(src)

/obj/machinery/power/nano_compressor/Process()
	var/power_drawed = draw_power(active_power_usage)
	if(power_drawed < active_power_usage)
		stat &= NOPOWER
	else
		stat |= NOPOWER

/obj/machinery/power/nano_compressor/attack_hand(mob/user)
	if(making)
		return FALSE
	if(!linked_feeder.can_make_stabilizer())
		to_chat(user , SPAN_NOTICE("There isn't enough matter in the feeder to produce a stabilizer core!"))
		return FALSE
	making = TRUE
	use_power = TRUE
	flick("[initial(icon_state)]_start", src)
	spawn(27) // Seconds that the animation above finishes
		if(stat & NOPOWER)
			flick("initial(icon_state)]_open_empty", src)
			to_chat(user, SPAN_NOTICE("There isn't enough power to compress!"))
			making = FALSE
			use_power = FALSE
			return
		flick("[initial(icon_state)]_compressing", src)
		spawn(20)
			if(stat & NOPOWER)
				flick("initial(icon_state)]_open_empty", src)
				to_chat(user, SPAN_NOTICE("There isn't enough power to compress!"))
				making = FALSE
				use_power = FALSE
				return
			flick("[initial(icon_state)]_open", src)
			spawn(27)
				new /obj/item/core_stabilizer(get_turf(src))
				visible_message("\The stabilizer core rapidly expands as \the [src] pushes it out")
				making = FALSE
				use_power = FALSE
				linked_feeder.empty_matter()

/obj/item/core_stabilizer
	name = "Stabilization core"
	desc = "A shiny plasma-hydrogen-diamond sphere made by an alien machine , created under immense stress ,it posseses exotic phenomens"
	icon = 'icons/obj/machines/compressor.dmi'
	icon_state = "stabilization core"
	price_tag = 10000

