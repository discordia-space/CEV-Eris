/*********************************
For the main html chat area
*********************************/
GLOBAL_VAR_INIT(goonchatbasehtml, file2text('code/modules/goonchat/browserassets/html/browserOutput.html'))

//On client, created on login
/datum/chatOutput
	var/client/owner	 //client ref
	var/loaded       = FALSE // Has the client loaded the browser output area?
	var/list/messageQueue //If they haven't loaded chat, this is where messages will go until they do
	var/cookieSent   = FALSE // Has the client sent a cookie for analysis
	var/broken       = FALSE
	var/list/connectionHistory //Contains the connection history passed from chat cookie
	var/adminMusicVolume = 25 //This is for the Play Global Sound verb

/datum/chatOutput/New(client/C)
	owner = C
	messageQueue = list()
	connectionHistory = list()

/datum/chatOutput/proc/start()
	//Check for existing chat
	if(!owner)
		return FALSE

	if(!winexists(owner, "browseroutput")) // Oh goddamnit.
		set waitfor = FALSE
		broken = TRUE
		message_admins("Couldn't start chat for [key_name_admin(owner)]!")
		. = FALSE
		alert(owner.mob, "Updated chat window does not exist. If you are using a custom skin file please allow the game to update.")
		return

	if(winget(owner, "browseroutput", "is-visible") == "true") //Already setup
		doneLoading()

	else //Not setup
		load()

	return TRUE

/datum/chatOutput/proc/load()
	set waitfor = FALSE
	if(!owner)
		return

	var/datum/asset/group/gc = get_asset_datum(/datum/asset/group/goonchat)

	if (gc.send(owner))
		owner.browse_queue_flush() // stall loading html until goochant actualy gets sent

	var/html = GLOB.goonchatbasehtml
	html = replacetextEx(html, "%FONTAWESOME%", SSassets.transport.get_asset_url("font-awesome.css"))

	owner << browse(html, "window=browseroutput")

/datum/chatOutput/Topic(href, list/href_list)
	if(usr.client != owner)
		return TRUE

	// Build arguments.
	// Arguments are in the form "param[paramname]=thing"
	var/list/params = list()
	for(var/key in href_list)
		if(length_char(key) > 7 && findtext(key, "param")) // 7 is the amount of characters in the basic param key template.
			var/param_name = copytext_char(key, 7, -1)
			var/item       = href_list[key]

			params[param_name] = item

	var/data // Data to be sent back to the chat.
	switch(href_list["proc"])
		if("doneLoading")
			data = doneLoading(arglist(params))

		if("debug")
			data = debug(arglist(params))

		if("ping")
			data = ping(arglist(params))

		if("analyzeClientData")
			data = analyzeClientData(arglist(params))

		if("setMusicVolume")
			data = setMusicVolume(arglist(params))
		if("swaptodarkmode")
			swaptodarkmode()
		if("swaptolightmode")
			swaptolightmode()

	if(data)
		ehjax_send(data = data)


//Called on chat output done-loading by JS.
/datum/chatOutput/proc/doneLoading()
	if(loaded)
		return

	loaded = TRUE
	showChat()


	for(var/message in messageQueue)
		// whitespace has already been handled by the original to_chat
		to_chat(owner, message, handle_whitespace=FALSE)

	messageQueue = null
	sendClientData()

	//do not convert to to_chat()
	owner << "<span class=\"userdanger\">Failed to load fancy chat, reverting to old chat. Certain features won't work.</span>"

/datum/chatOutput/proc/showChat()
	winset(owner, "output", "is-visible=false")
	winset(owner, "browseroutput", "is-disabled=false;is-visible=true")

/datum/chatOutput/proc/ehjax_send(client/C = owner, window = "browseroutput", data)
	if(islist(data))
		data = json_encode(data)
	C << output("[data]", "[window]:ehjaxCallback")

/datum/chatOutput/proc/sendMusic(music, list/extra_data)
	if(!findtext(music, GLOB.is_http_protocol))
		return
	var/list/music_data = list("adminMusic" = url_encode(url_encode(music)))

	if(extra_data?.len)
		music_data["musicRate"] = extra_data["pitch"]
		music_data["musicSeek"] = extra_data["start"]
		music_data["musicHalt"] = extra_data["end"]

	ehjax_send(data = music_data)

/datum/chatOutput/proc/stopMusic()
	ehjax_send(data = "stopMusic")

/datum/chatOutput/proc/setMusicVolume(volume = "")
	if(volume)
		adminMusicVolume = CLAMP(text2num(volume), 0, 100)

//Sends client connection details to the chat to handle and save
/datum/chatOutput/proc/sendClientData()
	//Get dem deets
	var/list/deets = list("clientData" = list())
	deets["clientData"]["ckey"] = owner.ckey
	deets["clientData"]["ip"] = owner.address
	deets["clientData"]["compid"] = owner.computer_id
	var/data = json_encode(deets)
	ehjax_send(data = data)

