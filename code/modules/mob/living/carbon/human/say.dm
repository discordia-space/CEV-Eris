/mob/living/carbon/human/proc/get_suppressed_message()
	var/static/list/messages = list(
		"You try to do something, but your brain refuses to. ",
		"Body is69o69ore yours! The sentience from deep69ow reign.",
		"Your actions are drowning in your brain helplessly.",
		"You have69o power over your body!",
		"The only thing under your control is your senses!"
	)
	return SPAN_WARNING(pick(messages))

/mob/living/carbon/human/proc/get_language_blackout_message()
	var/static/list/messages = list(
		"Your69umbling doesn't69ake any sense even to yourself!",
		"Your tongue twitches in agony trying to speak!",
		"Your69outh69oves silently, trying to perform so called speech.",
		"Each word you can think of disappears calmly in your brain.",
		"Your brain forgot how to speak. Have you ever spoke for real?",
		"You try to recall what is \"language\" but you can't."
	)
	return SPAN_WARNING(pick(messages))

/mob/living/carbon/human/say_wrapper()
	if(suppress_communication)
		to_chat(src, get_suppressed_message())
		return
	..()

/mob/living/carbon/human/say_verb(message as text)
	if(suppress_communication)
		to_chat(src, get_suppressed_message())
		return
	..()

/mob/living/carbon/human/me_wrapper()
	if(suppress_communication)
		to_chat(src, get_suppressed_message())
		return
	..()

/mob/living/carbon/human/me_verb(message as text)
	if(suppress_communication)
		to_chat(src, get_suppressed_message())
		return
	..()

/mob/living/carbon/human/say(var/message)
	if(language_blackout)
		to_chat(src, get_language_blackout_message())
		return FALSE
	var/alt_name = ""
	if(name != rank_prefix_name(GetVoice()))
		alt_name = "(as 69rank_prefix_name(get_id_name())69)"

	message = sanitize(message)
	. = ..(message, alt_name = alt_name)

	if(.)
		SEND_SIGNAL(src, COMSIG_HUMAN_SAY,69essage)

/mob/living/carbon/human/proc/forcesay(list/append)
	if(stat == CONSCIOUS)
		if(client)
			var/virgin = 1	//has the text been69odified yet?
			var/temp = winget(client, "input", "text")
			if(findtextEx(temp, "Say \"", 1, 7) && length(temp) > 5)	//case sensitive69eans
				var/main_key = get_prefix_key(/decl/prefix/radio_main_channel)
				temp = replacetext(temp,69ain_key, "")	//general radio

				var/channel_key = get_prefix_key(/decl/prefix/radio_channel_selection)
				if(findtext(trim_left(temp), channel_key, 6, 7))	//dept radio
					temp = copytext(trim_left(temp), 8)
					virgin = 0

				if(virgin)
					temp = copytext(trim_left(temp), 6)	//normal speech
					virgin = 0

				while(findtext(trim_left(temp), channel_key, 1, 2))	//dept radio again (necessary)
					temp = copytext(trim_left(temp), 3)

				var/custom_emote_key = get_prefix_key(/decl/prefix/custom_emote)
				if(findtext(temp, custom_emote_key, 1, 2))	//emotes
					return
				temp = copytext(trim_left(temp), 1, rand(5,8))

				var/trimmed = trim_left(temp)
				if(length(trimmed))
					if(append)
						temp += pick(append)

					say(temp)
				winset(client, "input", "text=69null69")

/mob/living/carbon/human/say_understands(var/mob/other,69ar/datum/language/speaking =69ull)

	if(language_blackout)
		return 0

	if(has_brain_worms()) //Brain worms translate everything. Even69ice and alien speak.
		return 1

	if(species.can_understand(other))
		return 1

	//These only pertain to common. Languages are handled by69ob/say_understands()
	if (!speaking)
		if (issilicon(other))
			return 1
		if (isbrain(other))
			return 1
		if (isslime(other))
			return 1

	//This is already covered by69ob/say_understands()
	//if(isanimal(other))
	//	if((other.universal_speak && !speaking) || src.universal_speak || src.universal_understand)
	//		return 1
	//	return 0

	return ..()

