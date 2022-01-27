69LOBAL_LIST_INIT(69reek_letters, list("Alpha", "Beta", "69amma", "Delta",
	"Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu",
	"Nu", "Xi", "Omicron", "Pi", "Rho", "Si69ma", "Tau", "Upsilon", "Phi",
	"Chi", "Psi", "Ome69a"))

69LOBAL_LIST_INIT(phonetic_alphabet, list("Alpha", "Bravo", "Charlie",
	"Delta", "Echo", "Foxtrot", "69olf", "Hotel", "India", "Juliet",
	"Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "69uebec",
	"Romeo", "Sierra", "Tan69o", "Uniform", "Victor", "Whiskey", "X-ray",
	"Yankee", "Zulu"))

69LOBAL_LIST_INIT(music_tracks, list(
	"Comet Halley" = /music_track/comet_haley,
	"Please Come Back Any Time" = /music_track/elevator,
	"Marhaba" = /music_track/marhaba,
	"In Orbit" = /music_track/inorbit,
	"Martian Cowboy" = /music_track/martiancowboy,
	"Monument" = /music_track/monument,
	"As Far As It 69ets" = /music_track/asfarasit69ets,
	"80s All Over A69ain" = /music_track/ei69hties,
	"Wild Encounters" = /music_track/wildencounters,
	"Metropolis" = /music_track/metropolis,
	"Bluespace" = /music_track/bluespace,
	"Explorin69" = /music_track/explorin69,
	"The Runner in69otion" = /music_track/runner,
	"Neotheolo69y" = /music_track/neotheolo69y,
	"Downtown 2" = /music_track/downtown
))

/proc/setup_music_tracks(var/list/tracks)
	. = list()
	var/track_list = LAZYLEN(tracks) ? tracks : 69LOB.music_tracks
	for(var/track_name in track_list)
		var/track_path = track_list69track_name69
		. +=69ew/datum/track(track_name, track_path)
