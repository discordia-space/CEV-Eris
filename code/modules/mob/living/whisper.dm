/mob/living/verb/whisper(message as text)
	set name = "Whisper"
	set category = "IC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_red("Speech is currently admin-disabled."))
		return

	message = sanitize(message)
	log_whisper("[src.name]/[src.key] : [message]")

	if (src.client)
		if (src.client.prefs.muted & MUTE_IC)
			to_chat(src, span_red("You cannot whisper (muted)."))
			return

		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if (src.stat == DEAD)
		return src.say_dead(message)

	//parse the language code and consume it
	var/datum/language/speaking = parse_language(message)
	if (speaking)
		message = copytext(message,2+length(speaking.key))

	whisper_say(message, speaking)

/mob/living/proc/whisper_say(var/message, var/datum/language/speaking = null, var/alt_name="", var/verb="whispers")
	if (istype(src.wear_mask, /obj/item/clothing/mask/muzzle) || istype(src.wear_mask, /obj/item/grenade))
		to_chat(src, span_danger("You're muzzled and cannot speak!"))
		return

	var/message_range = 1
	var/eavesdropping_range = 2
	var/watching_range = 5
	var/italics = 1

	var/not_heard //the message displayed to people who could not hear the whispering
	var/adverb = pick("quietly", "softly")
	not_heard = "[verb] something [adverb]"
	verb = "[verb_whisper] [adverb]"

	message = trim(message)

	if(speech_problem_flag)
		var/list/handle_r = handle_speech_problems(message)
		message = handle_r[SPEECHPROBLEM_R_MESSAGE]
		verb = handle_r[SPEECHPROBLEM_R_VERB]
		if(verb == "yells loudly")
			verb = "slurs emphatically"
		else
			verb = "[verb] [adverb]"

		speech_problem_flag = handle_r[SPEECHPROBLEM_R_FLAG]

	if(!message || message=="")
		return

	//looks like this only appears in whisper. Should it be elsewhere as well? Maybe handle_speech_problems?
	var/voice_sub
	if(istype(back,/obj/item/rig))
		var/obj/item/rig/rig = back
		// todo: fix this shit
		if(rig.speech && rig.speech.voice_holder && rig.speech.voice_holder.active && rig.speech.voice_holder.voice_name)
			voice_sub = rig.speech.voice_holder.voice_name
	else if(ishuman(src))
		var/mob/living/carbon/human/our_human = src
		for(var/obj/item/gear in list(our_human.wear_mask, our_human.wear_suit, our_human.head))
			if(!gear)
				continue
			var/obj/item/voice_changer/changer = locate() in gear
			if(changer && changer.active && changer.voice_name)
				voice_sub = changer.voice_name


	if(voice_sub == "Unknown")
		if(copytext(message, 1, 2) != "*")
			var/list/temp_message = splittext(message, " ")
			var/list/pick_list = list()
			for(var/i = 1, i <= temp_message.len, i++)
				pick_list += i
			for(var/i=1, i <= abs(temp_message.len/3), i++)
				var/H = pick(pick_list)
				if(findtext(temp_message[H], "*") || findtext(temp_message[H], ";") || findtext(temp_message[H], ":")) continue
				temp_message[H] = ninjaspeak(temp_message[H])
				pick_list -= H
			message = jointext(temp_message, " ")
			message = replacetext(message, "o", "�")
			message = replacetext(message, "p", "�")
			message = replacetext(message, "l", "�")
			message = replacetext(message, "s", "�")
			message = replacetext(message, "u", "�")
			message = replacetext(message, "b", "�")

	var/list/listening = hearers(message_range, get_turf(src))
	listening |= src

	//ghosts
	for (var/mob/M in GLOB.dead_mob_list)	//does this include players who joined as observers as well?
		if (!(M.client))
			continue
		if(M.stat == DEAD && M.get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH)
			listening |= M

	//Pass whispers on to anything inside the immediate listeners.
	for(var/mob/L in listening)
		for(var/mob/C in L.contents)
			if(isliving(C))
				listening += C

	//pass on the message to objects that can hear us.
	for (var/obj/O in view(message_range, src))
		spawn (0)
			if (O)
				O.hear_talk(src, message, verb, speaking, 1)

	var/list/eavesdropping = hearers(eavesdropping_range, get_turf(src))
	eavesdropping -= src
	eavesdropping -= listening

	var/list/watching  = hearers(watching_range, get_turf(src))
	watching  -= src
	watching  -= listening
	watching  -= eavesdropping

	//now mobs
	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
	QDEL_IN(speech_bubble, 30)

	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M.client)
			speech_bubble_recipients |= M.client
		M.hear_say(message, verb, speaking, alt_name, italics, src)

	if (eavesdropping.len)
		var/new_message = stars(message)	//hopefully passing the message twice through stars() won't hurt... I guess if you already don't understand the language, when they speak it too quietly to hear normally you would be able to catch even less.
		for(var/mob/M in eavesdropping)
			if(M.client)
				speech_bubble_recipients |= M.client
			M.hear_say(new_message, verb, speaking, alt_name, italics, src)

	animate_speechbubble(speech_bubble, speech_bubble_recipients, 30)

	if (watching.len)
		var/rendered = "<span class='game say'>[span_name("[src.name]")] [not_heard].</span>"
		for (var/mob/M in watching)
			M.show_message(rendered, 2)
