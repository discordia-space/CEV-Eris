var/list/sounds_cache = list()

ADMIN_VERB_ADD(/client/proc/play_sound, R_FUN, FALSE)
/client/proc/play_sound(S as sound)
	set category = "Fun"
	set name = "Play Global Sound"
	if(!check_rights(R_FUN))
		return

	var/sound/uploaded_sound = sound(S, repeat = 0, wait = 1, channel = GLOB.admin_sound_channel)
	uploaded_sound.priority = 250

	sounds_cache += S

	if(alert("Do you ready?\nSong: 69S69\nNow you can also play this sound using \"Play Server Sound\".", "Confirmation request" ,"Play", "Cancel") == "Cancel")
		return

	log_admin("69key_name(src)69 played sound 69S69")
	message_admins("69key_name_admin(src)69 played sound 69S69", 1)
	for(var/mob/M in GLOB.player_list)
		if(M.get_preference_value(/datum/client_preference/play_admin_midis) == GLOB.PREF_YES)
			sound_to(M, sound(uploaded_sound, repeat = 0, wait = 0,69olume = 100, channel = GLOB.admin_sound_channel))



ADMIN_VERB_ADD(/client/proc/play_local_sound, R_FUN, FALSE)
/client/proc/play_local_sound(S as sound)
	set category = "Fun"
	set name = "Play Local Sound"
	if(!check_rights(R_FUN))
		return

	log_admin("69key_name(src)69 played a local sound 69S69")
	message_admins("69key_name_admin(src)69 played a local sound 69S69", 1)
	playsound(get_turf(src.mob), S, 50, 0, 0)


ADMIN_VERB_ADD(/client/proc/play_server_sound, R_FUN, FALSE)
/client/proc/play_server_sound()
	set category = "Fun"
	set name = "Play Server Sound"
	if(!check_rights(R_FUN))
		return

	var/list/sounds = file2list("sound/serversound_list.txt");
	sounds += "--CANCEL--"
	sounds += sounds_cache

	var/melody = input("Select a sound from the server to play", "Server sound list", "--CANCEL--") in sounds

	if(melody == "--CANCEL--")
		return

	play_sound(melody)

ADMIN_VERB_ADD(/client/proc/stop_sounds, R_ADMIN, FALSE)
/client/proc/stop_sounds()
	set category = "Debug"
	set name = "Stop All Playing Sounds"
	if(!src.holder)
		return
	log_admin("69key_name(src)69 stopped all currently playing sounds.")
	message_admins("69key_name_admin(src)69 stopped all currently playing sounds.")
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			sound_to(M, sound(null, repeat = 0, wait = 0,69olume = 100))

ADMIN_VERB_ADD(/client/proc/stop_sounds_admin, R_ADMIN, FALSE)
/client/proc/stop_sounds_admin() //Selectively shuts up bad admin played songs only without destroying every sound in the game.
	set category = "Debug"
	set name = "Stop Admin Sounds"
	if(!src.holder)
		return
	log_admin("69key_name(src)69 stopped all currently playing sounds.")
	message_admins("69key_name_admin(src)69 stopped all currently playing sounds.")
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			sound_to(M, sound(null, repeat = 0, wait = 0,69olume = 100, channel = GLOB.admin_sound_channel))

/client/verb/stop_client_sounds()
	set name = "Stop Sounds"
	set category = "OOC"
	set desc = "Stop Current Sounds"
	sound_to(src, sound(null, repeat = 0, wait = 0,69olume = 100))