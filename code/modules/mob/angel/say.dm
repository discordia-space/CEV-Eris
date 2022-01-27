/mob/observer/eye/angel/say(var/message)
	message = sanitize(message)

	if (!message)
		return

	log_say("ANGEL/69src.key69 : 69message69")

	if (src.client)
		if(src.client.prefs.muted &69UTE_DEADCHAT)
			to_chat(src, "\red You cannot talk in deadchat and ANGEL chat (muted).")
			return

		if (src.client.handle_spam_prevention(message,MUTE_DEADCHAT))
			return

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, SPAN_DANGER("Speech is currently admin-disabled."))
		return

	if(!src.client.holder)
		if(!config.dsay_allowed)
			to_chat(src, SPAN_DANGER("Deadchat and ANGEL chat are globally69uted."))
			return

	if(get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		to_chat(usr, SPAN_DANGER("You have deadchat and ANGEL chat69uted."))
		return

	say_angel_direct("69pick("beeps","buzzes","echoes","fizzes")69, <span class='message'>\"69message69\"</span>", src)


/mob/observer/eye/angel/emote(var/act,69ar/type,69ar/message)
	//message = sanitize(message) - already sanitized in69erb/me_verb()

	if(!message)
		return

	if(act != "me")
		return

	log_emote("ANGEL/69src.key69 : 69message69")

	if(src.client)
		if(src.client.prefs.muted &69UTE_DEADCHAT)
			to_chat(src, "\red You cannot emote in deadchat and ANGEL chat (muted).")
			return

		if(src.client.handle_spam_prevention(message,69UTE_DEADCHAT))
			return

	if(client.prefs.muted &69UTE_DEADCHAT)
		to_chat(src, SPAN_DANGER("You cannot send deadchat and ANGEL emotes (muted)."))
		return

	if(get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		to_chat(src, SPAN_DANGER("You have deadchat and ANGEL chat69uted."))
		return

	if(!src.client.holder)
		if(!config.dsay_allowed)
			to_chat(src, SPAN_DANGER("Deadchat and ANGEL chat are globally69uted."))
			return


	var/input
	if(!message)
		input = sanitize(input(src, "Choose an emote to display.") as text|null)
	else
		input =69essage

	if(input)
		log_emote("ANGEL/69src.key69 : 69input69")
		say_angel_direct(input, src)



/proc/say_angel_direct(var/message,69ar/mob/subject =69ull)
	var/name
	var/keyname
	if(subject && subject.client)
		var/client/C = subject.client
		keyname = (C.holder && C.holder.fakekey) ? C.holder.fakekey : C.key
		if (C.mob)
			name = C.mob.name
		else
			name = "Unknown ANGEL"
			// this should69ot happen usually
			log_world("DEBUG: say_angel_direct() invoked when client has69o .mob property")
			log_debug("say_angel_direct() invoked when client has69o .mob property")

	for(var/mob/M in GLOB.player_list)
		if(M.client && ((!istype(M, /mob/new_player) &&69.stat == DEAD) || (M.client.holder && !is_mentor(M.client))) &&69.get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_SHOW)
			var/lname
			if(subject)
				if(M.client.holder) 							// What admins see
					lname = "69keyname69 (69name69)"
				else
					lname =69ame
				lname = "<span class='name'>69lname69</span> "
			to_chat(M, "<span class='angelsay'>" + create_text_tag("angel", "ANGEL:",69.client) + " 69lname6969message69</span>")