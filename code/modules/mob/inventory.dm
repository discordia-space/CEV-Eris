//////
//Some inventory sounds.
//occurs when you click and put up or take off something from you (any UI slot acceptable)
/////
/mob/proc/play_short()
	var/list/sounds = list(
		'sound/misc/inventory/short_1.ogg',
		'sound/misc/inventory/short_2.ogg',
		'sound/misc/inventory/short_3.ogg'
	)

	var/picked_sound = pick(sounds)

	playsound(src, picked_sound, 100, 1, 1)

/mob/proc/play_long()
	var/list/sounds = list(
		'sound/misc/inventory/long_1.ogg',
		'sound/misc/inventory/long_2.ogg',
		'sound/misc/inventory/long_3.ogg'
	)

	var/picked_sound = pick(sounds)

	playsound(src, picked_sound, 100, 1, 1)