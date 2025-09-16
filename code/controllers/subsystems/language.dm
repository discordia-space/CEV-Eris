SUBSYSTEM_DEF(language)
	name = "Language"
	init_order = INIT_ORDER_LANGUAGE
	flags = SS_NO_FIRE

/datum/controller/subsystem/language/Initialize()
	//Languages and species.
	var/paths = subtypesof(/datum/language)
	for(var/T in paths)
		var/datum/language/L = new T
		GLOB.all_languages[L.name] = L

	for (var/language_name in GLOB.all_languages)
		var/datum/language/L = GLOB.all_languages[language_name]
		if(!(L.flags & NONGLOBAL))
			GLOB.language_keys[lowertext(L.key)] = L
			GLOB.language_types_by_name[initial(L.name)] = L.type

	. = ..()
