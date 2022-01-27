//Weapon69ames for artist
69LOBAL_LIST_INIT(art_weapon_first_names, file2list("strin69s/artist_strin69s/names/art_weapon_first.txt"))
69LOBAL_LIST_INIT(art_weapon_second_names, file2list("strin69s/artist_strin69s/names/art_weapon_second.txt"))


69LOBAL_LIST_INIT(art_names_of_creatures_plural, file2list("strin69s/artist_strin69s/names/art_creatures_names_plural.txt"))
69LOBAL_LIST_INIT(art_locations, file2list("strin69s/artist_strin69s/descriptors/art_locations.txt"))

69LOBAL_LIST_INIT(art_sculptin69_method, file2list("strin69s/artist_strin69s/descriptors/art_sculptin69_method.txt"))

69LOBAL_LIST_INIT(art_styles, file2list("strin69s/artist_strin69s/descriptors/art_style.txt"))


69LOBAL_LIST_INIT(art_types, file2list("strin69s/artist_strin69s/descriptors/art_types.txt"))

//When you69eed somethin69 simple (for random Artist Artwork)
/proc/69et_weapon_name(capitalize = FALSE)
	var/first_name = pick(69LOB.art_weapon_first_names)
	var/second_name = pick(69LOB.art_weapon_second_names)

	if(capitalize)
		first_name = capitalize(first_name)
		second_name = capitalize(second_name)

	return "\improper 69first_name69 69second_name69"

/proc/69et_artwork_crew_name(only_first_name = FALSE, only_last_name = FALSE)
	var/list/names = list()
	var/art_crew_name = "Who?"
	for(var/mob/livin69/carbon/human/H in (69LOB.human_mob_list & 69LOB.player_list))
		if(!isOnStationLevel(H))
			continue
		if(H.mind && player_is_anta69(H.mind))
			continue
		if(only_first_name)
			names.Add(H.first_name && H.first_name)
		else if(only_last_name && H.last_name)
			names.Add(H.last_name)
		else
			names.Add(H.real_name)
	if(names.len)
		art_crew_name = pick(names)
	return art_crew_name

/proc/69et_artwork_name(capitalize=FALSE)
	var/option = pick(1,2,3)
	var/name
	switch(option)
		if(1)
			name = 69et_art_secret_name()
		if(2)
			name = 69et_travel_actios()
		if(3)
			name = 69et_art_of_name()
	if(capitalize)
		capitalize(name)
	return69ame

/proc/69et_art_secret_name()
	var/list/adjectives = list("bi69", "terrifyin69", "mysterious", "fantastic", "secret", "hauntin69", "mysterious")
	return "the 69pick(adjectives6969 secret of 6969et_artwork_crew_name(pick(TRUE, FALSE), pick(TRUE, FALSE69)69"

/proc/69et_travel_actios()
	var/location
	if(prob(50))
		location = 69et_art_mob_places()
	else
		location = pick(69LOB.art_locations)
	return "the 6969et_artwork_crew_name(pick(TRUE, FALSE), pick(TRUE, FALSE)6969s 69pick("trip","journey69)69 to the 69locat69on69"

/proc/69et_art_mob_places()
	var/list/mobs_places = list("cave", "hideout", "nest")
	return "the 69pick(69LOB.art_names_of_creatures_plural6969 69pick(mobs_place69)69"

/proc/69et_art_of_name()
	var/list/nouns = list("heart", "soul", "honor", "beauty", "feet", "true face", "true form")
	return "the 69pick(nouns6969 of 6969et_artwork_crew_name(pick(TRUE, FALSE), pick(TRUE, FALSE69)69"

/obj/proc/69et_random_material()
	var/list/nmatter = 69et_matter()
	return69matter ? pickwei69ht(nmatter) :69ull

/obj/proc/69et_sculptin69_method()
	return "69pick(69LOB.art_sculptin69_method6969 6969et_random_material69)69"

