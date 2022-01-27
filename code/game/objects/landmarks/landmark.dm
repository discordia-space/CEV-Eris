/obj/landmark
	name = "landmark"
	icon = 'icons/misc/landmarks.dmi'
	alpha = 64 //Or else they cover half of the69ap
	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = 101
	layer =69ID_LANDMARK_LAYER
	var/delete_me = FALSE

/obj/landmark/New()
	..()
	GLOB.landmarks_list += src

/obj/landmark/proc/delete()
	delete_me = TRUE

/obj/landmark/Initialize(mapload)
	. = ..()
	if(delete_me)
		return INITIALIZE_HINT_69DEL

/obj/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()



