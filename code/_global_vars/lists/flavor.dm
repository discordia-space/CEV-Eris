GLOBAL_LIST_INIT(greek_letters, list("Alpha", "Beta", "Gamma", "Delta",
	"Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu",
	"Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi",
	"Chi", "Psi", "Omega"))

GLOBAL_LIST_INIT(phonetic_alphabet, list("Alpha", "Bravo", "Charlie",
	"Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliet",
	"Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec",
	"Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "X-ray",
	"Yankee", "Zulu"))

GLOBAL_LIST_INIT(music_tracks, list(
	"Beyond" = /music_track/ambispace,
	"Clouds of Fire" = /music_track/clouds_of_fire,
	"Stage Three" = /music_track/dilbert,
	"Asteroids" = /music_track/df_theme,
	"Floating" = /music_track/floating,
	"Endless Space" = /music_track/endless_space,
	"Fleet Party Theme" = /music_track/one_loop,
	"Scratch" = /music_track/level3_mod,
	"Absconditus" = /music_track/absconditus,
	"lasers rip apart the bulkhead" = /music_track/lasers,
	"Maschine Klash" = /music_track/digit_one,
	"Comet Halley" = /music_track/comet_haley,
	"Please Come Back Any Time" = /music_track/elevator,
	"Human" = /music_track/human,
	"Memories of Lysendraa" = /music_track/lysendraa,
	"Marhaba" = /music_track/marhaba,
	"Space Oddity" = /music_track/space_oddity,
	"THUNDERDOME" = /music_track/thunderdome,
	"Torch: A Light in the Darkness" = /music_track/torch,
	"Treacherous Voyage" = /music_track/treacherous_voyage,
	"Wake" = /music_track/wake,
	"phoron will make us rich" = /music_track/pwmur,
	"every light is blinking at once" = /music_track/elibao,
	"In Orbit" = /music_track/inorbit,
	"Martian Cowboy" = /music_track/martiancowboy,
	"Monument" = /music_track/monument,
	"As Far As It Gets" = /music_track/asfarasitgets,
	"80s All Over Again" = /music_track/eighties,
	"Wild Encounters" = /music_track/wildencounters,
	"Torn" = /music_track/torn,
	"Nebula" = /music_track/nebula
))

/proc/setup_music_tracks(var/list/tracks)
	. = list()
	var/track_list = LAZYLEN(tracks) ? tracks : GLOB.music_tracks
	for(var/track_name in track_list)
		var/track_path = track_list[track_name]
		. += new/datum/track(track_name, track_path)
