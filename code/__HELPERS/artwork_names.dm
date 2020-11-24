//Weapon names for artist
GLOBAL_LIST_INIT(art_weapon_first_names, file2list("strings/artist_strings/names/art_weapon_first.txt"))
GLOBAL_LIST_INIT(art_weapon_second_names, file2list("strings/artist_strings/names/art_weapon_second.txt"))

GLOBAL_LIST_INIT(art_locations, file2list("strings/artist_strings/names/art_locations.txt"))
GLOBAL_LIST_INIT(art_description_object_creatures_plural, file2list("strings/artist_strings/names/art_creatures_names_plural.txt"))

//When you need something simple (for random Artist Artwork)
/proc/get_weapon_name(capitalize = FALSE)
	var/first_name = pick(GLOB.art_weapon_first_names)
	var/second_name = pick(GLOB.art_weapon_second_names)

	if(capitalize)
		first_name = capitalize(first_name)
		second_name = capitalize(second_name)

	var/weapon_name = "\improper [first_name] [second_name]"
	return weapon_name

/proc/get_artwork_crew_name(only_first_name = FALSE, only_last_name = FALSE)
	var/list/names = list()
	var/art_description_crew_name = "Who?"
	for(var/mob/living/carbon/human/H in (GLOB.human_mob_list & GLOB.player_list))
		if(!isOnStationLevel(H))
			continue
		if(only_first_name)
			names.Add(H.first_name && H.first_name)
		else if(only_last_name && H.last_name)
			names.Add(H.last_name)
		else
			names.Add(H.real_name)
	if(names.len)
		art_description_crew_name = pick(names)
	return art_description_crew_name

/proc/get_artwork_name(capitalize=FALSE)
	var/option = pick(1,2,3)
	var/name
	switch(option)
		if(1)
			name = get_art_secret_name()
		if(2)
			name = get_travel_actios()
		if(3)
			name = get_art_of_name()
	if(capitalize)
		capitalize(name)
	return name

/proc/get_art_secret_name()
	var/list/adjectives = list("big", "terrifying", "mysterious", "fantastic", "secret", "haunting")
	return "the [pick(adjectives)] secret of [get_artwork_crew_name()]"

/proc/get_travel_actios()
	GLOB.art_locations |= list("[get_art_mob_places()]")
	return "the [get_artwork_crew_name()]s trip to the [pick(GLOB.art_locations)]"

/proc/get_art_mob_places()
	var/list/mobs_places = list("cave", "hideout", "nest")
	return "the [pick(GLOB.art_description_object_creatures_plural)] [pick(mobs_places)]"

/proc/get_art_of_name()
	var/list/nouns = list("heart", "soul", "honor", "beauty", "feet")
	return "the [pick(nouns)] of [get_artwork_crew_name()]"
