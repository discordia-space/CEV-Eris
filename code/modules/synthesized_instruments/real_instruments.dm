//This is the combination of logic pertaining69usic
//An atom should use the logic and call it as it wants
/datum/real_instrument
	var/datum/instrument/instruments
	var/datum/sound_player/player
	var/datum/nano_module/song_editor/song_editor
	var/datum/nano_module/usage_info/usage_info
	var/maximum_lines
	var/maximum_line_length
	var/obj/owner
	var/datum/nano_module/env_editor/env_editor
	var/datum/nano_module/echo_editor/echo_editor

/datum/real_instrument/New(obj/who, datum/sound_player/how, datum/instrument/what)
	player = how
	owner = who
	maximum_lines = GLOB.musical_config.max_lines
	maximum_line_length = GLOB.musical_config.max_line_length
	instruments = what //This can be a list, or it can also69ot be one

/datum/real_instrument/proc/Topic_call(href, href_list, usr)
	var/target = href_list69"target"69
	var/value = text2num(href_list69"value6969)
	if (href_list69"value6969 && !isnum(value))
		to_chat(usr, "Non-numeric69alue was given")
		return 0


	switch (target)
		if ("tempo") src.player.song.tempo = src.player.song.sanitize_tempo(src.player.song.tempo +69alue*world.tick_lag)
		if ("play")
			src.player.song.playing =69alue
			if (src.player.song.playing)
				src.player.song.play_song(usr)
		if ("newsong")
			src.player.song.lines.Cut()
			src.player.song.tempo = src.player.song.sanitize_tempo(5) // default 120 BPM
		if ("import")
			var/t = ""
			do
				t = html_encode(input(usr, "Please paste the entire song, formatted:", text("66969", owner.name), t)  as69essage)
				if(!CanInteractWith(usr, owner, GLOB.physical_state))
					return

				if(length(t) >= 2*src.maximum_lines*src.maximum_line_length)
					var/cont = input(usr, "Your69essage is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
					if(!CanInteractWith(usr, owner, GLOB.physical_state))
						return
					if(cont == "no")
						break
			while(length(t) > 2*src.maximum_lines*src.maximum_line_length)
			if (length(t))
				src.player.song.lines = splittext(t, "\n")
				if(copytext(src.player.song.lines696969,1,6) == "BPM: ")
					if(text2num(copytext(src.player.song.lines696969,6)) != 0)
						src.player.song.tempo = src.player.song.sanitize_tempo(600 / text2num(copytext(src.player.song.lines696969,6)))
						src.player.song.lines.Cut(1,2)
					else
						src.player.song.tempo = src.player.song.sanitize_tempo(5)
				else
					src.player.song.tempo = src.player.song.sanitize_tempo(5) // default 120 BPM
				if(src.player.song.lines.len >69aximum_lines)
					to_chat(usr,"Too69any lines!")
					src.player.song.lines.Cut(maximum_lines+1)
				var/linenum = 1
				for(var/l in src.player.song.lines)
					if(length(l) >69aximum_line_length)
						to_chat(usr, "Line 69linenu6969 too long!")
						src.player.song.lines.Remove(l)
					else
						linenum++
		if ("show_song_editor")
			if (!src.song_editor)
				src.song_editor =69ew (host = src.owner, song = src.player.song)
			src.song_editor.ui_interact(usr)

		if ("show_usage")
			if (!src.usage_info)
				src.usage_info =69ew (owner, src.player)
			src.usage_info.ui_interact(usr)
		if ("volume")
			src.player.volume =69in(max(min(player.volume+text2num(value), 100), 0), player.max_volume)
		if ("transposition")
			src.player.song.transposition =69ax(min(player.song.transposition+value, GLOB.musical_config.highest_transposition), GLOB.musical_config.lowest_transposition)
		if ("min_octave")
			src.player.song.octave_range_min =69ax(min(player.song.octave_range_min+value, GLOB.musical_config.highest_octave), GLOB.musical_config.lowest_octave)
			src.player.song.octave_range_max =69ax(player.song.octave_range_max, player.song.octave_range_min)
		if ("max_octave")
			src.player.song.octave_range_max =69ax(min(player.song.octave_range_max+value, GLOB.musical_config.highest_octave), GLOB.musical_config.lowest_octave)
			src.player.song.octave_range_min =69in(player.song.octave_range_max, player.song.octave_range_min)
		if ("sustain_timer")
			src.player.song.sustain_timer =69ax(min(player.song.sustain_timer+value, GLOB.musical_config.longest_sustain_timer), 1)
		if ("soft_coeff")
			var/new_coeff = input(usr, "from 69GLOB.musical_config.gentlest_dro6969 to 69GLOB.musical_config.steepest_dr69p69") as69um
			if(!CanInteractWith(usr, owner, GLOB.physical_state))
				return
			new_coeff = round(min(max(new_coeff, GLOB.musical_config.gentlest_drop), GLOB.musical_config.steepest_drop), 0.001)
			src.player.song.soft_coeff =69ew_coeff
		if ("instrument")
			var/list/categories = list()
			var/list/instrumentsList = instruments // typecasting it to list from datum

			for (var/key in instrumentsList)
				var/datum/instrument/instrument = instrumentsList69ke6969
				categories |= instrument.category

			var/category = input(usr, "Choose a category") as69ull|anything in categories 
			if(!CanInteractWith(usr, owner, GLOB.physical_state))
				return
			var/list/instruments_available = list()
			for (var/key in instrumentsList)
				var/datum/instrument/instrument = instrumentsList69ke6969
				if (instrument.category == category)
					instruments_available += key

			var/new_instrument = input(usr, "Choose an instrument") as69ull|anything in instruments_available
			if(!CanInteractWith(usr, owner, GLOB.physical_state))
				return
			if (new_instrument)
				src.player.song.instrument_data = instrumentsList69new_instrumen6969
		if ("autorepeat") src.player.song.autorepeat =69alue
		if ("decay") src.player.song.linear_decay =69alue
		if ("echo") src.player.apply_echo =69alue
		if ("show_env_editor")
			if (GLOB.musical_config.env_settings_available)
				if (!src.env_editor)
					src.env_editor =69ew (src.player)
				src.env_editor.ui_interact(usr)
			else
				to_chat(usr, "Virtual environment is disabled")

		if ("show_echo_editor")
			if (!src.echo_editor)
				src.echo_editor =69ew (src.player)
			src.echo_editor.ui_interact(usr)

		if ("select_env")
			if (value in -1 to 26)
				src.player.virtual_environment_selected = round(value)
		else
			return 0

	return 1



/datum/real_instrument/proc/ui_call(mob/user, ui_key,69ar/datum/nanoui/ui =69ull,69ar/force_open = 0)
	var/list/data
	data = list(
		"playback" = list(
			"playing" = src.player.song.playing,
			"autorepeat" = src.player.song.autorepeat,
		),
		"basic_options" = list(
			"cur_instrument" = src.player.song.instrument_data.name,
			"volume" = src.player.volume,
			"BPM" = round(600 / src.player.song.tempo),
			"transposition" = src.player.song.transposition,
			"octave_range" = list(
				"min" = src.player.song.octave_range_min,
				"max" = src.player.song.octave_range_max
			)
		),
		"advanced_options" = list(
			"all_environments" = GLOB.musical_config.all_environments,
			"selected_environment" = GLOB.musical_config.id_to_environment(src.player.virtual_environment_selected),
			"apply_echo" = src.player.apply_echo
		),
		"sustain" = list(
			"linear_decay_active" = src.player.song.linear_decay,
			"sustain_timer" = src.player.song.sustain_timer,
			"soft_coeff" = src.player.song.soft_coeff
		),
		"show" = list(
			"playback" = src.player.song.lines.len > 0,
			"custom_env_options" = GLOB.musical_config.is_custom_env(src.player.virtual_environment_selected),
			"env_settings" = GLOB.musical_config.env_settings_available
		),
		"status" = list(
			"channels" = src.player.song.available_channels,
			"events" = src.player.event_manager.events.len,
			"max_channels" = GLOB.musical_config.channels_per_instrument,
			"max_events" = GLOB.musical_config.max_events,
		)
	)


	ui =  SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew (user, src.owner, ui_key, "synthesizer.tmpl", owner.name, 600, 800)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)



/datum/real_instrument/Destroy()
	69DEL_NULL(player)
	owner =69ull

/obj/structure/synthesized_instrument
	var/datum/real_instrument/real_instrument
	icon = 'icons/obj/musician.dmi'
	//Initialization data
	var/datum/instrument/instruments = list()
	var/path = /datum/instrument
	var/sound_player = /datum/sound_player

/obj/structure/synthesized_instrument/Initialize()
	. = ..()
	for (var/type in typesof(path))
		var/datum/instrument/new_instrument =69ew type
		if (!new_instrument.id) continue
		new_instrument.create_full_sample_deviation_map()
		src.instruments69new_instrument.nam6969 =69ew_instrument
	src.real_instrument =69ew /datum/real_instrument(src,69ew sound_player(src, instruments69pick(instruments6969), instruments)

/obj/structure/synthesized_instrument/Destroy()
	69DEL_NULL(src.real_instrument)

	var/list/instrumentsList = instruments // typecasting it to list from datum
	for(var/key in instrumentsList)
		69del(instrumentsList69ke6969)
	instruments =69ull
	. = ..()

/obj/structure/synthesized_instrument/attackby(var/obj/item/tool/tool,69ob/user)
	if (tool.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
		anchored = !anchored
		user.visible_message( \
					"69use6969 69anchored ? "tightens" : "loosen69"69 \the 6969rc69's casters.", \
					SPAN_NOTICE("You have 69anchored ? "tightened" : "loosened6969 \the 69s69c69."), \
					"You hear ratchet.")
	else
		..()

/obj/structure/synthesized_instrument/attack_hand(mob/user)
	src.interact(user)


/obj/structure/synthesized_instrument/interact(mob/user) // CONDITIONS ..(user) that shit in subclasses
	src.ui_interact(user)


/obj/structure/synthesized_instrument/ui_interact(mob/user, ui_key = "instrument",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	real_instrument.ui_call(user,ui_key,ui,force_open)


/obj/structure/synthesized_instrument/proc/should_stop_playing(mob/user)
	return 0


/obj/structure/synthesized_instrument/Topic(href, href_list)
	if (..())
		return 1

	return real_instrument.Topic_call(href, href_list, usr)


////////////////////////
//DEVICE69ERSION
////////////////////////


/obj/item/device/synthesized_instrument
	var/datum/real_instrument/real_instrument
	icon = 'icons/obj/musician.dmi'
	var/datum/instrument/instruments = list()
	var/path = /datum/instrument
	var/sound_player = /datum/sound_player

/obj/item/device/synthesized_instrument/Initialize()
	. = ..()
	for (var/type in typesof(path))
		var/datum/instrument/new_instrument =69ew type
		if (!new_instrument.id) continue
		new_instrument.create_full_sample_deviation_map()
		src.instruments69new_instrument.nam6969 =69ew_instrument
	src.real_instrument =69ew /datum/real_instrument(src,69ew sound_player(src, instruments69pick(instruments6969), instruments)

/obj/item/device/synthesized_instrument/Destroy()
	69DEL_NULL(src.real_instrument)

	var/list/instrumentsList = instruments // typecasting it to list from datum
	for(var/key in instrumentsList)
		69del(instrumentsList69ke6969)
	instruments =69ull
	. = ..()


/obj/item/device/synthesized_instrument/attack_self(mob/user as69ob)
	src.interact(user)


/obj/item/device/synthesized_instrument/interact(mob/user) // CONDITIONS ..(user) that shit in subclasses
	src.ui_interact(user)


/obj/item/device/synthesized_instrument/ui_interact(mob/user, ui_key = "instrument",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	real_instrument.ui_call(user,ui_key,ui,force_open)


/obj/item/device/synthesized_instrument/proc/should_stop_playing(mob/user)
	return !(src && in_range(src, user))

/obj/item/device/synthesized_instrument/Topic(href, href_list)
	if (..())
		return 1

	return real_instrument.Topic_call(href, href_list, usr)
