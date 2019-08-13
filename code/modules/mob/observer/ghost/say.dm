/mob/observer/ghost/say(var/message)
	message = sanitize(message)

	if(!message)
		return

	log_say("Ghost/[src.key] : [message]")

	if(src.client)
		if(src.client.prefs.muted&MUTE_DEADCHAT)
			to_chat(src, "\red You cannot talk in deadchat (muted).")
			return

		if(src.client.handle_spam_prevention(message, MUTE_DEADCHAT))
			return

	. = src.say_dead(message)

/mob/observer/ghost/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",
		var/italics = FALSE, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(!client)
		return

	if(speaker && !speaker.client && get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH && !(speaker in view(src)))
			//Does the speaker have a client?
			// It's either random stuff that observers won't care about (Experiment 97B says, 'EHEHEHEHEHEHEHE')
			//Or someone snoring.  So we make it where they won't hear it.
		return
	..()


/mob/observer/ghost/emote(var/act, var/type, var/message)
	//message = sanitize(message) - already sanitized in verb/me_verb()

	if(!message)
		return

	if(act != "me")
		return

	log_emote("Ghost/[src.key] : [message]")

	if(src.client)
		if(src.client.prefs.muted&MUTE_DEADCHAT)
			to_chat(src, "\red You cannot emote in deadchat (muted).")
			return

		if(src.client.handle_spam_prevention(message, MUTE_DEADCHAT))
			return

	. = src.emote_dead(message)

/*
	for (var/mob/M in hearers(null, null))
		if(!M.stat)
			if(M.job == "Monochurch Preacher")
				if(prob (49))
					M.show_message("<span class='game'><i>You hear muffled speech... but nothing is there...</i></span>", 2)
					if(prob(20))
						playsound(src.loc, pick('sound/effects/ghost.ogg','sound/effects/ghost2.ogg'), 10, 1)
				else
					M.show_message("<span class='game'><i>You hear muffled speech... you can almost make out some words...</i></span>", 2)
//				M.show_message("<span class='game'><i>[stutter(message)]</i></span>", 2)
					if(prob(30))
						playsound(src.loc, pick('sound/effects/ghost.ogg','sound/effects/ghost2.ogg'), 10, 1)
			else
				if(prob(50))
					return
				else if(prob (95))
					M.show_message("<span class='game'><i>You hear muffled speech... but nothing is there...</i></span>", 2)
					if(prob(20))
						playsound(src.loc, pick('sound/effects/ghost.ogg','sound/effects/ghost2.ogg'), 10, 1)
				else
					M.show_message("<span class='game'><i>You hear muffled speech... you can almost make out some words...</i></span>", 2)
//				M.show_message("<span class='game'><i>[stutter(message)]</i></span>", 2)
					playsound(src.loc, pick('sound/effects/ghost.ogg','sound/effects/ghost2.ogg'), 10, 1)
*/
