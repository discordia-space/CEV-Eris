/mob/living/carbon/human/whisper_say(message, datum/language/speaking = null, alt_name="", verb="whispers")
	if(name != rank_prefix_name(GetVoice()))
		alt_name = "(as [rank_prefix_name(get_id_name())])"
	. = ..()
