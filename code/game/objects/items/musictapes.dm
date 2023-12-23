/obj/item/music_tape
	name = "music tape"
	desc = "Sweet sweet tunes."
	icon = 'icons/obj/casettes.dmi'
	icon_state = "1"
	item_state = "card-id"
	volumeClass = ITEM_SIZE_TINY

	var/songlist //string reference to the name of a songlist attached to this song
	var/list/datum/track/tracklist = list() //Actual list of media tracks

/obj/item/music_tape/New()
	name = "[name] #[rand(1, 999)]"
	icon_state = "[rand(1, 15)]"
	if(length(GLOB.all_playlists))
		songlist = pick(GLOB.all_playlists)
	if(length(GLOB.all_jukebox_tracks))
		for(var/datum/track/T in GLOB.all_jukebox_tracks)
			if(T.playlist == songlist)
				tracklist |= T
	. = ..()

/obj/item/music_tape/examine(mob/user)
	var/msg = "This tape contains such tracks as:"
	for(var/datum/track/T in tracklist)
		msg += "\n[T.title]"
	..(user, afterDesc = msg)

/obj/item/music_tape/cursed_songs_that_nobody_likes
	songlist = "cringe"
	icon_state = "5"

/obj/item/music_tape/cursed_songs_that_nobody_likes/New() //This one is special because it's all the songs everyone hated
	..()
	tracklist = list() //Cleans up the song list
	songlist = "cringe"
	icon_state = "5"
	if(length(GLOB.all_jukebox_tracks))
		for(var/datum/track/T in GLOB.all_jukebox_tracks)
			if(T.secret)
				tracklist |= T
