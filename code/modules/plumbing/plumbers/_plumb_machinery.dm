/**Basic plumbing object.
* It doesn't really hold anything special, YET.
* Objects that are plumbing but not a subtype are as of writing liquid pumps and the reagent_dispenser tank
* Also please note that the plumbing component is toggled on and off by the component using a signal from default_unfasten_wrench, so dont worry about it
*/
/obj/machinery/plumbing
	name = "pipe thing"
	icon = 'icons/obj/plumbing/plumbers.dmi'
	icon_state = "pump"
	density = TRUE
	anchored = TRUE
	active_power_usage = 30
	use_power = ACTIVE_POWER_USE
	///Flags for reagents, like INJECTABLE, TRANSPARENT bla bla everything thats in DEFINES/reagents.dm
	reagent_flags = TRANSPARENT
	///Plumbing machinery is always gonna need reagents, so we might aswell put it here
	var/buffer = 50
	///wheter we partake in rcd construction or not
	var/rcd_constructable = TRUE
	///cost of the plumbing rcd construction
	var/rcd_cost = 15
	///delay of constructing it throught the plumbing rcd
	var/rcd_delay = 10

/obj/machinery/plumbing/Initialize(mapload, d)
	. = ..()
	create_reagents(buffer, reagent_flags)

/obj/machinery/plumbing/on_update_icon()
	..()
	cut_overlays()
	var/list/new_overlays = update_overlays()
	if(new_overlays.len)
		for(var/overlay in new_overlays)
			add_overlays(overlay)

/obj/machinery/plumbing/verb/rotate()
	set category = "Object"
	set name = "Rotate plumbing"
	set src in view(1)
	if (!can_be_rotated(usr))
		return
	src.set_dir(turn(dir, 90))

/obj/machinery/plumbing/proc/can_be_rotated(mob/user)
	if(usr.stat || usr.restrained() || anchored) 
		return FALSE
	return TRUE

/obj/machinery/plumbing/bottler/attack_hand()
	interact()
	..()

/obj/machinery/plumbing/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("The maximum volume display reads: <b>[reagents.maximum_volume] units</b>."))

/obj/machinery/plumbing/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/tool/plunger))
		to_chat(user, SPAN_NOTICE("You start furiously plunging [name]."))
		if(do_after(user, 30, target = src))
			to_chat(user, SPAN_NOTICE("You finish plunging the [name]."))
			reagents.touch_turf(get_turf(src)) //splash on the floor
			reagents.clear_reagents()
		return TRUE
	if(QUALITY_BOLT_TURNING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			set_anchored(!anchored)
			user.visible_message(SPAN_NOTICE("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor."), \
							SPAN_NOTICE("You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor."), \
							"You hear a ratchet")
			return TRUE
	if(QUALITY_WELDING in I.tool_qualities)
		if(anchored)
			to_chat(user, SPAN_WARNING("The [name] needs to be unbolted to do that!"))
		to_chat(user, SPAN_NOTICE("You start slicing the [name] apart."))
		if(I.use_tool(user, src, rcd_delay * 2, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			dismantle()
			to_chat(user, SPAN_NOTICE("You slice the [name] apart."))
			return TRUE
	..()

///We can empty beakers in here and everything
/obj/machinery/plumbing/input
	name = "input gate"
	desc = "Can be manually filled with reagents from containers."
	icon_state = "pipe_input"
	reagent_flags = TRANSPARENT | REFILLABLE
	rcd_cost = 5
	rcd_delay = 5

/obj/machinery/plumbing/input/Initialize(mapload, d=0)
	. = ..()
	AddComponent(/datum/component/plumbing/supply, anchored)

///We can fill beakers in here and everything. we dont inheret from input because it has nothing that we need
/obj/machinery/plumbing/output
	name = "output gate"
	desc = "A manual output for plumbing systems, for taking reagents directly into containers."
	icon_state = "pipe_output"
	reagent_flags = TRANSPARENT | DRAINABLE
	rcd_cost = 5
	rcd_delay = 5

/obj/machinery/plumbing/output/Initialize(mapload, d=0)
	. = ..()
	AddComponent(/datum/component/plumbing/demand, anchored)

/obj/machinery/plumbing/tank
	name = "chemical tank"
	desc = "A massive chemical holding tank."
	icon_state = "tank"
	buffer = 400
	rcd_cost = 25
	rcd_delay = 20

/obj/machinery/plumbing/tank/Initialize(mapload, d=0)
	. = ..()
	AddComponent(/datum/component/plumbing/tank, anchored)
