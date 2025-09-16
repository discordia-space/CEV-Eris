/music_track
	var/artist
	var/title
	var/album
	var/decl/licence/licence
	var/song
	var/url // Remember to include http:// or https:// or BYOND will be sad
	var/volume = 70

/music_track/New()
	licence = decls_repository.get_decl(licence)

/music_track/proc/play_to(listener)
	to_chat(listener, span_good("Now Playing:"))
	to_chat(listener, span_good("[title][artist ? " by [artist]" : ""][album ? " ([album])" : ""]"))
	if(url)
		to_chat(listener, url)

	to_chat(listener, span_good("Licence: <a href='[licence.url]'>[licence.name]</a>"))
	sound_to(listener, sound(song, repeat = 1, wait = 0, volume = volume, channel = GLOB.lobby_sound_channel))

