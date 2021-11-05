/obj/machinery/power/nano_compressor
	name = "Nano compressor"
	desc = "Using alien technologies , this machine goes to the limit of the laws of physics to compress matter."
	icon = 'icons/obj/machines/compressor.dmi'
	icon_state = "compressor"
	active_power_usage = 36000000 //36  MW to compress matter, 3 fully upgraded transmission SMES's
	idle_power_usage = 0
	use_power = NO_POWER_USE
	density = TRUE
	anchored = TRUE
	var/retracted = TRUE
	var/obj/machinery/compressor_feeder/linked_feeder = null
	var/making = FALSE

/* Just a note for the future , if anyone wants to actually code a NanoUI / HTMLui , this could also be used to convert materials to other materials , after all , it is kinda doing fusion */

/obj/machinery/power/nano_compressor/Initialize()
	linked_feeder = new(loc)
	extend_or_retract()
	. = ..()
	STOP_PROCESSING(SSmachines,src)


/obj/machinery/power/nano_compressor/RefreshParts()
	return FALSE // alien tech

/obj/machinery/power/nano_compressor/proc/extend_or_retract()
	if(retracted)
		linked_feeder.forceMove(get_step(src, EAST))
	else
		linked_feeder.forceMove(src)
	retracted = !retracted


/obj/machinery/power/nano_compressor/wrenched_change()
	if(!retracted)
		extend_or_retract()


/obj/machinery/power/nano_compressor/verb/extend_retract()
	set src in view(1)
	set name = "Retract/Extend feeder"
	set category = "Object"

	if(isghost(usr) || usr.incapacitated(INCAPACITATION_ALL))
		return FALSE
	if(!ishuman(usr))
		return FALSE
	var/mob/living/carbon/human/user = usr
	if(!user.IsAdvancedToolUser())
		return FALSE
	if(!anchored)
		to_chat(user, SPAN_NOTICE("You can't expand the feeder unless the [src] is secured to the ground!"))
		return FALSE
	extend_or_retract()

/obj/machinery/power/nano_compressor/Process()
	if(!powernet)
		return PROCESS_KILL
	var/power_drain = draw_power(active_power_usage)// draw the power
	if(power_drain > active_power_usage - 1)
		stat |= NOPOWER
	else
		stat &= ~NOPOWER

/obj/machinery/power/nano_compressor/attackby(obj/item/W, mob/user)
	if(W.get_tool_quality(QUALITY_BOLT_TURNING))
		visible_message("[user] begins [anchored ? "unwrenching" : "wrenching"] [src]'s securing bolts", "You hear bolts being turned", 6)
		if(W.use_tool(user, src, WORKTIME_SLOW, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			if(!retracted)
				extend_or_retract()
			anchored = !anchored
			visible_message("[user] [anchored ? "anchors" : "deanchors"] [src]", "You hear bolts being turned", 6)

/obj/machinery/power/nano_compressor/proc/stop_sequence(flick, msg)
	if(flick)
		flick("initial(icon_state)]_open_empty", src)
	if(msg)
		visible_message(SPAN_NOTICE("There isn't enough power to compress!"), "You hear a loud negative ping", 6)
	making = FALSE
	use_power = FALSE
	STOP_PROCESSING(SSmachines,src)
	linked_feeder.using = FALSE

/obj/machinery/power/nano_compressor/attack_hand(mob/user)
	if(making)
		return FALSE
	if(!linked_feeder.can_make_stabilizer())
		to_chat(user , SPAN_NOTICE("There isn't enough matter in the feeder to produce a stabilizer core!"))
		return FALSE
	if(!powernet)
		to_chat(user, SPAN_NOTICE("\The [src] needs a direct connection to a power grid to function"))
	making = TRUE
	use_power = TRUE
	linked_feeder.using = TRUE
	START_PROCESSING(SSmachines,src)
	flick("[initial(icon_state)]_start", src)
	spawn(25) // 0.2 seconds before animation finishes
		if(stat & NOPOWER)
			stop_sequence(TRUE, TRUE)
			return
		flick("[initial(icon_state)]_compressing", src)
		spawn(18)
			if(stat & NOPOWER)
				stop_sequence(TRUE, TRUE)
				return
			flick("[initial(icon_state)]_open", src)
			spawn(25)
				var/obj/item/core_stabilizer/created_core = new /obj/item/core_stabilizer(get_turf(src))
				created_core.quality_multiplier = max(0.1,powernet.avail / active_power_usage) // Go big. reach for the stars , or lose power the last moment and eat dirt..
				created_core.price_tag = price_tag * created_core.quality_multiplier
				visible_message("\The stabilizer core rapidly expands as \the [src] pushes it out")
				linked_feeder.empty_matter()
				stop_sequence(FALSE, FALSE)

/obj/item/core_stabilizer
	name = "Stabilization core"
	desc = "A shiny plasma-hydrogen-diamond sphere made by an alien machine , created under immense stress ,it posseses exotic phenomens"
	icon = 'icons/obj/machines/compressor.dmi'
	icon_state = "stabilization core"
	price_tag = 10000 // price gets multiplied the more power there is
	origin_tech = list(TECH_ARCANE = 4, TECH_BLUESPACE = 8, TECH_ENGINEERING = 12)
	var/quality_multiplier = 1 // This gets bigger the more extra energy we had into the grid

