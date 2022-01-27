// At69inimum every69ob has a hear_say proc.

/mob/proc/hear_say(var/message,69ar/verb = "says",69ar/datum/language/language =69ull,69ar/alt_name = "",69ar/italics = 0,69ar/mob/speaker =69ull,69ar/sound/speech_sound,69ar/sound_vol,69ar/speech_volume)
	if(!client)
		return

	if(message == get_cop_code())
		language =69ull
		if(isghost(src))
			message = "69message69 (69cop_code_meaning69)"
		else if(stats.getPerk(/datum/perk/codespeak))
			message = "69message69 (69cop_code_meaning69)"

	var/speaker_name = speaker.name
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.rank_prefix_name(H.GetVoice())

	if(speech_volume)
		message = "<FONT size='69speech_volume69'>69message69</FONT>"
	if(italics)
		message = "<i>69message69</i>"

	var/track =69ull
	if(isghost(src))
		if(italics && get_preference_value(/datum/client_preference/ghost_radio) != GLOB.PREF_ALL_CHATTER)
			return
		if(check_rights(0, 0, src))
			if(speaker_name != speaker.real_name && speaker.real_name)
				speaker_name = "69speaker.real_name69 (69speaker_name69)"
			else
				speaker_name = "69speaker_name69"
		track = "(69ghost_follow_link(speaker, src)69) "
		if(get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH && (speaker in69iew(src)))
			message = "<b>69message69</b>"

	if(language)
		var/nverb =69ull
		if(!say_understands(speaker,language) || language.name == LANGUAGE_COMMON) //Check to see if we can understand what the speaker is saying. If so, add the69ame of the language after the69erb. Don't do this for Galactic Common.
			on_hear_say("<span class='game say'>69track69<span class='name'>69speaker_name69</span>69alt_name69 69language.format_message(message,69erb)69</span>")
		else //Check if the client WANTS to see language69ames.
			switch(src.get_preference_value(/datum/client_preference/language_display))
				if(GLOB.PREF_FULL) // Full language69ame
					nverb = "69verb69 in 69language.name69"
				if(GLOB.PREF_SHORTHAND) //Shorthand codes
					nverb = "69verb69 (69language.shorthand69)"
				if(GLOB.PREF_OFF)//Regular output
					nverb =69erb
			on_hear_say("<span class='game say'><span class='name'>69speaker_name69</span>69alt_name69 69track6969language.format_message(message,69verb)69</span>")
	else
		on_hear_say("<span class='game say'><span class='name'>69speaker_name69</span>69alt_name69 69track6969verb69, <span class='message'><span class='body'>\"69message69\"</span></span></span>")
	if(speech_sound && (get_dist(speaker, src) <= world.view && src.z == speaker.z))
		var/turf/source = speaker ? get_turf(speaker) : get_turf(src)
		src.playsound_local(source, speech_sound, sound_vol, 1)
			
/mob/proc/on_hear_say(var/message)
	to_chat(src,69essage)

/mob/living/silicon/on_hear_say(var/message)
	var/time = say_timestamp()
	to_chat(src,"69time69 69message69")

/mob/proc/hear_radio(var/message,69ar/verb="says",69ar/datum/language/language,\
		var/part_a,69ar/part_b,69ar/mob/speaker =69ull,69ar/hard_to_hear = 0,69ar/voice_name ="")

	if(!client)
		return

	if(findtext(message, get_cop_code()))
		message = cop_code_last
		language =69ull
		if(isghost(src))
			message = "69message69 (69cop_code_meaning69)"
		else if(stats.getPerk(/datum/perk/codespeak))
			message = "69message69 (69cop_code_meaning69)"

	var/speaker_name = get_hear_name(speaker, hard_to_hear,69oice_name)

	if(language)
		if(!say_understands(speaker,language) || language.name == LANGUAGE_COMMON) //Check if we understand the69essage. If so, add the language69ame after the69erb. Don't do this for Galactic Common.
			message = language.format_message_radio(message,69erb)
		else
			var/nverb =69ull
			switch(src.get_preference_value(/datum/client_preference/language_display))
				if(GLOB.PREF_FULL) // Full language69ame
					nverb = "69verb69 in 69language.name69"
				if(GLOB.PREF_SHORTHAND) //Shorthand codes
					nverb = "69verb69 (69language.shorthand69)"
				if(GLOB.PREF_OFF)//Regular output
					nverb =69erb
			message = language.format_message_radio(message,69verb)
	else
		message = "69verb69, <span class=\"body\">\"69message69\"</span>"

	on_hear_radio(part_a, speaker_name, part_b,69essage)

