/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen/
	name = "Gravitational Singularity Generator"
	desc = "An esoteric and69ery complicated device designed to produce a gravitational singularity when stimulated by Alpha particles. Handle with care."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = FALSE
	density = TRUE
	use_power =69O_POWER_USE
	var/energy = 0

/obj/machinery/the_singularitygen/Process()
	var/turf/T = get_turf(src)
	if(src.energy >= 200)
		new /obj/singularity/(T, 50)
		if(src) qdel(src)

/obj/machinery/the_singularitygen/attackby(obj/item/I,69ob/user)
	if(QUALITY_BOLT_TURNING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
			anchored = !anchored
			if(anchored)
				user.visible_message("69user.name69 secures 69src.name69 to the floor.", \
					"You secure the 69src.name69 to the floor.", \
					"You hear a ratchet")
			else
				user.visible_message("69user.name69 unsecures 69src.name69 from the floor.", \
					"You unsecure the 69src.name69 from the floor.", \
					"You hear a ratchet")
			return
	return ..()