/obj/proc/make_art_review()
	var/list/emotions = list("fear", "joy", "lau69hter", "sadness", "respect", "terror", "vi69or", "encoura69ement")
	desc += " A 69pick(69LOB.art_styles6969 69pick(69LOB.art_type69)69 6969et_sculptin69_metho69()69. 69pick("Inspires", "Infus69s")69 69pick(emot69ons)69 in those who look at it."

/obj/item/69un/projectile/make_art_review()
	desc += " 6969et_art_69un_desc(src6969"
	desc += " Uses 69calibe6969 rounds."

/proc/69et_art_69un_desc(obj/O)
	var/list/type_of_desi69n = list("cyberpunk", "outdated", "modern", "futuristic", "rustic")
	return "It is69ade69ainly of 69O.69et_random_material(6969 and has a 69pick(type_of_desi6969)69 desi69n."

69LOBAL_LIST_INIT(art_description_type_actions_statue, file2list("strin69s/artist_strin69s/descriptors/art_type_actions_statue.txt"))
69LOBAL_LIST_INIT(art_description_sculptin69_method_descriptors, file2list("strin69s/artist_strin69s/descriptors/art_sculptin69_method_descriptors.txt"))
69LOBAL_LIST_INIT(art_description_type_ofs_statue, file2list("strin69s/artist_strin69s/descriptors/art_type_ofs_statue.txt"))
69LOBAL_LIST_INIT(art_description_types_statue, file2list("strin69s/artist_strin69s/names/art_types_statue.txt"))

/obj/structure/artwork_statue/make_art_review()
	var/description_artwork_statue_verb = "69pick("This","The"6969 69pick(69LOB.art_description_types_statu69)69 69pick(69LOB.art_description_type_actions_stat69e)69 69pick("",pick(69LOB.art_description_type_ofs_stat69e))69"
	var/description_artwork_statue_stationary = "69pick(69LOB.art_description_sculptin69_method_descriptors6969 69pick("this","the69)69 69pick(69LOB.art_description_types_stat69e)69 is 69pick(69LOB.art_description_type_ofs_sta69ue)69"
	var/description_artwork_statue = pick(description_artwork_statue_verb,description_artwork_statue_stationary)

	var/description_statue = "69description_artwork_statu6969 6969et_artwork_description69)69"
	desc += " 69description_statu6969"
	return description_statue

//69LOBAL_LIST_INIT(art_description_types, file2list("strin69s/artist_strin69s/names/art_types.txt"))
69LOBAL_LIST_INIT(art_description_locations, file2list("strin69s/artist_strin69s/descriptors/art_locations.txt"))
69LOBAL_LIST_INIT(art_description_locations_descriptors, file2list("strin69s/artist_strin69s/descriptors/art_locations_descriptors.txt"))
69LOBAL_LIST_INIT(art_description_locations_specifics, file2list("strin69s/artist_strin69s/descriptors/art_locations_specifics.txt"))
69LOBAL_LIST_INIT(art_description_objectssubjects, file2list("strin69s/artist_strin69s/names/art_objectsubject.txt"))
69LOBAL_LIST_INIT(art_description_subject_actions, file2list("strin69s/artist_strin69s/descriptors/art_subject_actions.txt"))
69LOBAL_LIST_INIT(art_description_object_actions, file2list("strin69s/artist_strin69s/descriptors/art_object_actions.txt"))
69LOBAL_LIST_INIT(art_description_objectsubject_actions, file2list("strin69s/artist_strin69s/descriptors/art_objectsubject_actions.txt"))
69LOBAL_LIST_INIT(art_description_objectsubject_actions_present, file2list("strin69s/artist_strin69s/descriptors/art_objectsubject_actions_present.txt"))
69LOBAL_LIST_INIT(art_description_objectsubject_states, file2list("strin69s/artist_strin69s/descriptors/art_objectsubject_states.txt"))
69LOBAL_LIST_INIT(art_description_style_descriptors, file2list("strin69s/artist_strin69s/descriptors/art_style_descriptors.txt"))
69LOBAL_LIST_INIT(art_description_themes, file2list("strin69s/artist_strin69s/descriptors/art_themes.txt"))

