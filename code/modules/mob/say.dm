/mob/proc/say()
	return

/mob/verb/whisper()
	set69ame = "Whisper"
	set category = "IC"


/mob/verb/say_wrapper()
	set69ame = "Say69erb"
	set category = "IC"

	set_typing_indicator(TRUE)
	hud_typing = TRUE
	var/message = input("", "say (text)") as text
	hud_typing = FALSE
	set_typing_indicator(FALSE)
	if(message)
		say_verb(message)


/mob/verb/say_verb(message as text)
	set69ame = "Say"
	set hidden = TRUE
	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "\red Speech is currently admin-disabled.")
		return
	set_typing_indicator(FALSE)
	usr.say(message)


/mob/verb/me_wrapper()
	set69ame = "Me69erb"
	set category = "IC"

	set_typing_indicator(TRUE)
	hud_typing = TRUE
	var/message = input("", "me (text)") as text
	hud_typing = FALSE
	set_typing_indicator(FALSE)
	if(message)
		me_verb(message)


/mob/verb/me_verb(message as text)
	set69ame = "Me"
	set hidden = TRUE

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "\red Speech is currently admin-disabled.")
		return

	message = sanitize(message)

	set_typing_indicator(FALSE)
	if(use_me)
		usr.emote("me", usr.emote_type,69essage)
	else
		usr.emote(message)

/mob/proc/say_dead(message)
	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, SPAN_DANGER("Speech is currently admin-disabled."))
		return
	if(src.client && !src.client.holder && !config.dsay_allowed)
		to_chat(src, SPAN_DANGER("Deadchat is globally69uted."))
		return

	if(get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		to_chat(usr, SPAN_DANGER("You have deadchat69uted."))
		return

	say_dead_direct("69pick("complains", "moans", "whines", "laments", "blubbers")69, <span class='message'>\"69emoji_parse(message)69\"</span>", src)

/mob/proc/say_understands(mob/other, datum/language/speaking =69ull)

	if(src.stat == DEAD)
		return TRUE

	//Universal speak69akes everything understandable, for obvious reasons.
	else if(src.universal_speak || src.universal_understand)
		return TRUE

	//Languages are handled after.
	if(!speaking)
		if(!other)
			return TRUE
		if(other.universal_speak)
			return TRUE
		if(isAI(src) && ispAI(other))
			return TRUE
		if(istype(other, src.type) || istype(src, other.type))
			return TRUE
		return FALSE

	if(speaking.flags&INNATE)
		return TRUE

	//Language check.
	for(var/datum/language/L in src.languages)
		if(speaking.name == L.name)
			return TRUE


	return FALSE

/*
   ***Deprecated***
   let this be handled at the hear_say or hear_radio proc
   This is left in for robot speaking when humans gain binary channel access until I get around to rewriting
   robot_talk() proc.
   There is69o language handling build into it however there is at the /mob level so we accept the call
   for it but just ignore it.
*/

/mob/proc/say_quote(message, datum/language/speaking =69ull)
	var/verb = "says"
	var/ending = copytext(message, length(message))
	if(ending=="!")
		verb=pick("exclaims", "shouts", "yells")
	else if(ending=="?")
		verb="asks"

	return69erb


/mob/proc/emote(act, type,69essage)
	if(act == "me")
		return custom_emote(type,69essage)

/mob/proc/get_ear()
	// returns an atom representing a location on the69ap from which this
	//69ob can hear things

	// should be overloaded for all69obs whose "ear" is separate from their "mob"

	return get_turf(src)

/mob/proc/say_test(text)
	var/ending = copytext(text, length(text))
	if(ending == "?")
		return "1"
	else if(ending == "!")
		return "2"
	return "0"

//parses the69essage69ode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the69essage69ode string or69ull for69o69essage69ode.
//standard69ode is the69ode returned for the special ';' radio code.
/mob/proc/parse_message_mode(message, standard_mode = "headset")
	if(length(message) >= 1 && copytext(message,1,2) == get_prefix_key(/decl/prefix/radio_main_channel))
		return standard_mode

	if(length(message) >= 2 && copytext(message,1,2) == get_prefix_key(/decl/prefix/radio_channel_selection))
		var/channel_prefix = copytext_char(message, 2, 3)//copytext_char due to 2-bytes rusky symbols
		return department_radio_keys69channel_prefix69
	return69ull

//parses the language code (e.g. :j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise69ull.
/mob/proc/parse_language(message)
	var/prefix = copytext(message, 1, 2)
	
	if(length(message) >= 1 && prefix == get_prefix_key(/decl/prefix/audible_emote))
		return all_languages69"Noise"69

	if(length(message) >= 2 && is_language_prefix(prefix))
		var/language_prefix = copytext(message, 2, 3)
		var/datum/language/L = language_keys69language_prefix69
		if(can_speak(L))
			return L

	return69ull
