/datum/preferences
	var/media_volume = 1
	var/media_player = 2	// 0 =69LC, 1 = WMP, 2 = HTML5, 3+ = unassigned

/datum/category_item/player_setup_item/player_global/media
	name = "Media"
	sort_order = 6

/datum/category_item/player_setup_item/player_global/media/load_preferences(var/savefile/S)
	S69"media_volume"69	>> pref.media_volume
	S69"media_player"69	>> pref.media_player

/datum/category_item/player_setup_item/player_global/media/save_preferences(var/savefile/S)
	S69"media_volume"69	<< pref.media_volume
	S69"media_player"69	<< pref.media_player

/datum/category_item/player_setup_item/player_global/media/sanitize_preferences()
	pref.media_volume = isnum(pref.media_volume) ? CLAMP(pref.media_volume, 0, 1) : initial(pref.media_volume)
	pref.media_player = sanitize_inlist(pref.media_player, list(0, 1, 2), initial(pref.media_player))

/datum/category_item/player_setup_item/player_global/media/content(var/mob/user)
	. += "<b>Jukebox69olume:</b>"
	. += "<a href='?src=\ref69src69;change_media_volume=1'><b>69round(pref.media_volume * 100)69%</b></a><br>"
	. += "<b>Media Player Type:</b> Depending on you operating system, one of these69ight work better. "
	. += "Use HTML5 if it works for you. If neither HTML5 nor WMP work, you'll have to fall back to using69LC, "
	. += "but this requires you have the69LC client installed on your computer."
	. += "Try the others if you want but you'll probably just get no69usic.<br>"
	. += (pref.media_player == 2) ? "<span class='linkOn'><b>HTML5</b></span> " : "<a href='?src=\ref69src69;set_media_player=2'>HTML5</a> "
	. += (pref.media_player == 1) ? "<span class='linkOn'><b>WMP</b></span> " : "<a href='?src=\ref69src69;set_media_player=1'>WMP</a> "
	. += (pref.media_player == 0) ? "<span class='linkOn'><b>VLC</b></span> " : "<a href='?src=\ref69src69;set_media_player=0'>VLC</a> "
	. += "<br>"

/datum/category_item/player_setup_item/player_global/media/OnTopic(var/href,69ar/list/href_list,69ar/mob/user)
	if(href_list69"change_media_volume"69)
		if(CanUseTopic(user))
			var/value = input("Choose your Jukebox69olume (0-100%)", "Jukebox69olume", round(pref.media_volume * 100))
			if(isnum(value))
				value = CLAMP(value, 0, 100)
				pref.media_volume =69alue/100.0
				if(user.client && user.client.media)
					user.client.media.update_volume(pref.media_volume)
			return TOPIC_REFRESH
	else if(href_list69"set_media_player"69)
		if(CanUseTopic(user))
			var/newval = sanitize_inlist(text2num(href_list69"set_media_player"69), list(0, 1, 2), pref.media_player)
			if(newval != pref.media_player)
				pref.media_player = newval
				if(user.client && user.client.media)
					user.client.media.open()
					spawn(10)
						user.update_music()
			return TOPIC_REFRESH
	return ..()

