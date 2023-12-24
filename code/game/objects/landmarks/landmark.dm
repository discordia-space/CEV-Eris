/obj/landmark
	name = "landmark"
	icon = 'icons/misc/landmarks.dmi'
	alpha = 64 //Or else they cover half of the map
	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = 101
	layer = MID_LANDMARK_LAYER
	weight = 0
	var/delete_me = FALSE

/obj/landmark/New()
	..()
	GLOB.landmarks_list += src

/obj/landmark/proc/delete()
	delete_me = TRUE

/obj/landmark/Initialize(mapload)
	. = ..()
	if(delete_me)
		return INITIALIZE_HINT_QDEL

/obj/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()



