//
// Load the list of available69usic tracks for the jukebox (or other things that use69usic)
//

//69usic track available for playing in a69edia69achine.
/datum/track
	var/url			// URL to load song from
	var/title		// Song title
	var/artist		// Song's creator
	var/duration	// Song length in deciseconds
	var/secret		// Show up in regular playlist or secret playlist?
	var/lobby		// Be one of the choices for lobby69usic?
	var/playlist	//Song's playlist (used for tapes)

/datum/track/New(var/url,69ar/title,69ar/duration,69ar/artist = "",69ar/secret = 0,69ar/lobby = 0,69ar/playlist)
	src.url = url
	src.title = title
	src.artist = artist
	src.duration = duration
	src.secret = secret
	src.lobby = lobby
	src.playlist = playlist

/datum/track/proc/display()
	var str = "\"69title69\""
	if(artist)
		str += " by 69artist69"
	return str

/datum/track/proc/toNanoList()
	return list("ref" = "\ref69src69", "title" = title, "artist" = artist, "duration" = duration)


// Global list holding all configured jukebox tracks
GLOBAL_LIST_EMPTY(all_playlists)
GLOBAL_LIST_EMPTY(all_jukebox_tracks)
GLOBAL_LIST_EMPTY(all_lobby_tracks)

// Read the jukebox configuration file on system startup.
/hook/startup/proc/load_jukebox_tracks()
	var/jukebox_track_file = "config/jukebox.json"
	if(!fexists(jukebox_track_file))
		warning("File69ot found: 69jukebox_track_file69")
		return 1
	var/list/jsonData = json_decode(file2text(jukebox_track_file))
	if(!istype(jsonData))
		warning("Failed to read tracks from 69jukebox_track_file69, json_decode failed.")
	for(var/entry in jsonData)
		if(!istext(entry69"url"69))
			warning("69jukebox_track_file69 entry 69entry69: bad or69issing 'url'")
			continue
		if(!istext(entry69"title"69))
			warning("69jukebox_track_file69 entry 69entry69: bad or69issingg 'title'")
			continue
		if(!isnum(entry69"duration"69))
			warning("69jukebox_track_file69 entry 69entry69: bad or69issing 'duration'")
			continue
		var/datum/track/T =69ew(entry69"url"69, entry69"title"69, entry69"duration"69, entry69"playlist"69)
		if(istext(entry69"artist"69))
			T.artist = entry69"artist"69
		T.secret = entry69"secret"69 ? 1 : 0
		T.lobby = entry69"lobby"69 ? 1 : 0
		if(istext(entry69"playlist"69))
			T.playlist = entry69"playlist"69
			if(!(T.playlist in GLOB.all_playlists))
				GLOB.all_playlists += T.playlist
		GLOB.all_jukebox_tracks += T
		if(T.lobby)
			GLOB.all_lobby_tracks += T
	return 1


