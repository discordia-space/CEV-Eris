/obj/landmark/storyevent/proc/is_visible() //Return TRUE if someone sees this place
	for(var/mob/living/M in view(world.view,src))
		if(M.client)
			return TRUE

	return FALSE

/obj/landmark/storyevent/proc/get_loc()	//For overriding when you need to choose special location, like captain's ass
	return get_turf(src)

/obj/landmark/storyevent/midgame_stash_spawn
	name = "midgame stash spawn"
	icon_state = "spy-blue"
	alpha = 124
	var/navigation = "But you forgot where you left it. Oops."
