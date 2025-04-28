// DO NOT TICK THIS FILE
// This file is a template for creating lobby screens.


/**
 * -- Welcome to the template for lobby screens --
 *
 * To start, copy this file and rename it to your username, or author name.
 *
 * All lobby screen image files are located in the /icons/title_screens/ directory.
 * Within that directory, they should follow a path based on your username, then work name, like this:
 * /icons/title_screens/YourArtistName/YourLobbyScreen.png
 *
 * Music is similar, but it should be in the /sound/music/lobby/ directory.
 * The format should be sound/music/lobby/ArtistName-SongName.ogg and the
 * file type should be ogg.
**/


// This is the base path for your lobby screens. If you have multiple lobby screens,
// you will create a new datum for each one using your base path below.

/datum/lobbyscreen/myArtistName
	// Name of the artist who made this lobby screen
	art_artist_name = "myArtistName"
	// A link to the artists social media or website
	art_artist_link = "https://www.instagram.com/myArtistName"

// For each lobby screen, you will create a new datum with the path below, changing the last part
// to the specific name of your lobby screen. For example, if your lobby screen image is named
// "MyCoolLobby.png", you would use the path `/datum/lobbyscreen/YourArtistName/MyCoolLobby`.
/datum/lobbyscreen/myArtistName/mylobbyscreenname
	image_file = 'icons/title_screens/myArtistName/mylobbyscreen.png'
	// insert songs in this list.
	// The format should be sound/music/lobby/ArtistName-SongName.ogg
	possibleMusic = list(
		'sound/music/lobby/myArtistName-ReplaceMeWithYourSongName.ogg',
		'sound/music/lobby/myArtistName-ReplaceMeWithYourSongName-2.ogg',
	)

/datum/lobbyscreen/myArtistName/myOtherlobbyscreenname
	image_file = 'icons/title_screens/myArtistName/myotherlobbyscreen.png'
	possibleMusic = list(
		'sound/music/lobby/myArtistName-ReplaceMeWithYourSongName-3.ogg',
		'sound/music/lobby/myArtistName-ReplaceMeWithYourSongName-4.ogg',
	)
