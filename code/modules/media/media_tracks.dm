//
// Load the list of available music tracks for the jukebox (or other things that use music)
//

// Music track available for playing in a media machine.
/datum/track
	var/url			// URL to load song from
	var/title		// Song title
	var/artist		// Song's creator
	var/duration	// Song length in deciseconds
	var/secret		// Show up in regular playlist or secret playlist?
	var/lobby		// Be one of the choices for lobby music?

/datum/track/New(var/url, var/title, var/duration, var/artist = "", var/secret = 0, var/lobby = 0)
	src.url = url
	src.title = title
	src.artist = artist
	src.duration = duration
	src.secret = secret
	src.lobby = lobby

/datum/track/proc/display()
	var str = "\"[title]\""
	if(artist)
		str += " by [artist]"
	return str

/datum/track/proc/toNanoList()
	return list("ref" = "\ref[src]", "title" = title, "artist" = artist, "duration" = duration)


// Global list holding all configured jukebox tracks
var/global/list/all_jukebox_tracks = list()
var/global/list/all_lobby_tracks = list()

// Read the jukebox configuration file on system startup.
/hook/startup/proc/load_jukebox_tracks()
	var/jukebox_track_file = "config/jukebox.json"
	if(!fexists(jukebox_track_file))
		warning("File not found: [jukebox_track_file]")
		return 1
	var/list/jsonData = json_decode(file2text(jukebox_track_file))
	if(!istype(jsonData))
		warning("Failed to read tracks from [jukebox_track_file], json_decode failed.")
	for(var/entry in jsonData)
		if(!istext(entry["url"]))
			warning("[jukebox_track_file] entry [entry]: bad or missing 'url'")
			continue
		if(!istext(entry["title"]))
			warning("[jukebox_track_file] entry [entry]: bad or missingg 'title'")
			continue
		if(!isnum(entry["duration"]))
			warning("[jukebox_track_file] entry [entry]: bad or missing 'duration'")
			continue
		var/datum/track/T = new(entry["url"], entry["title"], entry["duration"])
		if(istext(entry["artist"]))
			T.artist = entry["artist"]
		T.secret = entry["secret"] ? 1 : 0
		T.lobby = entry["lobby"] ? 1 : 0
		all_jukebox_tracks += T
		if(T.lobby)
			all_lobby_tracks += T
	return 1


