/* This is an attempt to make some easily reusable "particle" type effect, to stop the code
constantly having to be rewritten. An item like the jetpack that uses the ion_trail_follow system, just has one
defined, then set up when it is created with New(). Then this same system can just be reused each time
it needs to create more trails.A beaker could have a steam_trail_follow system set up, then the steam
would spawn and follow the beaker, even if it is carried or thrown.
*/

/obj/effect
	var/random_rotation = 0 //If 1, pick a random cardinal direction. if 2, pick a randomised angle
	var/random_offset = 0

/obj/effect/effect
	name = "effect"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = 0
	unacidable = 1//So effect are not targeted by alien acid.
	pass_flags = PASSTABLE | PASSGRILLE


/obj/effect/Initialize(mapload, ...)
	. = ..()
	if (random_rotation)
		var/matrix/M = transform
		if (random_rotation == 1)
			M.Turn(pick(0,90,180,-90))

		else if (random_rotation == 2)
			M.Turn(rand(0,360))

		transform = M
	if(random_offset)
		pixel_x += rand(-random_offset,random_offset)
		pixel_y += rand(-random_offset,random_offset)

/datum/effect/effect/system
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder
	var/setup = 0

	proc/set_up(n = 3, c = 0, turf/loc)
		if(n > 10)
			n = 10
		number = n
		cardinals = c
		location = loc
		setup = 1

	proc/attach(atom/atom)
		holder = atom

	proc/start()


/////////////////////////////////////////////
// GENERIC STEAM SPREAD SYSTEM

//Usage: set_up(number of bits of steam, use North/South/East/West only, spawn location)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like a smoking beaker, so then you can just call start() and the steam
// will always spawn at the items location, even if it's moved.

/* Example:
var/datum/effect/system/steam_spread/steam = new /datum/effect/system/steam_spread() -- creates new system
steam.set_up(5, 0, mob.loc) -- sets up variables
OPTIONAL: steam.attach(mob)
steam.start() -- spawns the effect
*/
/////////////////////////////////////////////
/obj/effect/effect/steam
	name = "steam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "jet"
	density = FALSE

/datum/effect/effect/system/steam_spread

	set_up(n = 3, c = 0, turf/loc)
		if(n > 10)
			n = 10
		number = n
		cardinals = c
		location = loc

	start()
		var/i = 0
		for(i=0, i<src.number, i++)
			spawn(0)
				if(holder)
					src.location = get_turf(holder)
				var/obj/effect/effect/steam/steam = new(location)
				var/direction
				if(src.cardinals)
					direction = pick(cardinal)
				else
					direction = pick(alldirs)
				for(var/j=0, j<pick(1,2,3), j++)
					sleep(5)
					step(steam,direction)
				spawn(20)
					qdel(steam)

/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/proc/do_sparks(n, c, source)
	// n - number of sparks
	// c - cardinals, bool, do the sparks only move in cardinal directions?
	// source - source of the sparks.

	var/datum/effect/effect/system/spark_spread/sparks = new
	sparks.set_up(n, c, source)
	sparks.start()

/obj/effect/sparks
	name = "sparks"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	anchored = TRUE
	mouse_opacity = 0
	var/amount = 6

/obj/effect/sparks/New()
	..()
	playsound(src.loc, "sparks", 100, 1)
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)

/obj/effect/sparks/Initialize()
	. = ..()
	QDEL_IN(src, 10 SECONDS)

/obj/effect/sparks/Destroy()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)
	return ..()

/obj/effect/sparks/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	. = ..()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)

/datum/effect/effect/system/spark_spread
	var/total_sparks = 0 // To stop it being spammed and lagging!

/datum/effect/effect/system/spark_spread/set_up(n = 3, c = 0, loca)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

