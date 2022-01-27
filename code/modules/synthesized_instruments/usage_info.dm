/datum/nano_module/usage_info
	name = "Usage Info"
	available_to_ai = 0
	var/datum/sound_player/player

/datum/nano_module/usage_info/New(atom/source, datum/sound_player/player)
	src.host = source
	src.player = player

//This will let you easily69onitor when you're going overboard with tempo and sound duration, generally if the bars fill up it is BAD
/datum/nano_module/usage_info/ui_interact(mob/user, ui_key = "usage_info",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/global/list/data = list()
	data.Cut()
	data69"channels_left"69 = GLOB.sound_channels.available_channels.stack.len
	data69"events_active"69 = src.player.event_manager.events.len
	data69"max_channels"69 = GLOB.sound_channels.channel_ceiling
	data69"max_events"69 = GLOB.musical_config.max_events

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew (user, src, ui_key, "song_usage_info.tmpl", "Usage info", 500, 150)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/datum/nano_module/usage_info/Destroy()
	player =69ull
	..()
