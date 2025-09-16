// Hello! Are you looking to add a new lobby screen?
// Refer to screens/_template.dm for a template.


// see /datum/interface/new_player/buildUI()
// NOTES:
// music files should be in ogg extention

/hook/startup/proc/initLobbyScreen()
	var/list/variations = subtypesof(/datum/lobbyscreen) - /datum/lobbyscreen/tektober
	var/datum/lobbyscreen/LS = pick(variations)
	GLOB.lobbyScreen = new LS()
	return 1

/datum/lobbyscreen
	var/image_file
	// Name of the artist who made this lobby screen
	var/art_artist_name
	// A link to the artists social media
	var/art_artist_link
	// insert songs in this list, not into var/musicTrack
	var/list/possibleMusic = list()
	// this var exist so all players will hear one song
	var/musicTrack

/datum/lobbyscreen/New()

	if (!art_artist_name)
		log_runtime("Lobbyscreen [src.type] is missing an art artist name")
	if (!art_artist_link)
		log_runtime("Lobbyscreen [src.type] is missing an art artist link")
	if (!length(possibleMusic))
		log_runtime("Lobbyscreen [src.type] has no music tracks")
	else
		musicTrack = pick(possibleMusic)

	if (!image_file)
		log_runtime("Lobbyscreen [src.type] has no image file.")
	return ..()

/datum/lobbyscreen/proc/get_info_list()
	return list(
		art_artist_name,
		art_artist_link,
	)

/datum/lobbyscreen/proc/play_music(client/C)
	if(!musicTrack)
		return
	if(C.get_preference_value(/datum/client_preference/play_lobby_music) == GLOB.PREF_YES)
		sound_to(C, sound(musicTrack, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))

/datum/lobbyscreen/proc/stop_music(client/C)
	if(!musicTrack)
		return
	sound_to(C, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))


/datum/lobbyscreen/proc/show_titlescreen(client/C)
	winset(C, "mapwindow.lobbybrowser", "is-disabled=false;is-visible=true")
	C << browse(image_file, "file=titlescreen.png;display=0")
	// var/ourfile = file('html/lobby_titlescreen.html')
	// ourfile = replacetext(ourfile, "REFGOESHERE", "\ref[src]")
	C << browse(file('html/lobby_titlescreen.html'), "window=lobbybrowser")


/datum/lobbyscreen/proc/hide_titlescreen(client/C)
	if(C.mob) // Check if the client is still connected to something
		// Hide title screen, allowing player to see the map
		winset(C, "mapwindow.lobbybrowser", "is-disabled=true;is-visible=false")

/client/Topic(href, list/href_list)
	. = ..()
	if (.)
		return

	if (href_list["send_info"])
		src << output(list2params(GLOB.lobbyScreen.get_info_list()), "lobbybrowser:set_info")