/datum/effect/effect/system/spark_spread/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_sparks > 20)
			return
		if(holder)
			src.location = get_turf(holder)
		var/obj/effect/sparks/sparks = new(location)
		src.total_sparks++
		var/direction
		if(src.cardinals)
			direction = pick(cardinal)
		else
			direction = pick(alldirs)
		for(var/j=0, j<pick(1,2,3), j++)
			addtimer(CALLBACK(src, PROC_REF(do_spark_movement), sparks, direction), rand(1,5) SECONDS)
			//sleep(rand(1,5))
			//step(sparks,direction)

		addtimer(CALLBACK(src, PROC_REF(delete_spark), sparks), 2 SECONDS)
		/*
		spawn(20)
			if(sparks)
				qdel(sparks)
			src.total_sparks--
		*/

/datum/effect/effect/system/spark_spread/proc/do_spark_movement(atom/movable/sparks, direction)
	step(sparks, direction)

/datum/effect/effect/system/spark_spread/proc/delete_spark(atom/movable/sparks)
	if(!QDELETED(sparks))
		qdel(sparks)
	total_sparks--



/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////


/obj/effect/effect/smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = 1
	anchored = FALSE
	mouse_opacity = 0
	var/amount = 6
	var/time_to_live = 100
	var/fading = FALSE

	//Remove this bit to use the old smoke
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	pixel_y = -32


/obj/effect/effect/smoke/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(fade_out), time_to_live))


/obj/effect/effect/smoke/Crossed(mob/living/carbon/M as mob )
	..()
	if(istype(M))
		affect(M)

/obj/effect/effect/smoke/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	. = ..()
	for(var/mob/living/carbon/M in get_turf(src))
		affect(M)

/obj/effect/effect/smoke/proc/affect(var/mob/living/carbon/M)
	if (istype(M))
		return 0
	if (M.internal != null)
		if(M.wear_mask && (M.wear_mask.item_flags & BLOCK_GAS_SMOKE_EFFECT & AIRTIGHT))
			return 0
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.head && (H.head.item_flags & BLOCK_GAS_SMOKE_EFFECT & AIRTIGHT))
				return 0
		return 0
	return 1


// Fades out the smoke smoothly using it's alpha variable.
/obj/effect/effect/smoke/proc/fade_out(var/frames = 16)
	if(!alpha) return //already transparent
	fading = TRUE
	frames = max(frames, 1) //We will just assume that by 0 frames, the coder meant "during one frame".
	var/alpha_step = round(alpha / frames)
	fade_step(alpha_step)

/obj/effect/effect/smoke/proc/fade_step(alpha_step)
	if(alpha > 0)
		alpha = max(0, alpha - alpha_step)
		addtimer(CALLBACK(src, PROC_REF(fade_step), alpha_step), 1 SECOND)
		if(alpha < initial(alpha)/2)
			opacity = FALSE
	else
		qdel(src)

/////////////////////////////////////////////
// Illumination
/////////////////////////////////////////////
/obj/effect/effect/light
	name = "light"
	opacity = FALSE
	mouse_opacity = FALSE
	icon_state = "nothing"
	var/radius = 3
	var/brightness = 2

/obj/effect/effect/light/New(var/newloc, var/radius, var/brightness, color, selfdestruct_timer)
	..()

	src.radius = radius
	src.brightness = brightness

	set_light(radius,brightness,color)

	if(selfdestruct_timer)
		spawn(selfdestruct_timer)
		qdel(src)

/obj/effect/effect/light/set_light(l_range, l_power, l_color)
	..()
	radius = l_range
	brightness = l_power
	color = l_color

/obj/effect/effect/smoke/illumination
	name = "illumination"
	opacity = 0
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"

/obj/effect/effect/smoke/illumination/New(var/newloc, var/brightness=15, var/lifetime=10, var/color=COLOR_WHITE)
	time_to_live=lifetime
	..()
	set_light(brightness, 1, color)

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/bad
	time_to_live = 200

/obj/effect/effect/smoke/bad/affect(var/mob/living/carbon/M)
	if (!..())
		return 0
	M.drop_item()
	M.adjustOxyLoss(1)
	if (M.coughedtime != 1)
		M.coughedtime = 1
		M.emote("cough")
		spawn ( 20 )
			M.coughedtime = 0

/obj/effect/effect/smoke/bad/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover, /obj/item/projectile/beam))
		var/obj/item/projectile/beam/B = mover
		B.damage_types[BURN] /= 2
	return 1
