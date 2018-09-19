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
	footstep_sounds = list("human" = list(\
		'sound/effects/footstep/plating1.ogg',\
		'sound/effects/footstep/plating2.ogg',\
		'sound/effects/footstep/plating3.ogg',\
		'sound/effects/footstep/plating4.ogg',\
		'sound/effects/footstep/plating5.ogg'))

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

/turf/simulated/floor/plating/under/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if(R.amount <= 2)
			return
		else
			R.use(2)
			user << SPAN_NOTICE("You start connecting [R.name]s to [src.name], creating catwalk ...")
			if(do_after(user,50))
				src.alpha = 0
				var/obj/structure/catwalk/CT = new /obj/structure/catwalk(src.loc)
				src.contents += CT
			return
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
	footstep_sounds = list("human" = list(\
		'sound/effects/footstep/hull1.ogg',\
		'sound/effects/footstep/hull2.ogg',\
		'sound/effects/footstep/hull3.ogg',\
		'sound/effects/footstep/hull4.ogg',\
		'sound/effects/footstep/hull5.ogg'))

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
