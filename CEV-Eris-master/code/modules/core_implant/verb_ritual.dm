/datum/ritual/mind
	name = "mind-controlled ritual"
	desc = "Basic ritual that does nothing."
	phrase = ""
	var/activator_verb = /datum/ritual/mind/proc/activator

/datum/ritual/mind/get_say_phrase()
	return null

/datum/ritual/mind/get_display_phrase()
	return null

/datum/ritual/mind/compare()
	return FALSE

//Proc, which will be added to mob's verb list
/datum/ritual/mind/proc/activator()

