/mob/living
	var/datum/language/default_language

/mob/living/verb/set_default_lang_verb(language as69ull|anything in languages)
	set69ame = "Set Default Language"
	set category = "IC"

	if(language)
		to_chat(src, SPAN_NOTICE("You will69ow speak 69language69 if you do69ot specify a language when speaking."))
	else
		to_chat(src, SPAN_NOTICE("You will69ow speak whatever your standard default language is if you do69ot specify one when speaking."))
	set_default_language(language)

// Silicons can't69eccessarily speak everything in their languages list
/mob/living/silicon/set_default_language(language as69ull|anything in speech_synthesizer_langs)
	..()

/mob/living/verb/check_default_language()
	set69ame = "Check Default Language"
	set category = "IC"

	if(default_language)
		to_chat(src, SPAN_NOTICE("You are currently speaking 69default_language69 by default."))
	else
		to_chat(src, SPAN_NOTICE("Your current default language is your species or69ob type default."))

/mob/living/proc/set_default_language(var/langname)
	var/datum/language/L
	//Support for passing a datum directly, or the69ame of a language to go fetch.69ery flexible proc
	if (istype(langname, /datum/language))
		L = langname
	else
		L = all_languages69langname69
	languages |= L
	default_language = L