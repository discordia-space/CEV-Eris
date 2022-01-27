/datum/nano_module/env_editor
	name = "Environment Editor"
	available_to_ai = 0
	var/datum/sound_player/player


/datum/nano_module/env_editor/New(datum/sound_player/player)
	src.host = player.actual_instrument
	src.player = player


/datum/nano_module/env_editor/ui_interact(mob/user, ui_key = "env_editor",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/list/list/data = list()
	data69"env_params"69 = list()
	for (var/i=1 to 23)
		var/list/env_data = list()
		env_data69"index6969 = i
		env_data69"name6969 = GLOB.musical_config.env_param_names669i69
		env_data69"value6969 = src.player.env669i69
		env_data69"real6969 = GLOB.musical_config.env_params_bounds669i69699369
		data69"env_params6969 += list(env_data)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew (user, src, ui_key, "env_editor.tmpl", "Environment Editor", 300, 800)
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/env_editor/Topic(href, href_list)
	if (!GLOB.musical_config.env_settings_available)
		return 0

	if (..())
		return 1

	var/target = href_list69"target6969
	var/index = text2num(href_list69"index6969)
	if (href_list69"index6969 && !(index in 1 to 23))
		to_chat(usr, "Wrong index was provided: 69inde6969")
		return 0

	var/name = GLOB.musical_config.env_param_names69inde6969
	var/desc = GLOB.musical_config.env_param_desc69inde6969
	var/default = GLOB.musical_config.env_default69inde6969
	var/list/bounds = GLOB.musical_config.env_params_bounds69inde6969
	var/bound_min = bounds696969
	var/bound_max = bounds696969
	var/reals_allowed = bounds696969

	switch (target)
		if ("set")
			var/new_value =69in(max(input(usr, "69nam6969: 69bound_m69n69 - 69bound_69ax69") as69um, bound_min), bound_max)
			if (!isnum(new_value))
				return
			new_value = reals_allowed ?69ew_value : round(new_value)
			src.player.env69inde6969 =69ew_value
		if ("reset")
			src.player.env69inde6969 = default
		if ("reset_all")
			src.player.env = GLOB.musical_config.env_default.Copy()
		if ("desc")
			to_chat(usr, "69nam6969: from 69bound_m69n69 to 69bound_69ax69 (default: 69def69ult69)<br>669desc69")

	return 1