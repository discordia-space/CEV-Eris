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

/music_track/proc/play_to(var/listener)
	to_chat(listener, "<span class='good'>Now Playing:</span>")
	to_chat(listener, "<span class='good'>69title6969artist ? " by 69artist69" : ""6969album ? " (69album69)" : ""69</span>")
	if(url)
		to_chat(listener, url)

	to_chat(listener, "<span class='good'>Licence: <a href='69licence.url69'>69licence.name69</a></span>")
	sound_to(listener, sound(song, repeat = 1, wait = 0,69olume =69olume, channel = GLOB.lobby_sound_channel))