//Called by client, sent data to investigate (cookie history so far)
/datum/chatOutput/proc/analyzeClientData(cookie = "")
	if(!cookie)
		return

	if(cookie != "none")
		var/regex/crashy_thingy = regex("^\\s*(\[\\\[\\{\\}\\\]\]\\s*){5,}")
		if(crashy_thingy.Find(cookie))
			log_and_message_admins("[key_name(owner)] tried to crash the server using at least 5 \"\[\" in a row. Ban them.")
			return

		var/list/connData = json_decode(cookie)
		if (connData && islist(connData) && connData.len > 0 && connData["connData"])
			connectionHistory = connData["connData"] //lol fuck
			var/list/found = new()
			for(var/i in connectionHistory.len to 1 step -1)
				var/list/row = src.connectionHistory[i]
				if (!row || row.len < 3 || (!row["ckey"] || !row["compid"] || !row["ip"])) //Passed malformed history object
					return
				if (world.IsBanned(row["ckey"], row["ip"], row["compid"], real_bans_only=TRUE))
					found = row
					break

			//Uh oh this fucker has a history of playing on a banned account!!
			if (found.len > 0)
				//TODO: add a new evasion ban for the CURRENT client details, using the matched row details
				message_admins("[key_name(src.owner)] has a cookie from a banned account! (Matched: [found["ckey"]], [found["ip"]], [found["compid"]])")
				//log_admin_private("[key_name(owner)] has a cookie from a banned account! (Matched: [found["ckey"]], [found["ip"]], [found["compid"]])")

	cookieSent = TRUE

//Called by js client every 60 seconds
/datum/chatOutput/proc/ping()
	return "pong"

//Called by js client on js error
/datum/chatOutput/proc/debug(error)
	log_world("\[[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]\] Client: [(src.owner.key ? src.owner.key : src.owner)] triggered JS error: [error]")

//Global chat procs
/proc/to_chat_immediate(target, message, handle_whitespace = TRUE)
	if(!target || !message)
		return

	if(target == world)
		target = clients

	var/original_message = message
	if(handle_whitespace)
		message = replacetext(message, "\n", "<br>")
		message = replacetext(message, "\t", "[GLOB.TAB][GLOB.TAB]")

	//Replace expanded \icon macro with icon2html
	//regex/Replace with a proc won't work here because icon2html takes target as an argument and there is no way to pass it to the replacement proc
	//not even hacks with reassigning usr work
	var/regex/i = new(@/<IMG CLASS=icon SRC=(\[[^]]+])(?: ICONSTATE='([^']+)')?>/, "g")
	while(i.Find(message))
		message = copytext(message,1,i.index)+icon2html(locate(i.group[1]), target, icon_state=i.group[2])+copytext(message,i.next)

	message = \
		symbols_to_unicode(
			strip_improper(
				color_macro_to_html(
					message
				)
			)
		)

	if(islist(target))
		// Do the double-encoding outside the loop to save nanoseconds
		var/twiceEncoded = url_encode(url_encode(message))
		for(var/I in target)
			var/client/C = CLIENT_FROM_VAR(I) //Grab us a client if possible

			if (!C)
				continue

			//Send it to the old style output window.
			C << original_message

			if(!C.chatOutput || C.chatOutput.broken) // A player who hasn't updated his skin file.
				continue

			if(!C.chatOutput.loaded)
				//Client still loading, put their messages in a queue
				C.chatOutput.messageQueue += message
				continue

			C << output(twiceEncoded, "browseroutput:output")
	else
		var/client/C = CLIENT_FROM_VAR(target) //Grab us a client if possible

		if (!C)
			return

		//Send it to the old style output window.
		C << original_message

		if(!C.chatOutput || C.chatOutput.broken) // A player who hasn't updated his skin file.
			return

		if(!C.chatOutput.loaded)
			//Client still loading, put their messages in a queue
			C.chatOutput.messageQueue += message
			return

		// url_encode it TWICE, this way any UTF-8 characters are able to be decoded by the Javascript.
		C << output(url_encode(url_encode(message)), "browseroutput:output")

/datum/chatOutput/proc/swaptolightmode() //Dark mode light mode stuff. Yell at KMC if this breaks! (See darkmode.dm for documentation)
	owner.force_white_theme()

/datum/chatOutput/proc/swaptodarkmode()
	owner.force_dark_theme()

/proc/to_chat(target, message, handle_whitespace = TRUE)
	if(Master.current_runlevel == RUNLEVEL_INIT || !SSchat?.initialized)
		to_chat_immediate(target, message, handle_whitespace)
		return
	SSchat.queue(target, message, handle_whitespace)

