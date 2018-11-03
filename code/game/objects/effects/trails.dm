/*********************************
	Trail systems
**********************************

These systems register an Observation proc on their target atom, and generate a
particle whenever the target moves
*****************/


/datum/effect/effect/system/trail
	var/obj/effect/effect/trail_effect = /obj/effect/trail_particle/gasjet
	var/active = FALSE

	var/copy_pixel_offsets = TRUE

/datum/effect/effect/system/trail/set_up(atom/atom)
	attach(atom)

/datum/effect/effect/system/trail/start()
	//We can't start unless we're attached to an atom
	if (!holder || active)
		return

	//Moved event is a global datum of type /decl/observ/moved
	//It will fire a proc whenever the holder atom moves from one turf to another
	moved_event.register(holder, src, /datum/effect/effect/system/trail/proc/holder_moved)

	active = TRUE


/datum/effect/effect/system/trail/proc/holder_moved(var/atom/A, var/atom/old_loc)
	do_effect(old_loc, get_dir(A, old_loc))

/datum/effect/effect/system/trail/proc/do_effect(var/turf/eloc, var/newdir)
	var/obj/effect/effect/E = new trail_effect(eloc)
	E.set_dir(newdir)
	if (copy_pixel_offsets)
		var/list/offsets = holder.get_total_pixel_offset()
		E.pixel_x = offsets["x"]
		E.pixel_y = offsets["y"]
		world << "Ofsets set to

/datum/effect/effect/system/trail/proc/stop()
	moved_event.register(holder, src, /datum/effect/effect/system/trail/proc/holder_moved)
	active = FALSE

/////////////////////////////////////////////
	//Ion trail, not used much now
/////////////////////////////////////////////

/obj/effect/effect/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"
	anchored = 1.0

/datum/effect/effect/system/trail/ion
	trail_effect = /obj/effect/effect/ion_trails


	/*start()
		if(!src.on)
			src.on = 1
			src.processing = 1
		if(src.processing)
			src.processing = 0
			spawn(0)
				var/turf/T = get_turf(src.holder)
				if(T != src.oldposition)
					if(istype(T, /turf/space))
						var/obj/effect/effect/ion_trails/I = new(oldposition)
						src.oldposition = T
						I.set_dir(src.holder.dir)
						flick("ion_fade", I)
						I.icon_state = "blank"
						spawn( 20 )
							qdel(I)*/


/////////////////////////////////////////////
//Steam trail, unused
/////////////////////////////////////////////

/datum/effect/effect/system/trail/steam
	trail_effect = /obj/effect/trail_particle/gasjet



/********************************************************
	Jetpack Trails
	Subtype made to efficiently sync up with a jetpack.
	They should always be attached to a jetpack
	Does a particle only when the jetpack uses some thrust
**************************************************************/
/datum/effect/effect/system/trail/jet
	trail_effect = /obj/effect/trail_particle/gasjet

//Only do a thrust if the holder has the done var set false, and is also turned on
/datum/effect/effect/system/trail/jet/holder_moved(var/atom/A, var/atom/old_loc)
	var/obj/item/weapon/tank/jetpack/J = holder
	if (J && J.thrust_fx_done == FALSE && J.on)
		.=..()
		//Set it true after.
		J.thrust_fx_done = TRUE

		//It will be set false again next time the jetpack does more thrust




/*******************************
	Trail particles.
These are spawned by a trail system
Their only special behaviour atm is to delete themselves shortly after creation
********************************/
/obj/effect/trail_particle
	var/lifetime = 10
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = FALSE
	density = FALSE
	opacity = FALSE

/obj/effect/trail_particle/Initialize()
	addtimer(CALLBACK(src, .proc/finish, TRUE), lifetime)

/obj/effect/trail_particle/proc/finish()
	qdel(src)


/obj/effect/trail_particle/gasjet
	name = "pressurised gas"
	icon_state = "jet"