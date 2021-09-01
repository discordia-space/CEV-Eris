/obj/item/weapon/music_tape
	name = "music tape"
	desc = "Sweet sweet tunes."
	icon = 'icons/obj/casettes.dmi'
	icon_state = "1"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY

	var/songlist //string reference to the name of a songlist attached to this song
	var/list/datum/track/tracklist = list() //Actual list of media tracks

/obj/item/weapon/music_tape/New()
	for(var/datum/track/T in all_jukebox_tracks)
		if(T.playlist == songlist)
			tracklist |= T
	..()

/obj/item/weapon/music_tape/examine(mob/user)
	..()
	var/msg = "This tape contains such tracks as:"
	for(var/datum/track/T in tracklist)
		msg += "\n[T.title]"
	to_chat(user, msg)

/obj/item/weapon/music_tape/cursed_songs_that_nobody_likes
	songlist = "cringe"
	icon_state = "5"

/obj/item/weapon/music_tape/cursed_songs_that_nobody_likes/New() //This one is special because it's all the songs everyone hated
	for(var/datum/track/T in all_jukebox_tracks)
		if(T.secret)
			tracklist |= T

	..()

