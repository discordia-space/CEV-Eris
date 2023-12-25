/obj/effect/effect/water
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	mouse_opacity = 0
	pass_flags = PASSTABLE | PASSGRILLE

/obj/effect/effect/water/New(loc)
	..()
	spawn(150) // In case whatever made it forgets to delete it
		if(src)
			qdel(src)

/obj/effect/effect/water/proc/set_color() // Call it after you move reagents to it
	icon += reagents.get_color()

/obj/effect/effect/water/proc/set_up(var/turf/target, var/step_count = 5, var/delay = 5)
	if(!target)
		return
	for(var/i = 1 to step_count)
		if(!loc)
			return
		step_towards(src, target)
		var/turf/T = get_turf(src)
		if(T && reagents)
			reagents.touch_turf(T)
			var/list/mob/affected_mobs = new
			for (var/atom/A in T)
				if (ismob(A))
					affected_mobs |= A
				else if (A.simulated)
					reagents.touch(A)

			for (var/mob/M in affected_mobs)
				reagents.splash(M, reagents.total_volume/affected_mobs.len, min_spill=0, max_spill=0)

			if (affected_mobs.len)
				break

			if (T == get_turf(target))
				break
		sleep(delay)
	sleep(10)
	qdel(src)

/obj/effect/effect/water/Move(var/atom/NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0, initiator = src)
	if(NewLoc.density)
		return 0

	return ..()

/obj/effect/effect/water/Bump(atom/A)
	if(reagents)
		reagents.touch(A)
	return ..()

//Used by spraybottles.
/obj/effect/effect/water/chempuff
	name = "chemicals"
	icon = 'icons/obj/chempuff.dmi'
	icon_state = ""
