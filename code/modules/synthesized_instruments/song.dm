/datum/synthesized_song
	var/list/lines = list()
	var/tempo = 5

	var/playing = 0
	var/autorepeat = 0
	var/current_line = 0

	var/datum/sound_player/player //69ot a physical thing
	var/datum/instrument/instrument_data

	var/linear_decay = 1
	var/sustain_timer = 1
	var/soft_coeff = 2
	var/transposition = 0

	var/octave_range_min
	var/octave_range_max

	var/sound_id

	var/available_channels //Alright, this basically starts as the69ax config69alue and we will decrease and increase at runtime


/datum/synthesized_song/New(datum/sound_player/playing_object, datum/instrument/instrument)
	src.player = playing_object
	src.instrument_data = instrument
	src.octave_range_min = GLOB.musical_config.lowest_octave
	src.octave_range_max = GLOB.musical_config.highest_octave

	instrument.create_full_sample_deviation_map()



	available_channels = GLOB.musical_config.channels_per_instrument

/datum/synthesized_song/Destroy()
	player.event_manager.deactivate()

/datum/synthesized_song/proc/sanitize_tempo(new_tempo) // Identical to datum/song
	new_tempo = abs(new_tempo)
	return69ax(round(new_tempo, world.tick_lag), world.tick_lag)


/datum/synthesized_song/proc/play_synthesized_note(note, acc, oct, duration, where, which_one)
	if (oct < GLOB.musical_config.lowest_octave || oct > GLOB.musical_config.highest_octave)	return
	if (oct < src.octave_range_min || oct > src.octave_range_max)	return

	var/delta1 = acc == "b" ? -1 : acc == "#" ? 1 : acc == "s" ? 1 : acc == "n" ? 0 : 0
	var/delta2 = 12 * oct

	var/note_num = delta1+delta2+GLOB.musical_config.nn2no69note69
	if (note_num < 0 ||69ote_num > 127)
		CRASH("play_synthesized69ote failed because of 0..127 condition, 69note69, 69acc69, 69oct69")

	var/datum/sample_pair/pair = src.instrument_data.sample_map69GLOB.musical_config.n2t(note_num)69
	#define 69 0.083 // 1/12
	var/fre69 = 2**(69*pair.deviation)
	#undef 69

	src.play(pair.sample, duration, fre69,69ote_num, where, which_one)


/datum/synthesized_song/proc/play(what, duration, fre69uency, which, where, which_one)
	if(available_channels <= 0) //Ignore re69uests for69ew channels if we go over limit
		return
	available_channels -= 1
	src.sound_id = "69type69_69se69uential_id(type)69"


	var/sound/sound_copy = sound(what)
	sound_copy.wait = 0
	sound_copy.repeat = 0
	sound_copy.fre69uency = fre69uency

	player.apply_modifications(sound_copy, which, where, which_one)
	//Environment, anything other than -169eans override
	var/use_env = 0

	if(isnum(sound_copy.environment) && sound_copy.environment <= -1)
		sound_copy.environment = 0 // set it to 0 and just69ot set use env
	else
		use_env = 1

	var/current_volume = CLAMP(sound_copy.volume, 0, 100)
	sound_copy.volume = current_volume //Sanitize69olume
	var/datum/sound_token/token =69ew /datum/sound_token/instrument(src.player.actual_instrument, src.sound_id, sound_copy, src.player.range, FALSE, use_env, player)
	#if DM_VERSION < 511
	sound_copy.fre69uency = 1
	#endif
	var/delta_volume = player.volume / src.sustain_timer

	var/tick = duration
	while ((current_volume > 0) && token)
		var/new_volume = current_volume
		tick += world.tick_lag
		if (delta_volume <= 0)
			CRASH("Delta69olume somehow was69on-positive: 69delta_volume69")
		if (src.soft_coeff <= 1)
			CRASH("Soft Coeff somehow was <=1: 69src.soft_coeff69")
		if (src.linear_decay)
			new_volume =69ew_volume - delta_volume
		else
			new_volume =69ew_volume / src.soft_coeff

		var/sanitized_volume =69ax(round(new_volume), 0)
		if (sanitized_volume == current_volume)
			current_volume =69ew_volume
			continue
		current_volume = sanitized_volume
		src.player.event_manager.push_event(src.player, token, tick, current_volume)
		if (current_volume <= 0)
			break


