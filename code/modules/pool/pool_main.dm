//contains some of the base code that the pool tiles themselves are based off of. Also cotains the water and water/top overlay effects.
/turf/open/
	var/footstep_sound = "water"
/turf/open/pool
	icon = 'icons/turf/floors.dmi'
	name = "poolwater"
	desc = "You're safer here than in the deep."
	icon_state = "white"
	heat_capacity = INFINITY
	var/filled = TRUE
	var/next_splash = 0
	var/obj/effect/overlay/water/watereffect
	var/obj/effect/overlay/water/top/watertop
	color = "#38e4ff"
	footstep_sound = "water"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/open/pool/Initialize(mapload)
	. = ..()
	update_icon()

/turf/open/pool/update_icon()
	. = ..()
	if(!filled)
		name = "drained pool"
		desc = "No diving!"
		QDEL_NULL(watereffect)
		QDEL_NULL(watertop)
	else
		name = "poolwater"
		desc = "You're safer here than in the deep."
		watereffect = new /obj/effect/overlay/water(src)
		watertop = new /obj/effect/overlay/water/top(src)

/obj/effect/overlay/water
	name = "water"
	icon = 'icons/turf/pool.dmi'
	icon_state = "bottom"
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	anchored = TRUE

/obj/effect/overlay/water/top
	icon_state = "top"
	layer = BELOW_MOB_LAYER

/turf/open/pool/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if((user.loc != src) && !user.incapacitated() && Adjacent(user) && filled && (next_splash < world.time))
		playsound(src, 'sound/effects/watersplash.ogg', 100, TRUE, 1)
		next_splash = world.time + 25
		var/obj/effect/splash/S = new(src)
		animate(S, alpha = 0, time = 8)
		QDEL_IN(S, 10)
		for(var/mob/living/carbon/human/H in src)
			if(!H.wear_mask && (H.stat == CONSCIOUS))
				H.emote("cough")
//code saved for potential use in future projects
/*
/turf/open/pool/Entered(atom/A, atom/OL)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		to_chat(usr, SPAN_DANGER("Movement is admin-disabled.") ) //This is to identify lag problems
		return

	if (isliving(A))
		var/mob/living/M = A
		if(M.lying)
			return ..()

		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			//Footstep sounds. This proc is in footsteps.dm
			H.handle_footstep(src)
	..()
*/