GLOBAL_VAR_INIT(tts_wanted, 0)
GLOBAL_VAR_INIT(tts_request_failed, 0)
GLOBAL_VAR_INIT(tts_request_succeeded, 0)
GLOBAL_VAR_INIT(tts_reused, 0)

GLOBAL_LIST_EMPTY(tts_errors)
GLOBAL_VAR_INIT(tts_error_raw, "")


var/list/tts_seeds = list()

/proc/init_tts_directories()
	if(!fexists("config/tts_seeds.txt"))
		return

	for(var/i in file2list("config/tts_seeds.txt"))
		if(!LAZYLEN(i) || (copytext(i, 1, 2) == "#"))
			continue

		var/list/line = splittext_char(i, "=")
		if(!LAZYLEN(line))
			continue

		var/seed_name = line[1]
		var/seed_value = line[2]
		var/seed_category = line[3]
		var/seed_gender_restriction = line[4]

		tts_seeds += seed_name
		tts_seeds[seed_name] = list("value" = seed_value, "category" = seed_category, "gender" = seed_gender_restriction)

		call(RUST_G, "file_write")("[seed_value]", "sound/tts_cache/[seed_name]/seed.txt")
		call(RUST_G, "file_write")("[seed_value]", "sound/tts_scrambled/[seed_name]/seed.txt")


/proc/get_tts(message, seed = TTS_SEED_DEFAULT_MALE)
	GLOB.tts_wanted++
	var/text = rustg_url_encode(sanitize_tts_input(message))
	. = "sound/tts_cache/[seed]/[text].ogg"
	if(fexists(.))
		GLOB.tts_reused++
		return
	var/seed_value = rustg_url_encode(tts_seeds[seed] ? tts_seeds[seed]["value"] : seed)
	var/api_request = "https://api.novelai.net/ai/generate-voice?text=[text]&seed=[seed_value]&voice=-1&opus=false&version=v2"
	var/datum/http_request/req = new()
	req.prepare(RUSTG_HTTP_METHOD_GET, api_request, "", list("authorization" = config.tts_bearer), .)
	req.begin_async()
	UNTIL(req.is_complete())
	var/datum/http_response/response = req.into_response()
	if(response.status_code != 200)
		GLOB.tts_request_failed++
		if(response.status_code)
			if(GLOB.tts_errors["[response.status_code]"])
				GLOB.tts_errors["[response.status_code]"]++
			else
				GLOB.tts_errors += "[response.status_code]"
				GLOB.tts_errors["[response.status_code]"] = 1
		GLOB.tts_error_raw = req._raw_response
		fdel(.)
		return null
	GLOB.tts_request_succeeded++
	if(!config.tts_cache)
		addtimer(CALLBACK(GLOBAL_PROC, /proc/cleanup_tts_file, .), 20 SECONDS)


/proc/get_tts_scrambled(message, seed = TTS_SEED_DEFAULT_MALE, datum/language/language)
	GLOB.tts_wanted++
	var/length = "short"
	switch(LAZYLEN(message))
		if(15 to 40)
			length = "medium"
		if(40 to 100)
			length = "long"
		if(100 to INFINITY)
			length = "american_constitution"

	. = "sound/tts_scrambled/[seed]/[language.shorthand]_[length]_[rand(5)].ogg"
	if(fexists(.))
		GLOB.tts_reused++
		return
	var/text = rustg_url_encode(sanitize_tts_input(language.scramble(message)))
	var/seed_value = rustg_url_encode(tts_seeds[seed] ? tts_seeds[seed]["value"] : seed)
	var/api_request = "https://api.novelai.net/ai/generate-voice?text=[text]&seed=[seed_value]&voice=-1&opus=false&version=v2"
	var/datum/http_request/req = new()
	req.prepare(RUSTG_HTTP_METHOD_GET, api_request, "", list("authorization" = config.tts_bearer), .)
	req.begin_async()
	UNTIL(req.is_complete())
	var/datum/http_response/response = req.into_response()
	if(response.status_code != 200)
		GLOB.tts_request_failed++
		if(response.status_code)
			if(GLOB.tts_errors["[response.status_code]"])
				GLOB.tts_errors["[response.status_code]"]++
			else
				GLOB.tts_errors += "[response.status_code]"
				GLOB.tts_errors["[response.status_code]"] = 1
		GLOB.tts_error_raw = req._raw_response
		fdel(.)
		return ""
	GLOB.tts_request_succeeded++
	if(!config.tts_cache)
		addtimer(CALLBACK(GLOBAL_PROC, /proc/cleanup_tts_file, .), 20 SECONDS)


