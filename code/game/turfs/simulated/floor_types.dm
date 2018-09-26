/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/simulated/shuttle/floor/mining
	icon_state = "6,19"
	icon = 'icons/turf/shuttlemining.dmi'

/turf/simulated/shuttle/floor/science
	icon_state = "8,15"
	icon = 'icons/turf/shuttlescience.dmi'

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"
	level = 1

/turf/simulated/shuttle/plating/is_plating()
	return TRUE


turf/simulated/floor/plating
	icon = 'icons/turf/flooring/plating.dmi'
	name = "plating"
	icon_state = "plating"
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS
	initial_flooring = /decl/flooring/reinforced/plating

/turf/simulated/floor/plating/under
	name = "underplating"
	icon_state = "under"
	icon = 'icons/turf/flooring/plating.dmi'
	initial_flooring = /decl/flooring/reinforced/plating/under
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS

/turf/simulated/floor/plating/under/Entered(mob/living/M as mob)
	..()
	for(var/obj/structure/catwalk/C in get_turf(src))
		return

	//BSTs need this or they generate tons of soundspam while flying through the ship
	if(!ishuman(M)|| M.incorporeal_move || !has_gravity(src))
		return
	if(M.m_intent == "run")
		if(prob(40))
			M.adjustBruteLoss(5)
			M.slip(null, 6)
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
			M << SPAN_WARNING("You tripped over!")
			return

/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass

/turf/simulated/floor/dirt
	name = "dirt"
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_state = "dirt"
	initial_flooring = /decl/flooring/dirt

/turf/simulated/floor/hull
	name = "hull"
	icon = 'icons/turf/flooring/hull.dmi'
	icon_state = "hullcenter0"
	initial_flooring = /decl/flooring/reinforced/plating/hull


/turf/simulated/floor/hull/New()
	if(icon_state != "hullcenter0")
		overrided_icon_state = icon_state
	..()

/turf/simulated/shuttle/plating/vox //Skipjack plating
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/simulated/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/simulated/shuttle/floor4/vox //skipjack floors
	name = "skipjack floor"
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD
