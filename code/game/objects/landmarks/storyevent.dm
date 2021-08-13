/obj/landmark/storyevent
	alpha = 124
	var/navigation = ""

/obj/landmark/storyevent/Initialize()
	. = ..()

	if (!(navigation))
		var/proposition = get_landmark_area()
		navigation = "But you forgot where you left it. Oops. Maybe it's somewhere near [proposition]?"

/obj/landmark/storyevent/proc/is_visible() //Return TRUE if someone sees this place
	for(var/mob/living/M in view(world.view,src))
		if(M.client)
			return TRUE

	return FALSE

/obj/landmark/storyevent/proc/get_loc()	//For overriding when you need to choose special location, like captain's ass
	return get_turf(src)

/obj/landmark/storyevent/proc/get_landmark_area()
	return get_area(get_loc())

/obj/landmark/storyevent/midgame_stash_spawn
	name = "midgame stash spawn"
	icon_state = "spy-blue"

/obj/landmark/storyevent/hidden_vent_antag
	name = "hidden-vent-antag"
	icon_state = "spy-green"

/obj/landmark/storyevent/merc_spawn
	name = "mercenary-spawn"
	icon_state = "spy-green"
	navigation = "This marks Serbia, it is our land."

/obj/landmark/storyevent/potential_unique_oddity_spawn
	name = "special-oddity-spawn"
	icon_state = "spy-cyan"
