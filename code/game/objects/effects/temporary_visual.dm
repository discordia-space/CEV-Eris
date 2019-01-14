//temporary visual effects
/obj/effect/temp_visual
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = 1
	var/duration = 10 //in deciseconds
	var/randomdir = TRUE

/obj/effect/temp_visual/Initialize()
	. = ..()
	if(randomdir)
		dir = (pick(cardinal))

	QDEL_IN(src, duration)

/obj/effect/temp_visual/Destroy()
	. = ..()

/obj/effect/temp_visual/singularity_act()
	return

/obj/effect/temp_visual/singularity_pull()
	return

/obj/effect/temp_visual/ex_act()
	return

/obj/effect/temp_visual/dir_setting
	randomdir = FALSE

/obj/effect/temp_visual/dir_setting/Initialize(mapload, set_dir)
	if(set_dir)
		dir = set_dir
	. = ..()

/obj/effect/temp_visual/resourceInsertion
	randomdir = FALSE

/obj/effect/temp_visual/resourceInsertion/proc/setMaterial(var/material)
	return

/obj/effect/temp_visual/resourceInsertion/protolathe
	icon = 'icons/obj/machines/research.dmi'
	duration = 8

/obj/effect/temp_visual/resourceInsertion/protolathe/setMaterial(var/material)
	icon_state = "protolathe_[material]"
	if(!(icon_state in icon_states(icon)))
		icon_state = "protolathe_metal"
	..()

/obj/effect/temp_visual/resourceInsertion/mechfab
	icon = 'icons/obj/robotics.dmi'
	duration = 12

/obj/effect/temp_visual/resourceInsertion/mechfab/setMaterial(var/material)
	icon_state = "fab-load-[material]"
	if(!(icon_state in icon_states(icon)))
		icon_state = "fab-load-metal"
	..()

/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/obj/effect/temp_visual/sparks
	name = "sparks"
	icon_state = "sparks"
	duration = 20
	var/amount = 6.0

/obj/effect/temp_visual/sparks/New()
	..()
	playsound(src.loc, "sparks", 100, 1)
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)

/obj/effect/sparks/Destroy()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)
	return ..()

/obj/effect/temp_visual/sparks/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	. = ..()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)

/datum/effect/system/spark_spread
	var/total_sparks = 0 // To stop it being spammed and lagging!

	set_up(n = 3, c = 0, loca)
		if(n > 10)
			n = 10
		number = n
		cardinals = c
		if(istype(loca, /turf/))
			location = loca
		else
			location = get_turf(loca)

	start()
		var/i = 0
		for(i=0, i<src.number, i++)
			if(src.total_sparks > 20)
				return
			spawn(0)
				if(holder)
					src.location = get_turf(holder)
				var/obj/effect/temp_visual/sparks/sparks = new(location)
				src.total_sparks++
				var/direction
				if(src.cardinals)
					direction = pick(cardinal)
				else
					direction = pick(alldirs)
				for(i=0, i<pick(1,2,3), i++)
					sleep(rand(1,5))
					step(sparks,direction)
				spawn(20)
					if(sparks)
						qdel(sparks)
					src.total_sparks--