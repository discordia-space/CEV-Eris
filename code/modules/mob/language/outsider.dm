/datum/language/corticalborer
	name = LANGUAGE_CORTICAL
	desc = "Cortical borers possess a strange link between their tiny minds."
	speech_verb = list("sings")
	ask_verb = list("sings")
	exclaim_verb = list("sings")
	colour = "alien"
	key = "x"
	flags = RESTRICTED | HIVEMIND
	shorthand = "N/A"

/datum/language/corticalborer/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	var/mob/living/simple_animal/borer/B

	if(iscarbon(speaker))
		var/mob/living/carbon/M = speaker
		B = M.has_brain_worms()
	else if(istype(speaker,/mob/living/simple_animal/borer))
		B = speaker

	if(B)
		speaker_mask = B.truename
	..(speaker,message,speaker_mask)

/datum/language/cultcommon
	name = LANGUAGE_CULT
	desc = "The chants of the occult, the incomprehensible."
	speech_verb = list("intones")
	ask_verb = list("intones")
	exclaim_verb = list("chants")
	colour = "cult"
	key = "f"
	flags = RESTRICTED
	space_chance = 100
	syllables = list("ire","ego","nahlizet","certum","veri","jatkaa","mgar","balaq", "karazet", "geeri", \
		"orkan", "allaq", "sas'so", "c'arta", "forbici", "tarem", "n'ath", "reth", "sh'yro", "eth", "d'raggathnor", \
		"mah'weyh", "pleggh", "at", "e'ntrath", "tok-lyr", "rqa'nap", "g'lt-ulotf", "ta'gh", "fara'qha", "fel", "d'amar det", \
		"yu'gular", "faras", "desdae", "havas", "mithum", "javara", "umathar", "uf'kal", "thenar", "rash'tla", \
		"sektath", "mal'zua", "zasan", "therium", "viortia", "kla'atu", "barada", "nikt'o", "fwe'sh", "mah", "erl", "nyag", "r'ya", \
		"gal'h'rfikk", "harfrandid", "mud'gib", "fuu", "ma'jin", "dedo", "ol'btoh", "n'ath", "reth", "sh'yro", "eth", \
		"d'rekkathnor", "khari'd", "gual'te", "nikka", "nikt'o", "barada", "kla'atu", "barhah", "hra" ,"zar'garis")
	shorthand = "CT"

/datum/language/cult
	name = LANGUAGE_OCCULT
	desc = "The initiated can share their thoughts by means defying all reason."
	speech_verb = list("intones")
	ask_verb = list("intones")
	exclaim_verb = list("chants")
	colour = "cult"
	key = "y"
	flags = RESTRICTED | HIVEMIND
	shorthand = "N/A"