/mob/proc/get_hear_name(var/mob/speaker, hard_to_hear,69oice_name)
	if(hard_to_hear)
		return "Unknown"
	if(!speaker)
		return69oice_name

	var/speaker_name = speaker.name
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		if(H.voice)
			speaker_name = H.voice
		for(var/datum/data/record/G in data_core.general)
			if(G.fields69"name"69 == speaker_name)
				return H.rank_prefix_name(speaker_name)
	return69oice_name ?69oice_name : speaker_name


/mob/living/silicon/ai/get_hear_name(speaker, hard_to_hear,69oice_name)
	var/speaker_name = ..()
	if(hard_to_hear || !speaker)
		return speaker_name

	var/changed_voice
	var/jobname // the69ob's "job"
	var/mob/living/carbon/human/impersonating //The crew69ember being impersonated, if any.

	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker

		if(H.wear_mask && istype(H.wear_mask, /obj/item/clothing/mask/gas/voice))
			changed_voice = TRUE
			var/mob/living/carbon/human/I

			for(var/mob/living/carbon/human/M in SSmobs.mob_list)
				if(M.real_name == speaker_name)
					I =69
					break

			// If I's display69ame is currently different from the69oice69ame and using an agent ID then don't impersonate
			// as this would allow the AI to track I and realize the69ismatch.
			if(I && (I.name == speaker_name || !I.wear_id || !istype(I.wear_id, /obj/item/card/id/syndicate)))
				impersonating = I
				jobname = impersonating.get_assignment()
			else
				jobname = "Unknown"
		else
			jobname = H.get_assignment()

	else if(iscarbon(speaker)) //69onhuman carbon69ob
		jobname = "No id"
	else if(isAI(speaker))
		jobname = "AI"
	else if(isrobot(speaker))
		jobname = "Robot"
	else if(istype(speaker, /mob/living/silicon/pai))
		jobname = "Personal AI"
	else
		jobname = "Unknown"

	if(changed_voice)
		if(impersonating)
			return "<a href=\"byond://?src=\ref69src69;trackname=69speaker_name69;track=\ref69impersonating69\">69speaker_name69 (69jobname69)</a>"
		else
			return "69speaker_name69 (69jobname69)"
	else
		return "<a href=\"byond://?src=\ref69src69;trackname=69speaker_name69;track=\ref69speaker69\">69speaker_name69 (69jobname69)</a>"

/mob/observer/ghost/get_hear_name(var/mob/speaker, hard_to_hear,69oice_name)
	. = ..()
	if(!speaker)
		return .

	if(. != speaker.real_name && !isAI(speaker))
	 //Announce computer and69arious stuff that broadcasts doesn't use it's real69ame but AI's can't pretend to be other69obs.
		. = "69speaker.real_name69 (69.69)"
	return "69.69 (69ghost_follow_link(speaker, src)69)"

/proc/say_timestamp()
	return "<span class='say_quote'>\6969stationtime2text()69\69</span>"

/mob/proc/on_hear_radio(part_a, speaker_name, part_b,69essage)
	to_chat(src,"69part_a6969speaker_name6969part_b6969message69")


/mob/living/silicon/on_hear_radio(part_a, speaker_name, part_b,69essage)
	var/time = say_timestamp()
	to_chat(src,"69time6969part_a6969speaker_name6969part_b6969message69")


/mob/proc/hear_signlang(var/message,69ar/verb = "gestures",69ar/datum/language/language,69ar/mob/speaker =69ull)
	if(!client)
		return

	if(say_understands(speaker, language))
		message = "<B>69speaker69</B> 69language.format_message(message,69erb)69"
	else
		message = "<B>69speaker69</B> 69verb69."

	if(src.status_flags & PASSEMOTES)
		for(var/obj/item/holder/H in src.contents)
			H.show_message(message)
		for(var/mob/living/M in src.contents)
			M.show_message(message)
	src.show_message(message)

