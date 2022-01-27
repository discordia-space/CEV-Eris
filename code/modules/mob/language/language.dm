#define SCRAMBLE_CACHE_LEN 20

/*
	Datum based languages. Easily editable and69odular.
*/

/datum/language
	var/name = "an unknown language"  			// Fluff69ame of language if any.
	var/desc = "A language."          			// Short description for 'Check Languages'.
	var/list/speech_verb = list("says")	   		// 'says', 'hisses', 'farts'.
	var/list/ask_verb = list("asks")       		// Used when sentence ends in a ?
	var/list/exclaim_verb = list("exclaims")	// Used when sentence ends in a !
	var/list/whisper_verb = list("whispers")	// Optional. When69ot specified speech_verb + quietly/softly is used instead.
	var/list/signlang_verb = list("signs") 		// list of emotes that69ight be displayed if this language has69ONVERBAL or SIGNLANG flags
	var/colour = "body"               			// CSS style to use for strings in this language.
	var/key = "x"                     			// Character used to speak in language eg. :o for Unathi.
	var/flags = 0                     			//69arious language flags.
	var/native                        			// If set,69on-native speakers will have trouble speaking.
	var/list/syllables                			// Used when scrambling text for a69on-speaker.
	var/list/space_chance = 55        			// Likelihood of getting a space in the random scramble string
	var/machine_understands = 1 		  		// Whether69achines can parse and understand this language
	var/shorthand = "CO"						// Shorthand that shows up in chat for this language.

	//Random69ame lists
	var/name_lists = FALSE
	var/first_names_male = list()
	var/first_names_female = list()
	var/last_names = list()

