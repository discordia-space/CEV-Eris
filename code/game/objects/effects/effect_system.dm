/* This is an attempt to make some easily reusable "particle" type effect, to stop the code
constantly having to be rewritten. An item like the jetpack that uses the ion_trail_follow system, just has one
defined, then set up when it is created with New(). Then this same system can just be reused each time
it needs to create more trails.A beaker could have a steam_trail_follow system set up, then the steam
would spawn and follow the beaker, even if it is carried or thrown.
*/

/obj/effect
	name = "effect"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = 0
	unacidable = 1//So effect are not targeted by alien acid.
	pass_flags = PASSTABLE | PASSGRILLE
	var/random_rotation = 0 //If 1, pick a random cardinal direction. if 2, pick a randomised angle


/obj/effect/New()
	.=..()
	if (random_rotation)
		var/matrix/M = transform
		if (random_rotation == 1)
			M.Turn(pick(0,90,180,-90))

		else if (random_rotation == 2)
			M.Turn(rand(0,360))

		transform = M

/obj/effect/Destroy()
	if(reagents)
		reagents.delete()
	return ..()

/datum/effect/system
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
/obj/effect/steam
	name = "steam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "jet"
	density = 0

/datum/effect/system/steam_spread

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
				var/obj/effect/steam/steam = new(location)
				var/direction
				if(src.cardinals)
					direction = pick(cardinal)
				else
					direction = pick(alldirs)
				for(i=0, i<pick(1,2,3), i++)
					sleep(5)
					step(steam,direction)
				spawn(20)
					qdel(steam)



/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////


/obj/effect/smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = 1
	anchored = 0.0
	mouse_opacity = 0
	var/amount = 6.0
	var/time_to_live = 100
	var/fading = FALSE

	//Remove this bit to use the old smoke
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	pixel_y = -32


/obj/effect/smoke/Initialize()
	spawn(time_to_live)
		fade_out()


/obj/effect/smoke/Crossed(mob/living/carbon/M as mob )
	..()
	if(istype(M))
		affect(M)

/obj/effect/smoke/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	. = ..()
	for(var/mob/living/carbon/M in get_turf(src))
		affect(M)

/obj/effect/smoke/proc/affect(var/mob/living/carbon/M)
	if (istype(M))
		return 0
	if (M.internal != null)
		if(M.wear_mask && (M.wear_mask.item_flags & AIRTIGHT))
			return 0
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.head && (H.head.item_flags & AIRTIGHT))
				return 0
		return 0
	return 1


// Fades out the smoke smoothly using it's alpha variable.
/obj/effect/smoke/proc/fade_out(var/frames = 16)
	if(!alpha) return //already transparent
	fading = TRUE
	frames = max(frames, 1) //We will just assume that by 0 frames, the coder meant "during one frame".
	var/alpha_step = round(alpha / frames)
	while(alpha > 0)
		alpha = max(0, alpha - alpha_step)
		sleep(world.tick_lag)
	qdel(src)

/////////////////////////////////////////////
// Illumination
/////////////////////////////////////////////
/obj/effect/light
	name = "light"
	opacity = FALSE
	mouse_opacity = FALSE
	icon_state = "nothing"
	var/radius = 3
	var/brightness = 2

/obj/effect/light/New(var/newloc, var/radius, var/brightness)
	..()

	src.radius = radius
	src.brightness = brightness

	set_light(radius,brightness)

/obj/effect/light/set_light(l_range, l_power, l_color)
	..()
	radius = l_range
	brightness = l_power

/obj/effect/smoke/illumination
	name = "illumination"
	opacity = 0
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"

/obj/effect/smoke/illumination/New(var/newloc, var/brightness=15, var/lifetime=10)
	time_to_live=lifetime
	..()
	set_light(brightness)

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/smoke/bad
	time_to_live = 200

/obj/effect/smoke/bad/affect(var/mob/living/carbon/M)
	if (!..())
		return 0
	M.drop_item()
	M.adjustOxyLoss(1)
	if (M.coughedtime != 1)
		M.coughedtime = 1
		M.emote("cough")
		spawn ( 20 )
			M.coughedtime = 0

/obj/effect/smoke/bad/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover, /obj/item/projectile/beam))
		var/obj/item/projectile/beam/B = mover
		B.damage = (B.damage/2)
	return 1
/////////////////////////////////////////////
// Sleep smoke
/////////////////////////////////////////////


/obj/effect/smoke/sleepy/affect(mob/living/carbon/M as mob )
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
// Mustard Gas
/////////////////////////////////////////////


/obj/effect/smoke/mustard
	name = "mustard gas"
	icon_state = "mustard"


/obj/effect/smoke/mustard/affect(var/mob/living/carbon/human/R)
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

/datum/effect/system/smoke_spread
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction
	var/smoke_type = /obj/effect/smoke

/datum/effect/system/smoke_spread/set_up(n = 5, c = 0, loca, direct)
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

/datum/effect/system/smoke_spread/start()
	var/i = 0
	if(holder)
		src.location = get_turf(holder)
	for(i=0, i<src.number, i++)
		spawn()
			var/obj/effect/smoke/smoke = new smoke_type(location)
			var/direction
			if(cardinals)
				direction = pick(cardinal)
			else
				direction = pick(alldirs)

			for(i=0, i<pick(0,1,1,1,2,2,2,3), i++)
				sleep(10)
				step(smoke,direction)


/datum/effect/system/smoke_spread/bad
	smoke_type = /obj/effect/smoke/bad

/datum/effect/system/smoke_spread/sleepy
	smoke_type = /obj/effect/smoke/sleepy


/datum/effect/system/smoke_spread/mustard
	smoke_type = /obj/effect/smoke/mustard





/datum/effect/system/reagents_explosion
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
			var/datum/effect/system/spark_spread/s = new
			s.set_up(2, 1, location)
			s.start()

			for(var/mob/M in viewers(5, location))
				M << SPAN_WARNING("The solution violently explodes.")
			for(var/mob/M in viewers(1, location))
				if (prob (50 * amount))
					M << SPAN_WARNING("The explosion knocks you down.")
					M.Weaken(rand(1,5))
			return
		else
			var/devst = -1
			var/heavy = -1
			var/light = -1
			var/flash = -1

			// Clamp all values to fractions of max_explosion_range, following the same pattern as for tank transfer bombs
			if (round(amount/12) > 0)
				devst = devst + amount/12

			if (round(amount/6) > 0)
				heavy = heavy + amount/6

			if (round(amount/3) > 0)
				light = light + amount/3

			if (flashing && flashing_factor)
				flash = (amount/4) * flashing_factor

			for(var/mob/M in viewers(8, location))
				M << SPAN_WARNING("The solution violently explodes.")

			explosion(
				location,
				round(min(devst, BOMBCAP_DVSTN_RADIUS)),
				round(min(heavy, BOMBCAP_HEAVY_RADIUS)),
				round(min(light, BOMBCAP_LIGHT_RADIUS)),
				round(min(flash, BOMBCAP_FLASH_RADIUS))
				)
