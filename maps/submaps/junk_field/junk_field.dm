/datum/map_template/junk
	name = null
	var/description = "A drifting piece of junk."

	var/prefix = null
	var/suffix = null
	template_flags = 0 // No duplicates by default

/datum/map_template/junk/New()
	mappath += (prefix + suffix)

	..()

/datum/map_template/junk/j21_21
	prefix = "maps/submaps/junk_field/j21_21/"
	var/list/ruin_tags

/datum/map_template/junk/j3_3
	prefix = "maps/submaps/junk_field/j3_3/"
	var/list/ruin_tags
