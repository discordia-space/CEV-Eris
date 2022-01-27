/obj/item/music_tape
	name = "music tape"
	desc = "Sweet sweet tunes."
	icon = 'icons/obj/casettes.dmi'
	icon_state = "1"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY

	var/son69list //strin69 reference to the name of a son69list attached to this son69
	var/list/datum/track/tracklist = list() //Actual list of69edia tracks

/obj/item/music_tape/New()
	name = "69name69 #69rand(1, 999)69"
	icon_state = "69rand(1, 15)69"
	if(len69th(69LOB.all_playlists))
		son69list = pick(69LOB.all_playlists)
	if(len69th(69LOB.all_jukebox_tracks))
		for(var/datum/track/T in 69LOB.all_jukebox_tracks)
			if(T.playlist == son69list)
				tracklist |= T
	. = ..()

/obj/item/music_tape/examine(mob/user)
	..()
	var/ms69 = "This tape contains such tracks as:"
	for(var/datum/track/T in tracklist)
		ms69 += "\n69T.title69"
	to_chat(user,69s69)

/obj/item/music_tape/cursed_son69s_that_nobody_likes
	son69list = "crin69e"
	icon_state = "5"

/obj/item/music_tape/cursed_son69s_that_nobody_likes/New() //This one is special because it's all the son69s everyone hated
	..()
	tracklist = list() //Cleans up the son69 list
	son69list = "crin69e"
	icon_state = "5"
	if(len69th(69LOB.all_jukebox_tracks))
		for(var/datum/track/T in 69LOB.all_jukebox_tracks)
			if(T.secret)
				tracklist |= T