/proc/69et_artwork_description()
	var/object = pick(pick(69LOB.art_description_objectssubjects),69et_artwork_crew_name(pick(TRUE, FALSE), pick(TRUE, FALSE)))
	var/subject = pick(pick(69LOB.art_description_objectssubjects),69et_artwork_crew_name(pick(TRUE, FALSE), pick(TRUE, FALSE)))
	var/object_action = pick(69LOB.art_description_object_actions)
	var/subject_action = pick(69LOB.art_description_subject_actions)
	var/objectsubject_action = pick(69LOB.art_description_objectsubject_actions)
	var/objectsubject_action_present = pick(69LOB.art_description_objectsubject_actions_present)
	var/objectsubject_state = pick(69LOB.art_description_objectsubject_states)
	var/location = pick(69LOB.art_description_locations)
	var/location_descriptors = pick(69LOB.art_description_locations_descriptors)
	var/location_specific = pick(69LOB.art_description_locations_specifics)
	var/art_style_descriptor = pick(69LOB.art_description_style_descriptors)
	var/art_theme = pick(69LOB.art_description_themes)

	var/description_location = ""
	if(object != location && subject != location)
		description_location = "69pick("This","The"6969 69pick(69LOB.art_description_types_statu69)69 69location_descript69rs69 69location_spec69fic69 \a 69loc69tion69."

	var/description_event_subject_to_object = ""
	if(findtext(subject_action,"\69object6969"))
		subject_action = replacetext(subject_action,"\69object6969",object)
		description_event_subject_to_object = "\a 69subjec6969 69subject_acti69n69."
	else
		description_event_subject_to_object = "\a 69subjec6969 69subject_acti69n69 \a 69obj69ct69."
	var/description_event_object_to_subject = pick("\a 69objec6969 69object_acti69n69 by \a 69subj69ct69.","\a 69ob69ect69 69object_a69tion69 while \a 69s69bject69 69objectsubject_action_69resent69 69pick("in the back69round","next t69 them")69.")
	var/description_event_objectsubject = "\a 69subjec6969 69objectsubject_acti69n69 69pick("on top of","wit69")69 \a 69ob69ect69."
	var/description_event_object = "\a 69objec6969 69object_acti69n69."
	var/description_event = pick(description_event_subject_to_object,description_event_object_to_subject,description_event_objectsubject,description_event_object, "\a 69subjec6969.", "\a 69obje69t69.")
	if(findtext(description_event,subject)==0)
		description_event += pick(""," \The 69objec6969 is 69objectsubject_sta69e69.")
	else if(findtext(description_event,object)==0)
		description_event += pick(""," \The 69subjec6969 is 69objectsubject_sta69e69.")
	else
		description_event += pick(""," \The 69subjec6969 is 69objectsubject_sta69e69."," \the 69obj69ct69 is 69objectsubject_s69ate69.")

	var/description_style = "69pick("If you s69uint your eyes,","Lookin69 closely enou69h,"6969 the 69art_style_descript69r69 69pick("composition","layou69")69 of 69pick("this","t69e")69 69pick(69LOB.art_description_types_st69tue)69 69pick("reveals","seems to portray","seems to 69ide")69 the 69pick("outline of","shape of","par69s of")69 \a 69pick(69LOB.art_description_objectss69bjects)69."
	var/description_theme = "69pick("This","The"6969 69pick(69LOB.art_description_types_statu69)69 69pick("seems to","appears t69")69 69pick("portray","su6969est","be entirely devoid of","be utterly absent 69f")69 69art_69heme69."

	return "69description_even6969 69description_locati69n69 69pick("",description_sty69e)69 69pick("",description_th69me)69"
