/mob/observer/eye/angel/say(message)
	message = sanitize(message)

	if (!message)
		return

	log_say("ANGEL/[src.key] : [message]")

	if (src.client)
		if(src.client.prefs.muted & MUTE_DEADCHAT)
			to_chat(src, span_red("You cannot talk in deadchat and ANGEL chat (muted)."))
			return

		if (src.client.handle_spam_prevention(message,MUTE_DEADCHAT))
			return

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(!src.client.holder)
		if(!GLOB.dsay_allowed)
			to_chat(src, span_danger("Deadchat and ANGEL chat are globally muted."))
			return

	if(get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		to_chat(usr, span_danger("You have deadchat and ANGEL chat muted."))
		return

	say_angel_direct("[pick("beeps","buzzes","echoes","fizzes")], [span_message("\"[message]\"")]", src)


/mob/observer/eye/angel/emote(act, type, message)
	//message = sanitize(message) - already sanitized in verb/me_verb()

	if(!message)
		return

	if(act != "me")
		return

	log_emote("ANGEL/[src.key] : [message]")

	if(src.client)
		if(src.client.prefs.muted & MUTE_DEADCHAT)
			to_chat(src, span_red("You cannot emote in deadchat and ANGEL chat (muted)."))
			return

		if(src.client.handle_spam_prevention(message, MUTE_DEADCHAT))
			return

	if(client.prefs.muted & MUTE_DEADCHAT)
		to_chat(src, span_danger("You cannot send deadchat and ANGEL emotes (muted)."))
		return

	if(get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		to_chat(src, span_danger("You have deadchat and ANGEL chat muted."))
		return

	if(!src.client.holder)
		if(!GLOB.dsay_allowed)
			to_chat(src, span_danger("Deadchat and ANGEL chat are globally muted."))
			return


	var/input
	if(!message)
		input = sanitize(input(src, "Choose an emote to display.") as text|null)
	else
		input = message

	if(input)
		log_emote("ANGEL/[src.key] : [input]")
		say_angel_direct(input, src)



/proc/say_angel_direct(message, mob/subject = null)
	var/name
	var/keyname
	if(subject && subject.client)
		var/client/C = subject.client
		keyname = (C.holder && C.holder.fakekey) ? C.holder.fakekey : C.key
		if (C.mob)
			name = C.mob.name
		else
			name = "Unknown ANGEL"
			// this should not happen usually
			log_world("DEBUG: say_angel_direct() invoked when client has no .mob property")
			log_debug("say_angel_direct() invoked when client has no .mob property")

	for(var/mob/M in GLOB.player_list)
		if(M.client && ((!istype(M, /mob/new_player) && M.stat == DEAD) || (M.client.holder && !is_mentor(M.client))) && M.get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_SHOW)
			var/lname
			if(subject)
				if(M.client.holder) 							// What admins see
					lname = "[keyname] ([name])"
				else
					lname = name
				lname = "[span_name("[lname]")] "
			to_chat(M, span_angelsay("" + create_text_tag("angel", "ANGEL:", M.client) + " [lname][message]"))