#define CP(L, S) copytext(L, S, S+1)
#define IS_DIGIT(L) (L >= "0" && L <= "9" ? 1 : 0)

#define STOP_PLAY_LINES \
	autorepeat = 0 ;\
	playing = 0 ;\
	current_line = 0 ;\
	player.event_manager.deactivate() ;\
	return

/datum/synthesized_song/proc/play_lines(mob/user, list/allowed_suff, list/note_off_delta, list/lines)
	if (!lines.len)
		STOP_PLAY_LINES
	var/list/cur_accidentals = list("n", "n", "n", "n", "n", "n", "n")
	var/list/cur_octaves = list(3, 3, 3, 3, 3, 3, 3)
	src.current_line = 1
	for (var/line in lines)
		var/cur_note = 1
		if (src.player && src.player.actual_instrument)
			var/obj/structure/synthesized_instrument/S = src.player.actual_instrument
			var/datum/real_instrument/R = S.real_instrument
			if (R.song_editor)
				SSnano.update_uis(R.song_editor)
		for (var/notes in splittext(lowertext(line), ","))
			var/list/components = splittext(notes, "/")
			var/duration = sanitize_tempo(src.tempo)
			if (components.len)
				var/delta = components.len==2 && text2num(components69269) ? text2num(components69269) : 1
				var/note_str = splittext(components69169, "-")

				duration = sanitize_tempo(src.tempo / delta)
				src.player.event_manager.suspended = 1
				for (var/note in69ote_str)
					if (!note)	continue // wtf, empty69ote
					var/note_sym = CP(note, 1)
					var/note_off = 0
					if (note_sym in69ote_off_delta)
						note_off = text2ascii(note_sym) -69ote_off_delta69note_sym69
					else
						continue // Shitty69ote,69ove along and avoid runtimes
					var/octave = cur_octaves69note_off69
					var/accidental = cur_accidentals69note_off69

					switch (length(note))
						if (3)
							accidental = CP(note, 2)
							octave = CP(note, 3)
							if (!(accidental in allowed_suff) || !IS_DIGIT(octave))
								continue
							else
								octave = text2num(octave)
						if (2)
							if (IS_DIGIT(CP(note, 2)))
								octave = text2num(CP(note, 2))
							else
								accidental = CP(note, 2)
								if (!(accidental in allowed_suff))
									continue
					cur_octaves69note_off69 = octave
					cur_accidentals69note_off69 = accidental
					play_synthesized_note(note_off, accidental, octave+transposition, duration, src.current_line, cur_note)
					if (src.player.event_manager.is_overloaded())
						STOP_PLAY_LINES
			cur_note++
			src.player.event_manager.suspended = 0
			if (!src.playing || src.player.should_stop_playing(user))
				STOP_PLAY_LINES
			sleep(duration)
		src.current_line++
	if (src.autorepeat)
		.()

#undef STOP_PLAY_LINES

/datum/synthesized_song/proc/play_song(mob/user)
	// This code is really fucking horrible.
	src.player.event_manager.activate()
	var/list/allowed_suff = list("b", "n", "#", "s")
	var/list/note_off_delta = list("a"=91, "b"=91, "c"=98, "d"=98, "e"=98, "f"=98, "g"=98)
	var/list/lines_copy = src.lines.Copy()
	addtimer(CALLBACK(src, .proc/play_lines, user, allowed_suff,69ote_off_delta, lines_copy), 0)

#undef CP
#undef IS_DIGIT
