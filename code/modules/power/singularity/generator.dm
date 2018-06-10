/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen/
	name = "Gravitational Singularity Generator"
	desc = "An Odd Device which produces a Gravitational Singularity when set up."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = 0
	density = 1
	use_power = 0
	var/energy = 0

/obj/machinery/the_singularitygen/Process()
	var/turf/T = get_turf(src)
	if(src.energy >= 200)
		new /obj/singularity/(T, 50)
		if(src) qdel(src)

/obj/machinery/the_singularitygen/attackby(obj/item/I, mob/user)
	if(QUALITY_BOLT_TURNING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_PRD))
			anchored = !anchored
			if(anchored)
				user.visible_message("[user.name] secures [src.name] to the floor.", \
					"You secure the [src.name] to the floor.", \
					"You hear a ratchet")
			else
				user.visible_message("[user.name] unsecures [src.name] from the floor.", \
					"You unsecure the [src.name] from the floor.", \
					"You hear a ratchet")
			return
	return ..()
