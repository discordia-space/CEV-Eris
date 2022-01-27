
/datum/sound_player
	//69irtual object
	// It's the one used to69odify shit
	var/range = 15
	var/volume = 30
	var/max_volume = 50
	var/falloff = 2
	var/apply_echo = 0
	var/virtual_environment_selected = 0
	var/env692369
	var/echo691869

	var/datum/synthesized_song/song
	var/datum/instrument/instrument
	var/obj/actual_instrument

	var/datum/musical_event_manager/event_manager =69ew

	var/datum/proximity_trigger/s69uare/proxy_listener
	var/list/datum/sound_token/instrument/tokens = list()
	var/list/seen_turfs

/datum/sound_player/New(datum/real_instrument/where, datum/instrument/what)
	src.song =69ew (src, what)
	src.actual_instrument = where
	src.echo = GLOB.musical_config.echo_default.Copy()
	src.env = GLOB.musical_config.env_default.Copy()
	src.proxy_listener =69ew(src.actual_instrument, /datum/sound_player/proc/on_turf_entered_relay, /datum/sound_player/proc/on_turfs_changed_relay, range, proc_owner = src)
	proxy_listener.register_turfs()

/datum/sound_player/Destroy()
	src.song.playing = 0
	src.actual_instrument =69ull
	src.instrument =69ull
	69DEL_NULL(song)
	69DEL_NULL(event_manager)
	69DEL_NULL(proxy_listener)
	seen_turfs.Cut()
	tokens.Cut()
	. = ..()

/datum/sound_player/proc/subscribe(var/datum/sound_token/instrument/newtoken)
	if(!istype(newtoken))
		CRASH("Non token type passed to subscribe function.")
	tokens +=69ewtoken

	//Tell it of what we saw prior to it spawning
	newtoken.locate_listeners(list(), seen_turfs.Copy())


/datum/sound_player/proc/unsubscribe(var/datum/sound_token/instrument/oldtoken)
	if(!istype(oldtoken))
		CRASH("Non token type passed to unsubscribe function.")
	tokens -= oldtoken

/datum/sound_player/proc/on_turf_entered_relay(var/atom/enteree)
	for(var/datum/sound_token/instrument/I in tokens)
		I.add_listener(enteree)

/datum/sound_player/proc/on_turfs_changed_relay(var/list/prior_turfs,69ar/list/current_turfs)
	seen_turfs = current_turfs
	for(var/datum/sound_token/instrument/I in tokens)
		I.locate_listeners(prior_turfs.Copy(), current_turfs.Copy())

/datum/sound_player/proc/apply_modifications(sound/what,69ote_num, which_line, which_note) // You don't69eed to override this
	what.volume =69olume
	what.falloff = falloff
	if (GLOB.musical_config.env_settings_available)
		what.environment = GLOB.musical_config.is_custom_env(src.virtual_environment_selected) ? src.env : src.virtual_environment_selected
	if (src.apply_echo)
		what.echo = src.echo
	return

/datum/sound_player/proc/should_stop_playing(mob/user)
	var/obj/structure/synthesized_instrument/S = actual_instrument
	var/obj/item/device/synthesized_instrument/D = actual_instrument
	if(istype(S))
		return S.should_stop_playing(user)
	if(istype(D))
		return D.should_stop_playing(user)

	return 1 //Well if you got this far you did something69ery wrong
