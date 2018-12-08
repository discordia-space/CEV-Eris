/obj/effect/spawner/maintshroom
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"

/obj/effect/spawner/maintshroom/Initialize()
	..()
	new /obj/effect/plant(get_turf(src), new /datum/seed/mushroom/maintshroom)
	find_or_create_burrow(get_turf(src)) //Make sure there's a burrow near maintshrooms so they can spread
	return INITIALIZE_HINT_QDEL