/proc/tts_cast(mob/listener, message, seed)
	var/voice = get_tts(message, seed)
	if(voice)
		playsound_tts(null, list(listener), voice, null, null, TRUE)


/proc/tts_broadcast(mob/speaker, message, seed, datum/language/language)
	var/voice = get_tts(message, seed)
	var/voice_scrambled
	if(voice)
		if(language)
			voice_scrambled = get_tts_scrambled(message, seed, language)
		playsound_tts(speaker, null, voice, voice_scrambled, language, TRUE)


/proc/cleanup_tts_file(file)
	fdel(file)


/proc/sanitize_tts_input(message)
	// This intended to remove patters like </span> and symbols that
	// BYOND will turn into complete mess on url encoding
	// E.g. turning ' into %26%2339%3B, on which tts service will choke
	// Not even attempting to player-proof, they will always find a way

	var/list/output = new

	var/skipping_span
	var/listen_for_character
	var/character_sequence_end

	var/message_byte_length = length(message)
	var/message_symbol_length = length_char(message)
	var/ascii_overdose = (message_byte_length != message_symbol_length) // Have to use slower procs in that case

	for(var/i in 1 to (ascii_overdose ? message_symbol_length : message_byte_length))
		var/character = (ascii_overdose ? copytext_char(message, i, i+1) : copytext(message, i, i+1))
		// Skipping multiple characters, could be BYOND's "text entity" or <span>
		if(character_sequence_end)
			listen_for_character = null
			if(character == character_sequence_end)
				if(skipping_span)
					if((ascii_overdose ? copytext_char(message, i+1, i+2) : copytext(message, i+1, i+2)) == "g") // ">" symbol/entity, aka "&gt;"
						skipping_span = FALSE
						character_sequence_end = ";"
				else
					character_sequence_end = null
		else
			switch(character)
				if("'", "`", "\"", "", "-", "~", ":")
					continue
				if("&")
					if(findtext(message, ";", i, i+5)) // If it is an "entity", not a standalone symbol
						var/next_character = copytext(message, i+1, i+2)
						if(next_character)
							if(next_character == "l") // "<" symbol/entity, aka "&lt;"
								skipping_span = TRUE
								character_sequence_end = "&"
								continue
						character_sequence_end = ";"
					else
						output += character
				if("#")
					character_sequence_end = ";"
				if("<")
					character_sequence_end = ">"

				// NT to NeoTheology
				if("N")
					listen_for_character = "T"
					output += character
				if("T")
					output.Add((character == listen_for_character) ? list("e","o", "T","h","e","o","l","o","g","y") : character)

				// IH to IronHammer
				if("I")
					listen_for_character = "H"
					output += character
				if("H")
					output.Add((character == listen_for_character) ? list("r","o","n", "H","a","m","m","e","r") : character)

				// ML to MoebiusLaboratories
				if("M")
					listen_for_character = "L"
					output += character
				if("L")
					output.Add((character == listen_for_character) ? list("o","e","b","i","u","s", "L","a","b","o","r","a","t","o","r","i","e","s") : character)

				else
					listen_for_character = null
					output += character

	. = JOINTEXT(output)
