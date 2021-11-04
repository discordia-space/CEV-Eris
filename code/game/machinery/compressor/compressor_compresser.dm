/obj/machinery/power/nano_compressor
	name = "Nano compressor"
	desc = "Using alien technologies , this machine goes to the limit of the laws of physics to compress matter."
	icon = 'icon/obj/machines/compressor.dmi'
	icon_state = "compressor"
	active_power_usage = 5000000 // 5 MW to compress matter
	idle_power_usage = 0
	use_power = NO_POWER_USE
	var/retracted = FALSE
	var/obj/machinery/compressor_feeder/linked_feeder = null
	var/making = FALSE

/obj/machinery/nano_compressor/Initialize()
	linked_feeder = new(loc)
	extend_or_retract()
	. = ..()

/obj/machinery/nano_compressor/proc/extend_or_retract()
	if(retracted)
		linked_feeder.forceMove(get_step(src, EAST))
	else
		linked_feeder.forceMove(src)

/obj/machinery/nano_compressor/process()
	draw_power(active_power_usage)

/obj/machinery/nano_compressor/attack_hand(mob/user)
	if(making)
		return FALSE
	if(!linked_feeder.can_make_stabilizer())
		to_chat(user , SPAN_NOTICE("There isn't enough matter in the feeder to produce a stabilizer core!"))
	making = TRUE
	use_power = TRUE
	flick("[initial(icon_state)]_start")
	spawn(27) // Seconds that the animation above finishes
	if(stat & NOPOWER)
		flick("initial(icon_state)]_open_empty")
		to_chat(user, SPAN_NOTICE("There isn't enough power to compress!"))
		making = FALSE
		use_power = FALSE
		return
	flick("[initial(icon_state)]_compressing")
	spawn(20)
	if(stat & NOPOWER)
		flick("initial(icon_state)]_open_empty")
		to_chat(user, SPAN_NOTICE("There isn't enough power to compress!"))
		making = FALSE
		use_power = FALSE
		return
	flick("[initial(icon_state)]_open")
	spawn(27)
	new /obj/item/core_stabilizer(get_turf(src))
	visible_message("\The stabilizer core rapidly expands as \the [src] pushes it out")
	making = FALSE
	use_power = FALSE
	linked_feeder.empty_matter()

/obj/item/core_stabilizer
	name = "Stabilization core"
	desc = "A shiny plasma-hydrogen-diamond sphere made by an alien machine , created under immense stress ,it posseses exotic phenomens"
	icon = 'icon/obj/machines/compressor.dmi'
	icon_state = "stabilization_core"

