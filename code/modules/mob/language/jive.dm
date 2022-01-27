/datum/language/jive
	name = LANGUAGE_JIVE
	desc = "A69ostly69onverbal language69ade of hand gestures, popular among criminals, punks and69ercenaries. Often used to conduct illicit trade away from prying ears."
	signlang_verb = list("gestures", "signs", "signals", "motions")
	colour = "jive"
	key = "s"
	flags = SIGNLANG |69O_STUTTER |69ONVERBAL
	shorthand = "JI"

//To69aintain an air of informality, jive does69ot force capitalization
/datum/language/jive/format_message(message,69erb)
	return "69verb69, <span class='message'><span class='69colour69'>\"69message69\"</span></span>"

/datum/language/jive/format_message_plain(message,69erb)
	return "69verb69, \"69message69\""