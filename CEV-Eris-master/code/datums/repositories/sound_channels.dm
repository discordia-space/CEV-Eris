GLOBAL_DATUM_INIT(sound_channels, /repository/sound_channels, new)
GLOBAL_VAR_INIT(lobby_sound_channel, GLOB.sound_channels.request("LOBBY"))
GLOBAL_VAR_INIT(vote_sound_channel, GLOB.sound_channels.request("VOTE"))
GLOBAL_VAR_INIT(ambience_sound_channel, GLOB.sound_channels.request("AMBIENCE"))
GLOBAL_VAR_INIT(admin_sound_channel, GLOB.sound_channels.request("ADMIN_FUN"))
GLOBAL_VAR_INIT(mp3_sound_channel, GLOB.sound_channels.request("MP3"))

/repository/sound_channels
	var/datum/stack/available_channels
	var/list/keys_by_channel
	var/list/channels_by_key
	var/channel_ceiling = 1024

/repository/sound_channels/New()
	..()
	available_channels = new()

/repository/sound_channels/proc/request(var/key)
	if(!key)
		CRASH("Invalid key given.")
	var/channel = available_channels.pop()
	if(!channel)
		if(channel_ceiling > 0)
			channel = channel_ceiling--
		else
			CRASH("Unable to supply sound channel for [key].")
	LAZYSET(keys_by_channel, "[channel]", key)
	LAZYSET(channels_by_key, "[key]", channel)
	return channel

/repository/sound_channels/proc/release(var/channel)
	var/key = LAZYACCESS(keys_by_channel, "[channel]")
	if(!key)
		CRASH("Invalid channel given.")
	LAZYREMOVE(keys_by_channel, "[channel]")
	LAZYREMOVE(channels_by_key, "[key]")
	available_channels.push(channel)

/repository/sound_channels/proc/release_by_key(var/key)
	var/channel = LAZYACCESS(channels_by_key, "[key]")
	if(!channel)
		CRASH("Invalid key given.")
	LAZYREMOVE(keys_by_channel, "[channel]")
	LAZYREMOVE(channels_by_key, "[key]")
	available_channels.push(channel)

/repository/sound_channels/proc/get_by_key(var/key)
	var/channel = LAZYACCESS(channels_by_key, "[key]")
	return channel
