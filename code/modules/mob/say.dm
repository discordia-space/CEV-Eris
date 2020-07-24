/mob/proc/say()
	return

/mob/verb/whisper()
	set name = "Whisper"
	set category = "IC"


/mob/verb/say_wrapper()
	set name = "Say verb"
	set category = "IC"

	set_typing_indicator(TRUE)
	hud_typing = TRUE
	var/message = input("", "say (text)") as text
	hud_typing = FALSE
	set_typing_indicator(FALSE)
	if(message)
		say_verb(message)


/mob/verb/say_verb(message as text)
	set name = "Say"
	set hidden = TRUE
	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "\red Speech is currently admin-disabled.")
		return
	set_typing_indicator(FALSE)
	usr.say(message)


/mob/verb/me_wrapper()
	set name = "Me verb"
	set category = "IC"

	set_typing_indicator(TRUE)
	hud_typing = TRUE
	var/message = input("", "me (text)") as text
	hud_typing = FALSE
	set_typing_indicator(FALSE)
	if(message)
		me_verb(message)


/mob/verb/me_verb(message as text)
	set name = "Me"
	set hidden = TRUE

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "\red Speech is currently admin-disabled.")
		return

	message = sanitize(message)

	set_typing_indicator(FALSE)
	if(use_me)
		usr.emote("me", usr.emote_type, message)
	else
		usr.emote(message)

/mob/proc/say_dead(var/message)
	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, SPAN_DANGER("Speech is currently admin-disabled."))
		return

	if(!src.client.holder)
		if(!config.dsay_allowed)
			to_chat(src, SPAN_DANGER("Deadchat is globally muted."))
			return

	if(get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		to_chat(usr, SPAN_DANGER("You have deadchat muted."))
		return

	say_dead_direct("[pick("complains", "moans", "whines", "laments", "blubbers")], <span class='message'>\"[emoji_parse(message)]\"</span>", src)

/mob/proc/say_understands(var/mob/other, var/datum/language/speaking = null)

	if(src.stat == DEAD)
		return TRUE

	//Universal speak makes everything understandable, for obvious reasons.
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
   There is no language handling build into it however there is at the /mob level so we accept the call
   for it but just ignore it.
*/

/mob/proc/say_quote(var/message, var/datum/language/speaking = null)
	var/verb = "says"
	var/ending = copytext(message, length(message))
	if(ending=="!")
		verb=pick("exclaims", "shouts", "yells")
	else if(ending=="?")
		verb="asks"

	return verb


/mob/proc/emote(var/act, var/type, var/message)
	if(act == "me")
		return custom_emote(type, message)

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/mob/proc/say_test(var/text)
	var/ending = copytext(text, length(text))
	if(ending == "?")
		return "1"
	else if(ending == "!")
		return "2"
	return "0"

//parses the message mode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the message mode string or null for no message mode.
//standard mode is the mode returned for the special ';' radio code.
/mob/proc/parse_message_mode(var/message, var/standard_mode = "headset")
	if(length(message) >= 1 && copytext(message,1,2) == get_prefix_key(/decl/prefix/radio_main_channel))
		return standard_mode

	if(length(message) >= 2 && copytext(message,1,2) == get_prefix_key(/decl/prefix/radio_channel_selection))
		var/channel_prefix = copytext_char(message, 2, 3)//copytext_char due to 2-bytes rusky symbols
		return department_radio_keys[channel_prefix]
	return null

//parses the language code (e.g. :j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise null.
/mob/proc/parse_language(var/message)
	var/prefix = copytext(message, 1, 2)
	
	if(length(message) >= 1 && prefix == get_prefix_key(/decl/prefix/audible_emote))
		return all_languages["Noise"]

	if(length(message) >= 2 && is_language_prefix(prefix))
		var/language_prefix = copytext(message, 2, 3)
		var/datum/language/L = language_keys[language_prefix]
		if(can_speak(L))
			return L

	return null
