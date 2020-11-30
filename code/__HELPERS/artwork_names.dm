//Weapon names for artist
GLOBAL_LIST_INIT(art_weapon_first_names, file2list("strings/artist_strings/names/art_weapon_first.txt"))
GLOBAL_LIST_INIT(art_weapon_second_names, file2list("strings/artist_strings/names/art_weapon_second.txt"))


GLOBAL_LIST_INIT(art_names_of_creatures_plural, file2list("strings/artist_strings/names/art_creatures_names_plural.txt"))
GLOBAL_LIST_INIT(art_locations, file2list("strings/artist_strings/descriptors/art_locations.txt"))

GLOBAL_LIST_INIT(art_sculpting_method, file2list("strings/artist_strings/descriptors/art_sculpting_method.txt"))

GLOBAL_LIST_INIT(art_style, file2list("strings/artist_strings/descriptors/art_style.txt"))


//When you need something simple (for random Artist Artwork)
/proc/get_weapon_name(capitalize = FALSE)
	var/first_name = pick(GLOB.art_weapon_first_names)
	var/second_name = pick(GLOB.art_weapon_second_names)

	if(capitalize)
		first_name = capitalize(first_name)
		second_name = capitalize(second_name)

	return "\improper [first_name] [second_name]"

/proc/get_artwork_crew_name(only_first_name = FALSE, only_last_name = FALSE)
	var/list/names = list()
	var/art_crew_name = "Who?"
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
		art_crew_name = pick(names)
	return art_crew_name

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
	var/list/adjectives = list("big", "terrifying", "mysterious", "fantastic", "secret", "haunting", "mysteriouss")
	return "the [pick(adjectives)] secret of [get_artwork_crew_name(pick(TRUE, FALSE), pick(TRUE, FALSE))]"

/proc/get_travel_actios()
	GLOB.art_locations |= list("[get_art_mob_places()]")
	return "the [get_artwork_crew_name(pick(TRUE, FALSE), pick(TRUE, FALSE))]s [pick("trip","journey")] to the [pick(GLOB.art_locations)]"

/proc/get_art_mob_places()
	var/list/mobs_places = list("cave", "hideout", "nest")
	return "the [pick(GLOB.art_names_of_creatures_plural)] [pick(mobs_places)]"

/proc/get_art_of_name()
	var/list/nouns = list("heart", "soul", "honor", "beauty", "feet", "true face", "true form")
	return "the [pick(nouns)] of [get_artwork_crew_name(pick(TRUE, FALSE), pick(TRUE, FALSE))]"

/obj/proc/get_random_material()
	var/list/nmatter = get_matter()
	return nmatter ? pickweight(nmatter) : null

/obj/proc/get_sculpting_method()
	return "[pick(GLOB.art_sculpting_method)] [get_random_material()]"

/obj/proc/make_art_review()
	var/list/emotions = list("fear", "joy", "laughter", "sadness", "respect", "terror", "vigor", "encourages")
	desc += " A [pick(GLOB.art_style)] work of art [get_sculpting_method()]. [pick("Inspires", "Infuses")] [pick(emotions)] to those who look at it."

/obj/item/weapon/gun/projectile/make_art_review()
	desc += " [get_art_gun_desc(src)]"
	desc += " Uses [caliber] rounds."

/proc/get_art_gun_desc(obj/O)
	var/list/type_of_design = list("cyberpunk", "outdated", "modern", "futuristic", "rustic")
	return "It is made mainly of [O.get_random_material()] and has a [pick(type_of_design)] design."
