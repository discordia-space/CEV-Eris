/datum/language/jive
	name = LANGUAGE_JIVE
	desc = "A mostly nonverbal language made of hand gestures, popular among criminals, punks and mercenaries. Often used to conduct illicit trade away from prying ears."
	signlang_verb = list("gestures", "signs", "signals", "motions")
	colour = "jive"
	key = "s"
	flags = SIGNLANG | NO_STUTTER | NONVERBAL
	shorthand = "JI"

//To maintain an air of informality, jive does not force capitalization
/datum/language/jive/format_message(message, verb)
	return "[verb], <span class='message'><span class='[colour]'>\"[message]\"</span></span>"

/datum/language/jive/format_message_plain(message, verb)
	return "[verb], \"[message]\""