/proc/get_artwork_crew_name()
	var/list/art_description_crew_name = "Error"
	var/datum/mind/target_mind

	var/list/candidates = SSticker.minds.Copy()//From contract.dm assasinate code
	while(candidates.len)
		target_mind = pick(candidates)
		var/mob/living/carbon/human/H = target_mind.current
		if(!istype(H) || !isOnStationLevel(H))
			candidates -= target_mind
			continue
		art_description_crew_name = target_mind.current.real_name
		break

	return art_description_crew_name

//For Artist project,
/proc/get_artwork_description()


	var/list/art_description_types = file2list("config/names/art_types.txt")
	//var/list/art_description_object_creatures_plural = file2list("config/name/art_ceatures_names_plural.txt")
	var/list/art_description_locations = file2list("config/descriptions/art_locations.txt")
	var/list/art_description_locations_descriptors = file2list("config/descriptions/art_locations_descriptors.txt")
	var/list/art_description_locations_specifics = file2list("config/descriptions/art_locations_specifics.txt")
	var/list/art_description_objectssubjects = file2list("config/names/art_objectsubject.txt")
	var/list/art_description_subject_actions = file2list("config/descriptions/art_subject_actions.txt")
	var/list/art_description_object_actions = file2list("config/descriptions/art_object_actions.txt")
	var/list/art_description_objectsubject_actions = file2list("config/descriptions/art_objectsubject_actions.txt")
	var/list/art_description_objectsubject_actions_present = file2list("config/descriptions/art_objectsubject_actions_present.txt")
	var/list/art_description_objectsubject_states = file2list("config/descriptions/art_objectsubject_states.txt")
	var/list/art_description_style_descriptors = file2list("config/descriptions/art_style_descriptors.txt")
	var/list/art_description_themes = file2list("config/descriptions/art_themes.txt")

	var/object = pick(pick(art_description_objectssubjects),get_artwork_crew_name())
	var/subject = pick(pick(art_description_objectssubjects),get_artwork_crew_name())
	var/object_action = pick(art_description_object_actions)
	var/subject_action = pick(art_description_subject_actions)
	var/objectsubject_action = pick(art_description_objectsubject_actions)
	var/objectsubject_action_present = pick(art_description_objectsubject_actions_present)
	var/objectsubject_state = pick(art_description_objectsubject_states)
	var/location = pick(art_description_locations)
	var/location_descriptors = pick(art_description_locations_descriptors)
	var/location_specific = pick(art_description_locations_specifics)
	var/art_style_descriptor = pick(art_description_style_descriptors)
	var/art_theme = pick(art_description_themes)

	var/description_location = ""
	if(object != location && subject != location)
		description_location = "[pick("This","The")] [pick(art_description_types)] [location_descriptors] [location_specific] \a [location]."

	var/description_event = ""
	var/description_event_subject_to_object = ""
	var/description_event_object_to_subject = ""
	var/description_event_objectsubject = ""
	var/description_event_object = ""
	if(findtext(subject_action,"\[object\]"))
		subject_action = replacetext(subject_action,"\[object\]",object)
		description_event_subject_to_object = "\a [subject] [subject_action]."
	else
		description_event_subject_to_object = "\a [subject] [subject_action] \a [object]."
	description_event_object_to_subject = pick("\a [object] [object_action] by \a [subject].","\a [object] [object_action] while \a [subject] [objectsubject_action_present] [pick("in the background","next to them")].")
	description_event_objectsubject = "\a [subject] [objectsubject_action] [pick("on top of","with")] \a [object]."
	description_event_object = "\a [object] [object_action]."
	description_event = pick(description_event_subject_to_object,description_event_object_to_subject,description_event_objectsubject,description_event_object, "\a [subject].", "\a [object].")
	if(findtext(description_event,subject)==0)
		description_event += pick(""," \The [object] is [objectsubject_state].")
	else if(findtext(description_event,object)==0)
		description_event += pick(""," \The [subject] is [objectsubject_state].")
	else description_event += pick(""," \The [subject] is [objectsubject_state]."," \the [object] is [objectsubject_state].")

	var/description_style = ""
	description_style = "[pick("If you squint your eyes,","Looking closely enough,")] the [art_style_descriptor] [pick("composition","layout")] of [pick("this","the")] [pick(art_description_types)] [pick("reveals","seems to portray","seems to hide")] the [pick("outline of","shape of","parts of")] \a [pick(art_description_objectssubjects)]."

	var/description_theme = ""
	description_theme = "[pick("This","The")] [pick(art_description_types)] [pick("seems to","appears to")] [pick("portray","suggest","be entirely devoid of","be utterly absent of")] [art_theme]."


	var/description = "[description_event] [description_location] [pick("",description_style)] [pick("",description_theme)]"
	return description

/proc/get_statue_description()
	var/list/art_description_type_actions_statue = file2list("config/descriptions/art_type_actions_statue.txt")
	var/list/art_description_sculpting_method_descriptors = file2list("config/descriptions/art_sculpting_method_descriptors.txt")
	var/list/art_description_type_ofs_statue = file2list("config/descriptions/art_type_ofs_statue.txt")
	var/list/art_description_types_statue = file2list("config/names/art_types_statue.txt")

	var/description_artwork_statue = ""
	var/description_artwork_statue_verb = "[pick("This","The")] [pick(art_description_types_statue)] [pick(art_description_type_actions_statue)] [pick("",pick(art_description_type_ofs_statue))]"
	var/description_artwork_statue_stationary = "[pick(art_description_sculpting_method_descriptors)] [pick("this","the")] [pick(art_description_types_statue)] is [pick(art_description_type_ofs_statue)]"
	description_artwork_statue = pick(description_artwork_statue_verb,description_artwork_statue_stationary)

	var/description_statue = "[description_artwork_statue] [get_artwork_description()]"
	return description_statue

/proc/get_gun_description()
	var/list/art_description_type_ofs_gun = file2list("config/descriptions/art_type_ofs_gun.txt")
	var/list/art_description_type_actions_gun = file2list("config/descriptions/art_type_actions_gun.txt")

	var/description_artwork_gun = ""
	description_artwork_gun = "[pick(art_description_type_ofs_gun)] [pick("of","that [pick(art_description_type_actions_gun)]")]"

	var/description_gun = "[description_artwork_gun] [get_artwork_description()]"
	return description_gun
