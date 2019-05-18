// see /datum/interface/new_player/buildUI()
// NOTES:
// music files should be in ogg extention

/hook/startup/proc/initLobbyScreen()
	var/list/variations = subtypesof(/datum/lobbyscreen)
	var/datum/lobbyscreen/LS = pick(variations)
	GLOB.lobbyScreen = new LS()
	return 1

/datum/lobbyscreen
	var/imageFile = 'icons/misc/title.dmi'
	var/imageName = ""
	// insert songs in this list, not into var/musicTrack
	var/list/possibleMusic = list()
	// this var exist so all players will hear one song
	var/musicTrack

/datum/lobbyscreen/New()
	if(!possibleMusic.len || !imageName)
		crash_with("Login screen setup is wrong.")
	musicTrack = pick(possibleMusic)
	return ..()

/datum/lobbyscreen/spaceship
	imageName = "spaceship"
	possibleMusic = list(
		'sound/music/lobby/Duke_Gneiss-Bluespace.ogg',
		'sound/music/lobby/Duke_Gneiss-Exploring.ogg')

/datum/lobbyscreen/investigation
	imageName = "investigation"
	possibleMusic = list(
		'sound/music/lobby/Duke_Gneiss-The_Runner_in_motion.ogg',
		'sound/music/lobby/Duke_Gneiss-Metropolis.ogg')

/datum/lobbyscreen/eyeThingie
	imageName = "eye-thingie"
	possibleMusic = list(
		'sound/music/lobby/Duke_Gneiss-Downtown_2.ogg')

/datum/lobbyscreen/neotheology
	imageName = "neo-theology"
	possibleMusic = list(
		'sound/music/lobby/turu31333.ogg')

/datum/lobbyscreen/proc/playMusic(var/client/C)
	if(!musicTrack)
		return
	if(C.get_preference_value(/datum/client_preference/play_lobby_music) == GLOB.PREF_YES)
		sound_to(C, sound(musicTrack, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))

/datum/lobbyscreen/proc/stopMusic(var/client/C)
	if(!musicTrack)
		return
	sound_to(C, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))
