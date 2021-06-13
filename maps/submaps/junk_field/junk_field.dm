/datum/map_template/junk
	name = null
	var/description = "A drifting piece of junk."

	var/prefix = null
	var/suffix = null
	template_flags = 0 // No duplicates by default

/datum/map_template/junk/New()
	mappath += (prefix + suffix)

	..()

/datum/map_template/junk/j25_25
	prefix = "maps/submaps/junk_field/j25_25/"
	var/list/ruin_tags

/datum/map_template/junk/j5_5
	prefix = "maps/submaps/junk_field/j5_5/"
	var/list/ruin_tags
