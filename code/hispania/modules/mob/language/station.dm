/datum/language/kidan
	name = LANGUAGE_KIDAN
	desc = "The noise made by rubbing its antennae together is actually a complex form of communication for Kidan."
	speech_verb = "rubs its antennae together"
	ask_verb = "rubs its antennae together"
	exclaim_verb = "rubs its antennae together"
	colour = "kidan"
	key = "k"
	flags = RESTRICTED
	syllables = list("click","clack")
	shorthand = "CHI"

/datum/language/kidan/get_random_name()
	var/new_name = "[pick(list("Vrax", "Krek", "Vriz", "Zrik", "Zarak", "Click", "Zerk", "Drax", "Zven", "Drexx"))]"
	new_name += ", "
	new_name += "[pick(list("Noble", "Worker", "Scout", "Builder", "Farmer", "Gatherer", "Soldier", "Guard", "Prospector"))]"
	new_name += " of Clan "
	new_name += "[pick(list("Tristan", "Zarlan", "Clack", "Kkraz", "Zramn", "Orlan", "Zrax"))]"	//I ran out of ideas after the first two tbh -_-
	return new_name
