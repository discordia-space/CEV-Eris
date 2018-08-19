/obj/effect/spawner/maintshroom
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"

/obj/effect/spawner/maintshroom/Initialize()
	..()

	new /obj/effect/plant(get_turf(src), new /datum/seed/mushroom/maintshroom)

	return INITIALIZE_HINT_QDEL