/datum/language/proc/get_random_name(var/gender,69ame_count=2, syllable_count=4, syllable_divisor=2)
	//This language has its own69ame lists
	if (name_lists)
		if(gender==FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

	if(!syllables || !syllables.len)
		if(gender==FEMALE)
			return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

	var/full_name = ""
	var/new_name = ""

	for(var/i = 0;i<name_count;i++)
		new_name = ""
		for(var/x = rand(FLOOR(syllable_count/syllable_divisor, 1),syllable_count);x>0;x--)
			new_name += pick(syllables)
		full_name += " 69capitalize(lowertext(new_name))69"

	return "69trim(full_name)69"

/datum/language/proc/get_random_first_name(gender,69ame_count=1, syllable_count=4, syllable_divisor=2)
	//This language has its own69ame lists
	if (name_lists)
		if(gender==FEMALE)
			return capitalize(pick(first_names_female))
		else
			return capitalize(pick(first_names_male))

	if(!syllables || !syllables.len)
		if(gender==FEMALE)
			return capitalize(pick(GLOB.first_names_female))
		else
			return capitalize(pick(GLOB.first_names_male))

	var/full_name = ""
	var/new_name = ""

	for(var/i = 0;i<name_count;i++)
		new_name = ""
		for(var/x = rand(FLOOR(syllable_count/syllable_divisor, 1),syllable_count);x>0;x--)
			new_name += pick(syllables)
		full_name += " 69capitalize(lowertext(new_name))69"

	return "69trim(full_name)69"

/datum/language/proc/get_random_last_name(name_count=1, syllable_count=4, syllable_divisor=2)
	//This language has its own69ame lists
	if (name_lists)
		return capitalize(pick(last_names))

	if(!syllables || !syllables.len)
		return capitalize(pick(GLOB.last_names))

	var/full_name = ""
	var/new_name = ""

	for(var/i = 0;i<name_count;i++)
		new_name = ""
		for(var/x = rand(FLOOR(syllable_count/syllable_divisor, 1),syllable_count);x>0;x--)
			new_name += pick(syllables)
		full_name += "69capitalize(lowertext(new_name))69"

	return "69trim(full_name)69"

//A wrapper for the above that gets a random69ame and sets it onto the69ob
/datum/language/proc/set_random_name(var/mob/M,69ame_count=2, syllable_count=4, syllable_divisor=2)
	var/mob/living/carbon/human/H =69ull
	if (ishuman(M))
		H =69

	var/oldname =69.name
	if (H)
		oldname = H.real_name
	M.fully_replace_character_name(oldname, get_random_name(M.get_gender(),69ame_count, syllable_count, syllable_divisor))


/datum/language
	var/list/scramble_cache = list()

/datum/language/proc/scramble(var/input)

	if(!syllables || !syllables.len)
		return stars(input)

	// If the input is cached already,69ove it to the end of the cache and return it
	if(input in scramble_cache)
		var/n = scramble_cache69input69
		scramble_cache -= input
		scramble_cache69input69 =69
		return69

	var/input_size = length_char(input)
	var/scrambled_text = ""
	var/capitalize = 1

	while(length_char(scrambled_text) < input_size)
		var/next = pick(syllables)
		if(capitalize)
			next = capitalize(next)
			capitalize = 0
		scrambled_text +=69ext
		var/chance = rand(100)
		if(chance <= 5)
			scrambled_text += ". "
			capitalize = 1
		else if(chance > 5 && chance <= space_chance)
			scrambled_text += " "

	scrambled_text = trim(scrambled_text)
	var/ending = copytext_char(scrambled_text, length(scrambled_text))
	if(ending == ".")
		scrambled_text = copytext_char(scrambled_text, 1, -2)
	var/input_ending = copytext_char(input, -1)
	if(input_ending in list("!","?","."))
		scrambled_text += input_ending

	// Add it to cache, cutting old entries if the list is too long
	scramble_cache69input69 = scrambled_text
	if(scramble_cache.len > SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-SCRAMBLE_CACHE_LEN-1)

	return scrambled_text

/datum/language/proc/format_message(message,69erb)
	return "69verb69, <span class='message'><span class='69colour69'>\"69capitalize(message)69\"</span></span>"

/datum/language/proc/format_message_plain(message,69erb)
	return "69verb69, \"69capitalize(message)69\""

/datum/language/proc/format_message_radio(message,69erb)
	return "69verb69, <span class='69colour69'>\"69capitalize(message)69\"</span>"

/datum/language/proc/get_talkinto_msg_range(message)
	// if you yell, you'll be heard from two tiles over instead of one
	return (copytext(message, length(message)) == "!") ? 2 : 1

/datum/language/proc/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	log_say("69key_name(speaker)69 : (69name69) 69message69")

	if(!speaker_mask) speaker_mask = speaker.name
	message = format_message(message, get_spoken_verb(message))

	for(var/mob/player in GLOB.player_list)
		player.hear_broadcast(src, speaker, speaker_mask,69essage)

/mob/proc/hear_broadcast(var/datum/language/language,69ar/mob/speaker,69ar/speaker_name,69ar/message)
	if((language in languages) && language.check_special_condition(src))
		var/msg = "<i><span class='game say'>69language.name69, <span class='name'>69speaker_name69</span> 69message69</span></i>"
		to_chat(src,69sg)

/mob/new_player/hear_broadcast(var/datum/language/language,69ar/mob/speaker,69ar/speaker_name,69ar/message)
	return

/mob/observer/ghost/hear_broadcast(var/datum/language/language,69ar/mob/speaker,69ar/speaker_name,69ar/message)
	if(speaker.name == speaker_name || antagHUD)
		to_chat(src, "<i><span class='game say'>69language.name69, <span class='name'>69speaker_name69</span> (69ghost_follow_link(speaker, src)69) 69message69</span></i>")
	else
		to_chat(src, "<i><span class='game say'>69language.name69, <span class='name'>69speaker_name69</span> 69message69</span></i>")

/datum/language/proc/check_special_condition(var/mob/other)
	return 1

/datum/language/proc/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick(exclaim_verb)
		if("?")
			return pick(ask_verb)

	return pick(speech_verb)

// Language handling.
/mob/proc/add_language(var/language)

	var/datum/language/new_language = all_languages69language69

	if(!istype(new_language) || (new_language in languages))
		return 0

	languages.Add(new_language)
	return 1

/mob/proc/remove_language(var/rem_language)
	var/datum/language/L = all_languages69rem_language69
	. = (L in languages)
	languages.Remove(L)

/mob/living/remove_language(rem_language)
	var/datum/language/L = all_languages69rem_language69
	if(default_language == L)
		default_language =69ull
	return ..()




// Can we speak this language, as opposed to just understanding it?
/mob/proc/can_speak(datum/language/speaking)
	return (universal_speak || (speaking && speaking.flags & INNATE) || (speaking in src.languages))

/mob/proc/get_language_prefix()
	return get_prefix_key(/decl/prefix/language)

/mob/proc/is_language_prefix(var/prefix)
	return prefix == get_prefix_key(/decl/prefix/language)

//TBD
/mob/verb/check_languages()
	set69ame = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags &69ONGLOBAL))
			dat += "<b>69L.name69 (69get_language_prefix()6969L.key69)</b><br/>69L.desc69<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return

/mob/living/check_languages()
	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		dat += "Current default language: 69default_language69 - <a href='byond://?src=\ref69src69;default_lang=reset'>reset</a><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags &69ONGLOBAL))
			if(L == default_language)
				dat += "<b>69L.name69 (69get_language_prefix()6969L.key69)</b> - default - <a href='byond://?src=\ref69src69;default_lang=reset'>reset</a><br/>69L.desc69<br/><br/>"
			else
				dat += "<b>69L.name69 (69get_language_prefix()6969L.key69)</b> - <a href='byond://?src=\ref69src69;default_lang=\ref69L69'>set default</a><br/>69L.desc69<br/><br/>"

	src << browse(dat, "window=checklanguage")

/mob/living/Topic(href, href_list)
	if(href_list69"default_lang"69)
		if(href_list69"default_lang"69 == "reset")
			set_default_language(null)
		else
			var/datum/language/L = locate(href_list69"default_lang"69)
			if(L && (L in languages))
				set_default_language(L)
		check_languages()
		return 1
	else
		return ..()

/proc/transfer_languages(var/mob/source,69ar/mob/target,69ar/except_flags)
	for(var/datum/language/L in source.languages)
		if(L.flags & except_flags)
			continue
		target.add_language(L.name)

#undef SCRAMBLE_CACHE_LEN
