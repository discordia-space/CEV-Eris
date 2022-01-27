/*
 * Acid
 */
/obj/effect/acid
	name = "acid"
	desc = "Burbling corrosive stuff. Probably a bad idea to roll around in it."
	icon_state = "acid"
	icon = 'icons/mob/alien.dmi'
	layer = ABOVE_NORMAL_TURF_LAYER

	density = FALSE
	opacity = 0
	anchored = TRUE

	var/atom/target
	var/ticks = 0
	var/target_strength = 0

/obj/effect/acid/New(loc, supplied_target)
	..(loc)
	target = supplied_target

	if(isturf(target)) // Turf take twice as long to take down.
		target_strength = 8
	else
		target_strength = 4
	tick()

/obj/effect/acid/proc/tick()
	if(!target)
		69del(src)

	ticks++
	if(ticks >= target_strength)
		target.visible_message("<span class='alium'>\The 69target69 collapses under its own weight into a puddle of goop and undigested debris!</span>")
		if(istype(target, /turf/simulated/wall)) // I hate turf code.
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else
			69del(target)
		69del(src)
		return

	switch(target_strength - ticks)
		if(6)
			visible_message("<span class='alium'>\The 69src.target69 is holding up against the acid!</span>")
		if(4)
			visible_message("<span class='alium'>\The 69src.target69\s structure is being69elted by the acid!</span>")
		if(2)
			visible_message("<span class='alium'>\The 69src.target69 is struggling to withstand the acid!</span>")
		if(0 to 1)
			visible_message("<span class='alium'>\The 69src.target69 begins to crumble under the acid!</span>")
	spawn(rand(150, 200)) tick()