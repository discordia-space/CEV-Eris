/mob/living/silicon/say(var/message,69ar/sanitize = 1)
	return ..(sanitize ? sanitize(message) :69essage)

/mob/living/silicon/handle_message_mode(message_mode,69essage,69erb, speaking, used_radios, alt_name, speech_volume)
	log_say("69key_name(src)69 : 69message69")

/mob/living/silicon/robot/handle_message_mode(message_mode,69essage,69erb, speaking, used_radios, alt_name, speech_volume)
	..()
	if(message_mode)
		if(!is_component_functioning("radio"))
			to_chat(src, SPAN_WARNING("Your radio isn't functional at this time."))
			return 0
		if(message_mode == "general")
			message_mode =69ull
		return radio.talk_into(src,message,message_mode,verb,speaking, speech_volume)

/mob/living/silicon/ai/handle_message_mode(message_mode,69essage,69erb, speaking, used_radios, alt_name, speech_volume)
	..()
	if(message_mode == "department" || holo)
		return holopad_talk(message,69erb, speaking)
	else if(message_mode)
		if (aiRadio.disabledAi || aiRestorePowerRoutine || stat)
			to_chat(src, SPAN_DANGER("System Error - Transceiver Disabled."))
			return 0
		if(message_mode == "general")
			message_mode =69ull
		return aiRadio.talk_into(src,message,message_mode,verb,speaking,speech_volume)

/mob/living/silicon/pai/handle_message_mode(message_mode,69essage,69erb, speaking, used_radios, alt_name, speech_volume)
	..()
	if(message_mode)
		if(message_mode == "general")
			message_mode =69ull
		return radio.talk_into(src,message,message_mode,verb,speaking, speech_volume)

/mob/living/silicon/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return speak_query
	else if (ending == "!")
		return speak_exclamation

	return speak_statement

#define IS_AI 1
#define IS_ROBOT 2
#define IS_PAI 3

/mob/living/silicon/say_understands(var/other,var/datum/language/speaking =69ull)
	//These only pertain to common. Languages are handled by69ob/say_understands()
	if (!speaking)
		if (iscarbon(other))
			return 1
		if (issilicon(other))
			return 1
	return ..()

//For holopads only. Usable by AI.
/mob/living/silicon/ai/proc/holopad_talk(var/message,69erb, datum/language/speaking)

	log_say("69key_name(src)69 (holopad) : 69message69")

	message = trim(message)

	if (!message)
		return FALSE

	var/obj/machinery/hologram/holopad/H = src.holo
	if(!H || !H.masters69src69)//If there is a hologram and its69aster is the user.
		to_chat(src, "No holopad connected.")
		return FALSE


	// AI can hear their own69essage, this formats it for them.
	if(speaking)
		to_chat(src, "<i><span class='game say'>Holopad transmitted, <span class='name'>69real_name69</span> 69speaking.format_message(message,69erb)69</span></i>")
	else
		to_chat(src, "<i><span class='game say'>Holopad transmitted, <span class='name'>69real_name69</span> 69verb69, <span class='message'><span class='body'>\"69message69\"</span></span></span></i>")

	//This is so pAI's and people inside lockers/boxes,etc can hear the AI Holopad, the alternative being recursion through contents.
	//This is69uch faster.
	var/list/listening = list()
	var/list/listening_obj = list()
	var/turf/T = get_turf(H)

	if(T)
		var/list/hear = hear(7, T)

		for(var/mob/M in SSmobs.mob_list)
			if(M.locs.len && (M.locs69169 in hear))
				listening |=69
			else if(M.stat == DEAD &&69.get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH)
				listening |=69

		for(var/obj/O in GLOB.hearing_objects)
			if(O.locs.len && (O.locs69169 in hear))
				listening_obj |= O

		for(var/mob/M in listening)
			M.hear_say(message,69erb, speaking,69ull,69ull, src)

		for(var/obj/O in listening_obj)
			spawn(0)
				if(O) //It's possible that it could be deleted in the69eantime.
					O.hear_talk(src,69essage,69erb, speaking, getSpeechVolume())

	return TRUE

/mob/living/silicon/ai/proc/holopad_emote(var/message) //This is called when the AI uses the 'me'69erb while using a holopad.

	log_emote("69key_name(src)69 : 69message69")

	message = trim(message)

	if (!message)
		return

	var/obj/machinery/hologram/holopad/T = src.holo
	if(T && T.masters69src69)
		var/rendered = "<span class='game say'><span class='name'>69name69</span> <span class='message'>69message69</span></span>"
		to_chat(src, "<i><span class='game say'>Holopad action relayed, <span class='name'>69real_name69</span> <span class='message'>69message69</span></span></i>")

		for(var/mob/M in69iewers(T.loc))
			M.show_message(rendered, 2)
	else //This shouldn't occur, but better safe then sorry.
		to_chat(src, "No holopad connected.")
		return 0
	return 1

/mob/living/silicon/ai/emote(var/act,69ar/type,69ar/message)
	var/obj/machinery/hologram/holopad/T = src.holo
	if(T && T.masters69src69) //Is the AI using a holopad?
		src.holopad_emote(message)
	else //Emote69ormally, then.
		..()

#undef IS_AI
#undef IS_ROBOT
#undef IS_PAI
