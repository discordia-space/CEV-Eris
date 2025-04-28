/// Transforms the speech emphasis mods from [/atom/movable/proc/say_emphasis] into the appropriate HTML tags. Includes escaping.
#define ENCODE_HTML_EMPHASIS(input, char, html, varname) \
	var/static/regex/##varname = regex("(?<!\\\\)[char](.+?)(?<!\\\\)[char]", "g");\
	input = varname.Replace_char(input, "<[html]>$1</[html]>&#8203;") //zero-width space to force maptext to respect closing tags.

/// Scans the input sentence for speech emphasis modifiers, notably |italics|, +bold+, and _underline_ -mothblocks
/atom/movable/proc/say_emphasis(input)
	ENCODE_HTML_EMPHASIS(input, "\\|", "i", italics)
	ENCODE_HTML_EMPHASIS(input, "\\+", "b", bold)
	ENCODE_HTML_EMPHASIS(input, "_", "u", underline)
	ENCODE_HTML_EMPHASIS(input, "\\`", "font color= 'red'", redtext)
	var/static/regex/remove_escape_backlashes = regex("\\\\(_|\\+|\\|)", "g") // Removes backslashes used to escape text modification.
	input = remove_escape_backlashes.Replace_char(input, "$1")
	return input

#undef ENCODE_HTML_EMPHASIS

//VIRTUALSPEAKERS
/atom/movable/virtualspeaker
	var/job
	var/atom/movable/source
	var/obj/item/device/radio/radio

	var/realvoice

INITIALIZE_IMMEDIATE(/atom/movable/virtualspeaker)
/atom/movable/virtualspeaker/Initialize(mapload, atom/movable/M, _radio)
	. = ..()
	radio = _radio
	source = M
	if(istype(M))
		name = radio.anonymize ? "Unknown" : M.GetVoice()
		realvoice = name
		verb_say = M.verb_say
		verb_ask = M.verb_ask
		verb_exclaim = M.verb_exclaim
		verb_yell = M.verb_yell

	// The mob's job identity
	if(ishuman(M))
		// Humans use their job as seen on the crew manifest. This is so the AI
		// can know their job even if they don't carry an ID.
		var/record_rank = find_record(name, "rank")
		if(record_rank)
			job = record_rank
		else
			job = "Unknown"
	else if(iscarbon(M))  // Carbon nonhuman
		job = "No ID"
	else if(isAI(M))  // AI
		job = "AI"
	else if(isrobot(M))  // Cyborg
		var/mob/living/silicon/robot/B = M
		job = "[B.module.name] Cyborg"
	else if(ispAI(M))  // Personal AI (pAI)
		job = "pAI"
	else if(isobj(M))  // Cold, emotionless machines
		job = "Machine"
	else  // Unidentifiable mob
		job = "Unknown"

/atom/movable/virtualspeaker/GetJob()
	return job

/atom/movable/virtualspeaker/GetVoice(bool)
	if(bool && realvoice)
		return realvoice
	else
		return "[src]"

/atom/movable/virtualspeaker/GetSource()
	return source

/atom/movable/virtualspeaker/GetRadio()
	return radio