/////////////////////////////////////////////
// Sleep smoke
/////////////////////////////////////////////


/obj/effect/effect/smoke/sleepy/affect(mob/living/carbon/M as mob )
	if (!..())
		return 0

	M.drop_item()
	M:sleeping += 1
	if (M.coughedtime != 1)
		M.coughedtime = 1
		M.emote("cough")
		spawn ( 20 )
			M.coughedtime = 0
/////////////////////////////////////////////
//  White phosphorous
/////////////////////////////////////////////

/obj/effect/effect/smoke/white_phosphorous
    name = "white phosphorous smoke"

/obj/effect/effect/smoke/white_phosphorous/affect(mob/living/carbon/M)
    M.fire_stacks += 5
    M.fire_act()

/////////////////////////////////////////////
// Mustard Gas
/////////////////////////////////////////////


/obj/effect/effect/smoke/mustard
	name = "mustard gas"
	icon_state = "mustard"


/obj/effect/effect/smoke/mustard/affect(var/mob/living/carbon/human/R)
	if (!..())
		return 0
	if (R.wear_suit != null)
		return 0

	R.burn_skin(0.75)
	if (R.coughedtime != 1)
		R.coughedtime = 1
		R.emote("gasp")
		spawn (20)
			R.coughedtime = 0
	R.updatehealth()
	return

/////////////////////////////////////////////
// Smoke spread
/////////////////////////////////////////////

/datum/effect/effect/system/smoke_spread
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction
	var/smoke_type = /obj/effect/effect/smoke

/datum/effect/effect/system/smoke_spread/set_up(n = 5, c = 0, loca, direct)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct

/datum/effect/effect/system/smoke_spread/start()
	var/i = 0
	if(holder)
		src.location = get_turf(holder)
	for(i=0, i<src.number, i++)
		var/obj/effect/effect/smoke/smoke = new smoke_type(location)
		var/direction
		if(cardinals)
			direction = pick(cardinal)
		else
			direction = pick(alldirs)
		var/added_time = 1 SECOND
		for(var/j=0, j<pick(0,1,1,1,2,2,2,3), j++)
			addtimer(CALLBACK(src, PROC_REF(move_smoke), smoke, direction), added_time)
			added_time += 1 SECOND

/datum/effect/effect/system/smoke_spread/proc/move_smoke(atom/movable/smoke, move_dir)
	step(smoke, move_dir)


/datum/effect/effect/system/smoke_spread/bad
	smoke_type = /obj/effect/effect/smoke/bad

/datum/effect/effect/system/smoke_spread/sleepy
	smoke_type = /obj/effect/effect/smoke/sleepy


/datum/effect/effect/system/smoke_spread/mustard
	smoke_type = /obj/effect/effect/smoke/mustard

/datum/effect/effect/system/smoke_spread/white_phosphorous
    smoke_type = /obj/effect/effect/smoke/white_phosphorous





/datum/effect/effect/system/reagents_explosion
	var/amount 						// TNT equivalent
	var/flashing = 0			// does explosion creates flash effect?
	var/flashing_factor = 0		// factor of how powerful the flash effect relatively to the explosion

	set_up (amt, loc, flash = 0, flash_fact = 0)
		amount = amt
		if(istype(loc, /turf/))
			location = loc
		else
			location = get_turf(loc)

		flashing = flash
		flashing_factor = flash_fact

		return

	start()
		if (amount <= 2)
			var/datum/effect/effect/system/spark_spread/s = new
			s.set_up(2, 1, location)
			s.start()

			for(var/mob/M in viewers(5, location))
				to_chat(M, SPAN_WARNING("The solution violently explodes."))
			for(var/mob/M in viewers(1, location))
				if (prob (50 * amount))
					to_chat(M, SPAN_WARNING("The explosion knocks you down."))
					M.Weaken(rand(1,5))
			return
		else
			var/explosion_power = amount
			for(var/mob/M in viewers(8, location))
				to_chat(M, SPAN_WARNING("The solution violently explodes."))

			explosion(get_turf(location), explosion_power, explosion_power / 10)
