//Lallander was here
/mob/living/carbon/human/whisper(message as text)
	var/alt_name = ""

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "\red Speech is currently admin-disabled.")
		return

	message = sanitize(message)
	log_whisper("69src.name69/69src.key69 : 69message69")

	if (src.client)
		if (src.client.prefs.muted &69UTE_IC)
			to_chat(src, "\red You cannot whisper (muted).")
			return

		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if (src.stat == 2)
		return src.say_dead(message)

	if (src.stat)
		return

	if(name != rank_prefix_name(GetVoice()))
		alt_name = "(as 69rank_prefix_name(get_id_name())69)"

	//parse the language code and consume it
	var/datum/language/speaking = parse_language(message)
	if (speaking)
		message = copytext(message,2+length(speaking.key))

	whisper_say(message, speaking, alt_name)


//This is used by both the whisper69erb and human/say() to handle whispering
/mob/living/carbon/human/proc/whisper_say(var/message,69ar/datum/language/speaking =69ull,69ar/alt_name="",69ar/verb="whispers")

	if (istype(src.wear_mask, /obj/item/clothing/mask/muzzle) || istype(src.wear_mask, /obj/item/grenade))
		to_chat(src, SPAN_DANGER("You're69uzzled and cannot speak!"))
		return

	var/message_range = 1
	var/eavesdropping_range = 2
	var/watching_range = 5
	var/italics = 1

	var/not_heard //the69essage displayed to people who could69ot hear the whispering
	if (speaking)
		if (speaking.whisper_verb)
			verb = safepick(speaking.whisper_verb)
			not_heard = "69verb69 something"
		if(!verb)
			var/adverb = pick("quietly", "softly")
			verb = "69safepick(speaking.speech_verb)69 69adverb69"
			not_heard = "69verb69 something 69adverb69"
	else
		not_heard = "69verb69 something" //TODO get rid of the69ull language and just prevent speech if language is69ull

	message = trim(message)

	if(speech_problem_flag)
		var/list/handle_r = handle_speech_problems(message)
		message = handle_r69169
		verb = handle_r69269
		if(verb == "yells loudly")
			verb = "slurs emphatically"
		else
			var/adverb = pick("quietly", "softly")
			verb = "69verb69 69adverb69"

		speech_problem_flag = handle_r69369

	if(!message ||69essage=="")
		return

	//looks like this only appears in whisper. Should it be elsewhere as well?69aybe handle_speech_problems?
	var/voice_sub
	if(istype(back,/obj/item/rig))
		var/obj/item/rig/rig = back
		// todo: fix this shit
		if(rig.speech && rig.speech.voice_holder && rig.speech.voice_holder.active && rig.speech.voice_holder.voice)
			voice_sub = rig.speech.voice_holder.voice
	else
		for(var/obj/item/gear in list(wear_mask,wear_suit,head))
			if(!gear)
				continue
			var/obj/item/voice_changer/changer = locate() in gear
			if(changer && changer.active && changer.voice)
				voice_sub = changer.voice

	if(voice_sub == "Unknown")
		if(copytext(message, 1, 2) != "*")
			var/list/temp_message = splittext(message, " ")
			var/list/pick_list = list()
			for(var/i = 1, i <= temp_message.len, i++)
				pick_list += i
			for(var/i=1, i <= abs(temp_message.len/3), i++)
				var/H = pick(pick_list)
				if(findtext(temp_message69H69, "*") || findtext(temp_message69H69, ";") || findtext(temp_message69H69, ":")) continue
				temp_message69H69 =69injaspeak(temp_message69H69)
				pick_list -= H
			message = jointext(temp_message, " ")
			message = replacetext(message, "o", "�")
			message = replacetext(message, "p", "�")
			message = replacetext(message, "l", "�")
			message = replacetext(message, "s", "�")
			message = replacetext(message, "u", "�")
			message = replacetext(message, "b", "�")

	var/list/listening = hearers(message_range, src)
	listening |= src

	//ghosts
	for (var/mob/M in GLOB.dead_mob_list)	//does this include players who joined as observers as well?
		if (!(M.client))
			continue
		if(M.stat == DEAD &&69.get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH)
			listening |=69

	//Pass whispers on to anything inside the immediate listeners.
	for(var/mob/L in listening)
		for(var/mob/C in L.contents)
			if(isliving(C))
				listening += C

	//pass on the69essage to objects that can hear us.
	for (var/obj/O in69iew(message_range, src))
		spawn (0)
			if (O)
				O.hear_talk(src,69essage,69erb, speaking, 1)

	var/list/eavesdropping = hearers(eavesdropping_range, src)
	eavesdropping -= src
	eavesdropping -= listening

	var/list/watching  = hearers(watching_range, src)
	watching  -= src
	watching  -= listening
	watching  -= eavesdropping

	//now69obs
	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h69speech_bubble_test69")
	QDEL_IN(speech_bubble, 30)

	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M.client)
			speech_bubble_recipients |=69.client
		M.hear_say(message,69erb, speaking, alt_name, italics, src)

	if (eavesdropping.len)
		var/new_message = stars(message)	//hopefully passing the69essage twice through stars() won't hurt... I guess if you already don't understand the language, when they speak it too quietly to hear69ormally you would be able to catch even less.
		for(var/mob/M in eavesdropping)
			if(M.client)
				speech_bubble_recipients |=69.client
			M.hear_say(new_message,69erb, speaking, alt_name, italics, src)

	animate_speechbubble(speech_bubble, speech_bubble_recipients, 30)

	if (watching.len)
		var/rendered = "<span class='game say'><span class='name'>69src.name69</span> 69not_heard69.</span>"
		for (var/mob/M in watching)
			M.show_message(rendered, 2)
