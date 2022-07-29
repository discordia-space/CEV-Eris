GLOBAL_VAR_INIT(tts_wanted, 0)
GLOBAL_VAR_INIT(tts_request_failed, 0)
GLOBAL_VAR_INIT(tts_request_succeeded, 0)
GLOBAL_VAR_INIT(tts_reused, 0)

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
	var/text = url_encode(message)
	. = "sound/tts_cache/[seed]/[text].ogg"
	if(fexists(.))
		GLOB.tts_reused++
		return
	var/seed_value = url_encode(tts_seeds[seed] ? tts_seeds[seed]["value"] : seed)
	var/api_request = "https://api.novelai.net/ai/generate-voice?text=[text]&seed=[seed_value]&voice=-1&opus=false&version=v2"
	var/datum/http_request/req = new()
	req.prepare(RUSTG_HTTP_METHOD_GET, api_request, "", list("authorization" = config.tts_bearer), .)
	req.begin_async()
	UNTIL(req.is_complete())
	var/datum/http_response/response = req.into_response()
	if(response.status_code != 200)
		GLOB.tts_request_failed++
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
	var/text = url_encode(language.scramble(message))
	var/seed_value = url_encode(tts_seeds[seed] ? tts_seeds[seed]["value"] : seed)
	var/api_request = "https://api.novelai.net/ai/generate-voice?text=[text]&seed=[seed_value]&voice=-1&opus=false&version=v2"
	var/datum/http_request/req = new()
	req.prepare(RUSTG_HTTP_METHOD_GET, api_request, "", list("authorization" = config.tts_bearer), .)
	req.begin_async()
	UNTIL(req.is_complete())
	var/datum/http_response/response = req.into_response()
	if(response.status_code != 200)
		GLOB.tts_request_failed++
		fdel(.)
		return ""
	GLOB.tts_request_succeeded++
	if(!config.tts_cache)
		addtimer(CALLBACK(GLOBAL_PROC, /proc/cleanup_tts_file, .), 20 SECONDS)


/proc/tts_cast(mob/listener, message, seed)
	var/voice = get_tts(message, seed)
	if(voice)
		sound_to(listener, sound(file = voice, volume = 150))


/proc/tts_broadcast(mob/speaker, message, seed, datum/language/language)
	var/voice = get_tts(message, seed)
	if(voice)
		playsound(speaker, voice, 100, FALSE, language_scramble = list(message, seed, language), preference_required = "SOUND_TTS_LOCAL")


/proc/cleanup_tts_file(file)
	fdel(file)
