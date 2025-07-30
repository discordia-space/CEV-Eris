/mob/proc/say()
	return

/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_red("Speech is currently admin-disabled."))
		return

	if(ishuman(src))
		var/mob/living/carbon/human/human = src
		if(human.suppress_communication)
			to_chat(src, human.get_suppressed_message())
			return

	if(!message)
		set_typing_indicator(TRUE)
		hud_typing = TRUE
		message = input("", "say (text)") as text
		hud_typing = FALSE
		set_typing_indicator(FALSE)
	if(message)
		say(message)


/mob/verb/me_verb(message as text)
	set name = "Emote"
	set category = "IC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_red("Speech is currently admin-disabled."))
		return

	if(ishuman(src))
		var/mob/living/carbon/human/human = src
		if(human.suppress_communication)
			to_chat(src, human.get_suppressed_message())
			return

	if(!message)
		set_typing_indicator(TRUE)
		hud_typing = TRUE
		message = input("", "me (text)") as text
		hud_typing = FALSE
		set_typing_indicator(FALSE)
	if(message)
		message = sanitize(message)
		if(use_me)
			emote("me", emote_type, message)
		else
			emote(message)


/mob/proc/say_dead(message)
	var/name = real_name
	var/alt_name = ""
	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return
	if(src.client && !src.client.holder && !GLOB.dsay_allowed)
		to_chat(src, span_danger("Deadchat is globally muted."))
		return

	if(get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		to_chat(usr, span_danger("You have deadchat muted."))
		return

	if (usr.client.prefs.muted & MUTE_DEADCHAT)
		to_chat(src, span_danger("You are muted from deadchat."))
		return

	if (src.client && src.client.handle_spam_prevention(message, MUTE_DEADCHAT))
		return

	if (mind?.name)
		name = "[mind.name]"
	else
		name = real_name
	if (name != real_name)
		alt_name = " (died as [real_name])"

	var/spanned = say_quote(say_emphasis(message))
	var/source = "<span class='game'><span class='prefix'>DEAD:</span> <span class='name'>[name]</span>[alt_name]"
	var/rendered = " <span class='message'>[emoji_parse(spanned)]</span></span>"
	log_talk(message, LOG_SAY, tag="DEAD")
	var/displayed_key = key
	if(client?.holder?.fakekey)
		displayed_key = null
	deadchat_broadcast(rendered, source, follow_target = src, speaker_key = displayed_key)
	create_chat_message(src, /datum/language/common, message)
	for(var/mob/M in GLOB.player_list)
		if(M == src)
			continue
		if(SSticker.current_state != GAME_STATE_FINISHED && (M.see_invisible < invisibility))
			continue
		if (M.client.prefs.RC_enabled)
			M.create_chat_message(src, /datum/language/common, message)

/mob/proc/say_understands(mob/other, datum/language/speaking = null)

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

/atom/movable/proc/say_mod(input, list/message_mods = list())
	var/ending = copytext_char(input, -1)
	if(copytext_char(input, -2) == "!!")
		return verb_yell
	else if(message_mods[MODE_SING])
		. = verb_sing
	else if(message_mods[WHISPER_MODE])
		. = verb_whisper
	else if(ending == "?")
		return verb_ask
	else if(ending == "!")
		return verb_exclaim
	else
		return verb_say

/atom/movable/proc/say_quote(input, list/spans=list(speech_span), list/message_mods = list())
	if(!input)
		input = "..."

	var/say_mod = message_mods[MODE_CUSTOM_SAY_EMOTE]
	if (!say_mod)
		say_mod = say_mod(input, message_mods)

	SEND_SIGNAL(src, COMSIG_MOVABLE_SAY_QUOTE, args)

	if(copytext_char(input, -2) == "!!")
		spans |= SPAN_YELL

	var/spanned = attach_spans(input, spans)
	return "[say_mod], \"[spanned]\""

/mob/proc/emote(act, type, message)
	if(act == "me")
		return custom_emote(type, message)

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/mob/proc/say_test(text)
	var/ending = copytext(text, length(text))
	if(ending == "?")
		return "1"
	else if(ending == "!")
		return "2"
	return "0"

//parses the message mode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the message mode string or null for no message mode.
//standard mode is the mode returned for the special ';' radio code.
/mob/proc/parse_message_mode(message, standard_mode = "headset")
	if(length(message) >= 1 && copytext(message,1,2) == get_prefix_key(/decl/prefix/radio_main_channel))
		return standard_mode

	if(length(message) >= 2 && copytext(message,1,2) == get_prefix_key(/decl/prefix/radio_channel_selection))
		var/channel_prefix = copytext_char(message, 2, 3)//copytext_char due to 2-bytes rusky symbols
		return department_radio_keys[channel_prefix]
	return null

//parses the language code (e.g. :j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise null.
/mob/proc/parse_language(message)
	var/prefix = copytext(message, 1, 2)

	if(length(message) >= 1 && prefix == get_prefix_key(/decl/prefix/audible_emote))
		return GLOB.all_languages["Noise"]

	if(length(message) >= 2 && is_language_prefix(prefix))
		var/language_prefix = copytext(message, 2, 3)
		var/datum/language/L = GLOB.language_keys[language_prefix]
		if(can_speak(L))
			return L

	return null

// Similar to parse_language on mobs but globally, and only supports : or ,
/proc/parse_language(message)
	var/prefix = copytext(message, 1, 2)

	if(length(message) >= 2 && (prefix == ":" || prefix == ","))
		var/language_prefix = copytext(message, 2, 3)
		var/datum/language/L = GLOB.language_keys[language_prefix]
		return L

	return null

/proc/attach_spans(input, list/spans)
	return "[message_spans_start(spans)][input]</span>"

/proc/message_spans_start(list/spans)
	var/output = "<span class='"
	for(var/S in spans)
		output = "[output][S] "
	output = "[output]'>"
	return output
