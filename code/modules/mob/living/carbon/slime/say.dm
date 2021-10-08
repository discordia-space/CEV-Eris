/mob/living/carbon/slime/say(var/message)

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

/mob/living/carbon/slime/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "asks";
	else if (ending == "!")
		return "cries";

	return "chirps";

/mob/living/carbon/slime/say_understands(var/other)
	return isslime(other) || ..()

/mob/living/carbon/slime/hear_say(var/message, var/verb = "says", var/datum/language/language, var/alt_name = "", var/italics = 0, var/mob/speaker, var/sound/speech_sound, var/sound_vol, speech_volume)
	if (speaker in Friends)
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(message))
	..()

/mob/living/carbon/slime/hear_radio(var/message, var/verb="says", var/datum/language/language, var/part_a, var/part_b, var/mob/speaker, var/hard_to_hear = 0, var/vname ="")
	if (speaker in Friends)
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(message))
	..()

