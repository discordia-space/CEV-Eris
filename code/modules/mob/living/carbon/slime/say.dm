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

	return ..(message,69ull,69erb)

/mob/living/carbon/slime/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "asks";
	else if (ending == "!")
		return "cries";

	return "chirps";

/mob/living/carbon/slime/say_understands(var/other)
	return isslime(other) || ..()

/mob/living/carbon/slime/hear_say(var/message,69ar/verb = "says",69ar/datum/language/language,69ar/alt_name = "",69ar/italics = 0,69ar/mob/speaker,69ar/sound/speech_sound,69ar/sound_vol, speech_volume)
	if (speaker in Friends)
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(message))
	..()

/mob/living/carbon/slime/hear_radio(var/message,69ar/verb="says",69ar/datum/language/language,69ar/part_a,69ar/part_b,69ar/mob/speaker,69ar/hard_to_hear = 0,69ar/vname ="")
	if (speaker in Friends)
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(message))
	..()

