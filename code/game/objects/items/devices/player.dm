#define MP3_CHANNEL 4

/obj/item/device/player
	name = "Player"
	var/active = FALSE
	var/current_track = ""
	var/obj/item/holder = null
	var/list/songs = list(
		"Space Oddity" = 'sound/music/space_oddity.ogg',
		"Space Dwarfs" = 'sound/music/b12_combined_start.ogg',
		"Space Asshole" = 'sound/music/space_asshole.ogg',
		"HQ" = 'sound/music/deus_ex_unatco_nervous_testpilot_remix.ogg',
		"Faunts Das Malefitz" = 'sound/music/faunts-das_malefitz.ogg',
		"Neon Fever" = 'sound/music/i_am_waiting_for_you_last_summer_neon_fever.ogg',
		"My Beautiful Escape" = 'sound/music/nervous_testpilot _my_beautiful_escape.ogg',
		"Skytown" = 'sound/music/paradise_cracked_skytown.ogg',
		"Paradise Cracked" = 'sound/music/paradise_cracked_title03.ogg',
		"Irritations" = 'sound/music/tonspender_irritations.ogg',
	)

/obj/item/device/player/New(var/obj/item/holder)
	..()
	if(istype(holder))
		src.holder = holder

/obj/item/device/player/update_icon()
	holder.update_icon()

/obj/item/device/player/proc/stop(var/mob/affected)
	current_track = null
	update_icon()
	if(!affected)
		if(ismob(holder.loc))
			affected = holder.loc
		else
			return
	active = FALSE
	affected << sound(null, channel = MP3_CHANNEL)

/obj/item/device/player/proc/outofenergy()
	current_track = null
	update_icon()
	active = FALSE
	if(ishuman(holder.loc))
		var/mob/living/carbon/human/H = holder.loc
		H << sound(null, channel = MP3_CHANNEL)

/obj/item/device/player/proc/play()
	if(!current_track || !(current_track in songs))
		stop(usr)

	update_icon()
	if(ishuman(holder.loc))
		var/mob/living/carbon/human/H = holder.loc
		if(holder in list(H.l_ear, H.r_ear))
			H << sound(songs[current_track], channel = MP3_CHANNEL, volume=100)
			active = TRUE

/obj/item/device/player/proc/OpenInterface(mob/user as mob)

	var/dat = "MP3 player<BR><br>"

	for(var/song in songs)
		if(song == current_track)
			dat += "<a href='byond://?src=\ref[src];play=[song]'><b>[song]</b></a><br>"
		else
			dat += "<a href='byond://?src=\ref[src];play=[song]'>[song]</a><br>"
	dat += "<br><a href='byond://?src=\ref[src];stop=1'>Stop Music</a>"

	user << browse(dat, "window=mp3")
	onclose(user, "mp3")
	return

/obj/item/device/player/Topic(href, href_list)
	if(!holder in usr) return
	if(href_list["play"])
		current_track = href_list["play"]
		play()
	else if(href_list["stop"])
		stop(holder.loc)
	spawn OpenInterface(usr)

#undef MP3_CHANNEL
