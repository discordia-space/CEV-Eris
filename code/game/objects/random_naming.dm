obj/item/random_naming
	var/list/art_weapon_first_names
	var/list/art_weapon_second_names

obj/item/random_naming/New(timeofday)

	art_weapon_first_names = file2list("config/names/art_weapon_first_names.txt")
	art_weapon_second_names = file2list("config/names/art_weapon_second_names.txt")

//When you need something simple
/obj/item/random_naming/proc/get_weapon_name(capitalize = FALSE)

	var/first_name = pick(art_weapon_first_names)
	var/second_name = pick(art_weapon_second_names)

	if(capitalize)
		first_name = capitalize(first_name)
		second_name = capitalize(second_name)

	var/weapon_name = "[first_name] [second_name]"
	return weapon_name
