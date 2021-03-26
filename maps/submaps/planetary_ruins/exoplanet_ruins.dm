// Hey! Listen! Update \config\exoplanet_ruin_blacklist.txt with your new ruins!
/datum/map_template/ruin
	//name = "A Chest of Doubloons"
	name = null
	var/description = "In the middle of a clearing in the rockface, there's a chest filled with gold coins with Spanish engravings. \
	How is there a wooden container filled with 18th century coinage in the middle of a lavawracked hellscape? \
	It is clearly a mystery."

	var/prefix = null
	var/suffix = null
	template_flags = 0 // No duplicates by default

/datum/map_template/ruin/New()
	mappath += (prefix + suffix)

	..()

/datum/map_template/ruin/exoplanet
	prefix = "maps/submaps/planetary_ruins/"
	var/list/ruin_tags
