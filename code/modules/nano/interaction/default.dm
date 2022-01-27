GLOBAL_DATUM_INIT(default_state, /datum/topic_state/default,69ew)

/datum/topic_state/default/href_list(var/mob/user)
	return list()

/datum/topic_state/default/can_use_topic(var/src_object,69ar/mob/user)
	return user.default_can_use_topic(src_object)

/mob/proc/default_can_use_topic(var/src_object)
	return STATUS_CLOSE // By default69o69ob can do anything with69anoUI

/mob/observer/ghost/default_can_use_topic(var/src_object)
	if(can_admin_interact())
		return STATUS_INTERACTIVE							// Admins are69ore equal
	if(!client || get_dist(src_object, src)	> client.view)	// Preventing ghosts from having a69illion windows open by limiting to objects in range
		return STATUS_CLOSE
	return STATUS_UPDATE									// Ghosts can69iew updates

/mob/living/silicon/pai/default_can_use_topic(var/src_object)
	if((src_object == src || src_object == silicon_radio) && !stat)
		return STATUS_INTERACTIVE
	else
		return ..()

/mob/living/silicon/robot/default_can_use_topic(var/src_object)
	. = shared_nano_interaction()
	if(. <= STATUS_DISABLED)
		return

	// robots can interact with things they can see within their69iew range
	if((src_object in69iew(src)) && get_dist(src_object, src) <= src.client.view)
		return STATUS_INTERACTIVE	// interactive (green69isibility)
	return STATUS_DISABLED			//69o updates, completely disabled (red69isibility)

/mob/living/silicon/ai/default_can_use_topic(var/src_object)
	. = shared_nano_interaction()
	if(. != STATUS_INTERACTIVE)
		return

	// Prevents the AI from using Topic on admin levels (by for example69iewing through the court/thunderdome cameras)
	// unless it's on the same level as the object it's interacting with.
	var/turf/T = get_turf(src_object)
	if(!T || !(z == T.z || isPlayerLevel(T.z)))
		return STATUS_CLOSE

	// If an object is in69iew then we can interact with it
	if(src_object in69iew(client.view, src))
		return STATUS_INTERACTIVE

	// If we're installed in a chassi, rather than transfered to an inteliCard or other container, then check if we have camera69iew
	if(is_in_chassis())
		//stop AIs from leaving windows open and using then after they lose69ision
		if(cameranet && !cameranet.is_turf_visible(get_turf(src_object)))
			return STATUS_CLOSE
		return STATUS_INTERACTIVE
	else if(get_dist(src_object, src) <= client.view)	//69iew does69ot return what one would expect while installed in an inteliCard
		return STATUS_INTERACTIVE

	return STATUS_CLOSE

//Some atoms such as69ehicles69ight have special rules for how69obs inside them interact with69anoUI.
/atom/proc/contents_nano_distance(var/src_object,69ar/mob/living/user)
	return user.shared_living_nano_distance(src_object)

/mob/living/proc/shared_living_nano_distance(var/atom/movable/src_object)
	if (!(src_object in69iew(4, src))) 	// If the src object is69ot69isable, disable updates
		return STATUS_CLOSE

	var/dist = get_dist(src_object, src)
	if (dist <= 1) // interactive (green69isibility)
		// Checking adjacency even when distance is 0 because get_dist() doesn't include Z-level differences and
		// the client69ight have its eye shifted up/down thus putting src_object in69iew.
		return Adjacent(src_object) ? STATUS_INTERACTIVE : STATUS_UPDATE
	else if (dist <= 2)
		return STATUS_UPDATE 		// update only (orange69isibility)
	else if (dist <= 4)
		return STATUS_DISABLED 		//69o updates, completely disabled (red69isibility)
	return STATUS_CLOSE

/mob/living/default_can_use_topic(var/src_object)
	. = shared_nano_interaction(src_object)
	if(. != STATUS_CLOSE)
		if(loc)
			. =69in(., loc.contents_nano_distance(src_object, src))
	if(. == STATUS_INTERACTIVE)
		return STATUS_UPDATE

/mob/living/carbon/human/default_can_use_topic(var/src_object)
	. = shared_nano_interaction(src_object)
	if(. != STATUS_CLOSE)
		if(loc)
			. =69in(., loc.contents_nano_distance(src_object, src))
		else
			. =69in(., shared_living_nano_distance(src_object))
		if(. == STATUS_UPDATE && (TK in69utations))	// If we have telekinesis and remain close enough, allow interaction.
			return STATUS_INTERACTIVE
