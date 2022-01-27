/mob/living/simple_animal/borer/say(var/message)

	message = sanitize(message)
	message = capitalize(message)

	if(!message)
		return

	if (stat == 2)
		return say_dead(message)

	if (stat)
		return

	if (src.client)
		if(client.prefs.muted &69UTE_IC)
			to_chat(src, "\red You cannot speak in IC (muted).")
			return
		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if (copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	var/datum/language/L = parse_language(message)
	if(L && L.flags & HIVEMIND)
		L.broadcast(src,trim(copytext(message,3)),src.truename)
		return

	if(!host)
		//TODO: have this pick a random69ob within 3 tiles to speak for the borer.
		to_chat(src, "You have69o host to speak to.")
		return //No host,69o audible speech.

	to_chat(src, "You drop words into 69host69's69ind: \"69message69\"")
	to_chat(host, "Your own thoughts speak: \"69message69\"")

	for (var/mob/M in GLOB.player_list)
		if (isnewplayer(M))
			continue
		else if(M.stat == DEAD &&69.get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH)
			to_chat(M, "69src.truename69 whispers to 69host69, \"69message69\"")