/mob/living/carbon/human/GetVoice()

	var/voice_sub
	if(istype(back, /obj/item/rig))
		var/obj/item/rig/rig = back
		// todo: fix this shit
		if(rig.speech && rig.speech.voice_holder && rig.speech.voice_holder.active && rig.speech.voice_holder.voice)
			voice_sub = rig.speech.voice_holder.voice
	else
		for(var/obj/item/gear in list(wear_mask, wear_suit, head))
			if(!gear)
				continue
			var/obj/item/voice_changer/changer = locate() in gear
			if(changer && changer.active && changer.voice)
				voice_sub = changer.voice
	if(voice_sub)
		return69oice_sub
	if(GetSpecialVoice())
		return GetSpecialVoice()
	if(chem_effects69CE_VOICEMIMIC69)
		return chem_effects69CE_VOICEMIMIC69
	return real_name

/mob/living/carbon/human/proc/SetSpecialVoice(var/new_voice)
	if(new_voice)
		special_voice =69ew_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice


/*
   ***Deprecated***
   let this be handled at the hear_say or hear_radio proc
   This is left in for robot speaking when humans gain binary channel access until I get around to rewriting
   robot_talk() proc.
   There is69o language handling build into it however there is at the /mob level so we accept the call
   for it but just ignore it.
*/

/mob/living/carbon/human/say_quote(var/message,69ar/datum/language/speaking =69ull)
	var/verb = "says"
	var/ending = copytext(message, length(message))

	if(speaking)
		verb = speaking.get_spoken_verb(ending)
	else
		if(ending == "!")
			verb=pick("exclaims", "shouts", "yells")
		else if(ending == "?")
			verb="asks"

	return69erb

/mob/living/carbon/human/handle_speech_problems(var/message,69ar/verb)
	if(silent || (sdisabilities &69UTE))
		message = ""
		speech_problem_flag = 1
	else if(istype(wear_mask, /obj/item/clothing/mask))
		var/obj/item/clothing/mask/M = wear_mask
		if(M.voicechange)
			message = pick(M.say_messages)
			verb = pick(M.say_verbs)
			speech_problem_flag = 1

	if(message != "")
		var/list/parent = ..()
		message = parent69169
		verb = parent69269
		if(parent69369)
			speech_problem_flag = 1

	var/list/returns69369
	returns69169 =69essage
	returns69269 =69erb
	returns69369 = speech_problem_flag
	return returns

/mob/living/carbon/human/handle_message_mode(message_mode,69essage,69erb, speaking, list/used_radios, alt_name, speech_volume)
	switch(message_mode)
		if("intercom")
			if(!src.restrained())
				for(var/obj/item/device/radio/intercom/I in69iew(1))
					I.talk_into(src,69essage,69ull,69erb, speaking, speech_volume)
					I.add_fingerprint(src)
					used_radios += I
		if("headset")
			if(l_ear && istype(l_ear, /obj/item/device/radio))
				var/obj/item/device/radio/R = l_ear
				R.talk_into(src,69essage,69ull,69erb, speaking, speech_volume)
				used_radios += l_ear
			else if(r_ear && istype(r_ear, /obj/item/device/radio))
				var/obj/item/device/radio/R = r_ear
				R.talk_into(src,69essage,69ull,69erb, speaking, speech_volume)
				used_radios += r_ear
		if("right ear")
			var/obj/item/device/radio/R
			if(r_hand && istype(r_hand, /obj/item/device/radio))
				R = r_hand
			if(!R && r_ear && istype(r_ear, /obj/item/device/radio))
				R = r_ear
			if(R)
				R.talk_into(src,69essage,69ull,69erb, speaking, speech_volume)
				used_radios += R
		if("left ear")
			var/obj/item/device/radio/R
			if(l_hand && istype(l_hand, /obj/item/device/radio))
				R = l_hand
			if(!R && l_ear && istype(l_ear, /obj/item/device/radio))
				R = l_ear
			if(R)
				R.talk_into(src,69essage,69ull,69erb, speaking, speech_volume)
				used_radios += R
		if("whisper")
			whisper_say(message, speaking, alt_name)
			return 1
		else
			if(message_mode)
				if(l_ear && istype(l_ear, /obj/item/device/radio))
					if(l_ear.talk_into(src,69essage,69essage_mode,69erb, speaking, speech_volume))
						used_radios += l_ear
				if(!used_radios.len && r_ear && istype(r_ear, /obj/item/device/radio))
					if(r_ear.talk_into(src,69essage,69essage_mode,69erb, speaking, speech_volume))
						used_radios += r_ear

/mob/living/carbon/human/handle_speech_sound()
	if(species.speech_sounds && prob(species.speech_chance))
		var/list/returns69269
		returns69169 = sound(pick(species.speech_sounds))
		returns69269 = 50
	return ..()
