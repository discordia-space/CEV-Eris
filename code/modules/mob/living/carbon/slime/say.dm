/mob/living/carbon/slime/say(message)

	message = sanitize(message)
	message = trim_left(message)
	var/verb = say_quote(message)

	if(copytext(message,1,2) == get_prefix_key(/decl/prefix/custom_emote))
		return emote(copytext(message,2))

	if(stat)
		if(stat == DEAD)
			return say_dead(message)
		return

	return ..(message, null, verb)

/mob/living/carbon/slime/say_quote(text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "asks";
	else if (ending == "!")
		return "cries";

	return "chirps";

/mob/living/carbon/slime/say_understands(other)
	return isslime(other) || ..()

/mob/living/carbon/slime/hear_say(message, verb = src.verb_say, datum/language/language, alt_name = "", italics = 0, mob/speaker, sound/speech_sound, sound_vol, speech_volume)
	if (speaker in Friends)
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(message))
	..()

/mob/living/carbon/slime/hear_radio(message, verb = src.verb_say, datum/language/language, part_a, part_b, mob/speaker, hard_to_hear = 0, vname ="")
	if (speaker in Friends)
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(message))
	..()

